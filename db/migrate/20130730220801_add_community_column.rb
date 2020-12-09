class AddCommunityColumn < ActiveRecord::Migration[5.0]
  def up
    add_column :pull_requests, :from_community, :boolean
  end

  def down
  end
end
