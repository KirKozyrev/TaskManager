class Api::V1::TasksController < Api::V1::ApplicationController
  def index
    tasks = Task.
      includes([:author, :assignee]).
      ransack(ransack_params).
      result.
      order(created_at: :desc).
      page(page).
      per(per_page)

    respond_with(tasks, each_serializer: TaskSerializer, root: 'items', meta: build_meta(tasks))
  end

  def show
    task = Task.find(params[:id])

    respond_with(task, serializer: TaskSerializer)
  end

  def create
    task = current_user.my_tasks.new(task_params)
    
    if task.save
      SendTaskCreateNotificationJob.perform_async(task.id)
    end

    respond_with(task, serializer: TaskSerializer, location: nil)
  end

  def update
    task = Task.find(params[:id])

    if params[:file] && params[:file][:data_url].present?
      file = decode_file(params[:file])
      task.file.attach(io: File.open(file), filename: "task_file#{File.extname(file)}")
      File.delete(file)
    end

    if task.update(task_params)
      SendTaskUpdateNotificationJob.perform_async(task.id)
    end
    
    respond_with(task, serializer: TaskSerializer)
  end

  def destroy
    task = Task.find(params[:id])
    task_id = task.id
    task_author = task.author_id

    if task.destroy
      SendTaskDeleteNotificationJob.perform_async(task_id, task_author)
    end

    respond_with(task, serializer: TaskSerializer)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :expired_at, :author_id, :assignee_id, :state_event, :file)
  end

  def decode_file(data)
    data_url = data[:data_url]
    data_url_start = data_url.index ';base64,'
    data_url = data_url[(data_url_start + 8)..-1]

    file = File.new(data[:name], 'wb')
    file.write(Base64.decode64(data_url))
    file
  end
end
