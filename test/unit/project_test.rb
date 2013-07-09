require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "do not save without title" do
  	project = Project.new
  	assert !project.save, "Saved the project without a title"
  end

  
end
