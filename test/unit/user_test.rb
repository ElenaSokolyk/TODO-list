require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "dont save without title" do
  	user = User.new
  	assert !user.save, "Saved the user without a title"
  end
  
end
