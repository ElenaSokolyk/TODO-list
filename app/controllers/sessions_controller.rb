class SessionsController < ApplicationController
  def new
    respond_to do |format|
      format.html { render '_new' } # new.html.erb
      format.js
    end
  end

  def create
    user = User.authenticate(params[:session][:name],
                             params[:session][:virtual_password])
    if !user.nil?
      sign_in user
      redirect_to projects_path
    else
      flash.now[:error] = 'Invalid name/password combitation'
      render 'new'
    end
  end
end

