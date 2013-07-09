class UsersController < ApplicationController
  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    respond_to do |format|
      format.html { render '_new' } # new.html.erb
      format.js
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    if @user.save
        user = User.authenticate(params[:user][:name], params[:user][:virtual_password])
        if user.nil?
          flash.now[:error] = 'Invalid name/password combitation'
          redirect_to sign_in_path
        else
          sign_in user
          redirect_to projects_path
        end
    else
      render "new"
    end    
  end
end
