class TasksController < ApplicationController
  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @project = Project.find(params[:project_id])
    respond_to do |format|
      format.html { render '_edit' }
      format.js
    end
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @project = Project.find(params[:project_id]) 
    @task = @project.task.build 
    @task.name = params[:task][:name]
    if @task.name.empty? 
      @task.name = "New task" 
    end
    tasks = Task.find_all_by_project_id(@task.project_id)
    @task.priority = tasks.count
    @task.status = false
    @task.deadline = Time.now

    respond_to do |format|
      if @task.save
        format.html { redirect_to projects_path }
        format.json { render json: @task, status: :created, location: @task }
        format.js { redirect_to projects_path }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to projects_path }
        format.json { head :no_content }
        format.js { redirect_to projects_path }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to projects_path }
      format.json { head :no_content }
      format.js
    end
  end

  def priority_high
    task = Task.find(params[:id])
    priority = task.priority
    if priority > 0 
      priority -= 1
      prev_task = Task.find_by_project_id_and_priority(task.project_id, priority)
      task.priority = priority
      prev_task.priority = priority + 1
      task.save
      prev_task.save
    end
    redirect_to projects_path 
  end

  def priority_low
    task = Task.find(params[:id])
    tasks = Task.find_all_by_project_id(task.project_id)
    priority = task.priority
    if (tasks.count-1) > task.priority
      priority += 1
      next_task = Task.find_by_project_id_and_priority(task.project_id, priority)
      task.priority = priority
      next_task.priority = priority - 1
      task.save
      next_task.save
    end
    redirect_to projects_path
  end

  def completed
    @task = Task.find(params[:id])
    @task.status = !@task.status
    @task.save
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js
    end
  end
end
