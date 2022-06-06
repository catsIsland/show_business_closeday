class AddColumnToSetting3 < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :tag_name, :string
  end
end
