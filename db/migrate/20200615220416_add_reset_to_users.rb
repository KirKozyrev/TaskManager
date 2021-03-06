class AddResetToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :reset_digest, :string
    add_index :users, :reset_digest, unique: true
    add_column :users, :reset_sent_at, :datetime
  end
end
