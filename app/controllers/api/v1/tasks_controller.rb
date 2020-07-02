class Api::V1::TasksController < Api::V1::ApplicationController
  before_action :params_from_formdata, only: [:attach_image]

  def index
    tasks = Task.
      includes([:author, :assignee]).
      with_attached_image.
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

  def attach_image 
    task = Task.find(params[:id])
    task_attach_image_form = TaskAttachImageForm.new(attachment_params)

    if task_attach_image_form.invalid?
      respond_with task_attach_image_form
      return
    end

    image = task_attach_image_form.processed_image
    task.image.attach(image)

    respond_with(task, serializer: TaskSerializer)
  end
    
  def remove_image 
    task = Task.find(params[:id])
    task.image.purge

    respond_with(task, serializer: TaskSerializer)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :expired_at, :author_id, :assignee_id, :state_event)
  end

  def attachment_params
    params.require(:attachment).permit(:image, :crop_x, :crop_y, :crop_width, :crop_height)
  end

  def params_from_formdata
    params[:attachment] = {} if params[:attachment].nil?
    params.each do |key, value|
      params[:attachment][key] = value
    end
    params
  end
end
