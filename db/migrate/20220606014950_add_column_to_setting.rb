class AddColumnToSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :others_close_days, :string
  end
end
