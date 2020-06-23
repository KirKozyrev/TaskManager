class TaskSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :description, :state, :expired_at, :transitions, :file
  belongs_to :author
  belongs_to :assignee

  def transitions
    object.state_transitions.map do |transiion|
      {
        event: transiion.event,
        from: transiion.from,
        to: transiion.to,
      }
    end
  end

  def file
    if object.file.attached?
      {
        url: rails_blob_url(object.file),
      }
    end
  end
end
