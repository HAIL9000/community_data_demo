class AddStateColumn < ActiveRecord::Migration[5.0]
  def up
    add_column :pull_requests, :closed, :boolean
  end

  def down
  end
end
