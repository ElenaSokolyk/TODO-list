class Project < ActiveRecord::Base
	has_many :task, dependent: :destroy
	belongs_to :user

	validates :name, :id_user, presence: true
	
	validates :id_user, numericality: {greater_than_or_equal_to: 1}

end
