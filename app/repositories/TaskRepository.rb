module TaskRepository
  extend ActiveSupport::Concern

  included do
    state_machine initial: :new_task do
      state :new_task
      state :in_development
      state :in_qa
      state :in_code_review
      state :ready_for_release
      state :released
      state :archived

      event :to_development do
        transition new_task: :in_development
        transition in_qa: :in_development
        transition in_code_review: :in_development
      end

      event :to_qa do
        transition in_development: :in_qa
      end

      event :to_code_review do
        transition in_qa: :in_code_review
      end

      event :to_ready_for_release do
        transition in_code_review: :ready_for_release
      end

      event :to_released do
        transition ready_for_release: :released
      end

      event :to_archive do
        transition new_task: :archived
        transition released: :archived
      end
    end
  end
end
