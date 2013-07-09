class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.find_all_by_id_user(
      cookies.signed[:remember_token][0])
    @tasks = Task.find(:all, order: :project_id, order: :priority)
    @new_task = Task.new
    respond_to do |format|
      format.html { render "_index" } # index.html.erb
      format.json { render json: @projects }
      format.js
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    if cookies.signed[:remember_token][0] != @project.id_user
      redirect_to projects_path
    else
      respond_to do |format|
        format.html { render "_edit" }
        format.js
      end
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new
    @project.id_user = cookies.signed[:remember_token][0]
    
  
    projects = Project.where('id_user = ? and name like ?', @project.id_user, 'New project%').count
   @project.name = 'New project'
   if projects > 0
    @project.name += " #{projects}"
   end
    
    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path }
        format.json { render json: @project, status: :created, location: @project }
        format.js { redirect_to projects_path }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to projects_path }
        format.json { head :no_content }
        format.js { redirect_to projects_path }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @id = @project.id
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
      format.js
    end
  end
end
