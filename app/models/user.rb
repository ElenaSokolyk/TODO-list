class User < ActiveRecord::Base
	has_many :project

	attr_accessor :virtual_password
    attr_accessible :name, :virtual_password, :virtual_password_confirmation, :salt

    validates :name, presence: true,
    	             uniqueness: true

    validates :virtual_password, presence: true, 
    	                         confirmation: true,
                                 length: { within: 6..40 }
    before_save :encript_password

  def has_password?(submitted_password)
    password == encript(submitted_password)
  end

    def self.authenticate(name, submitted_password)
    user = User.find_by_name(name)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private
    def encript_password
      self.salt = make_salt if new_record?
      self.password = encript(virtual_password)
    end
    
    def encript(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      self.salt = secure_hash("#{Time.now.utc}--#{virtual_password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
