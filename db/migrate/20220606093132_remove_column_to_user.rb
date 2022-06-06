class RemoveColumnToUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :tag_name
    remove_column :users, :publish
  end
end
