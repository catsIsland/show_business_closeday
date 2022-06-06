class AddColumnToSetting2 < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :next_month_others_close_days, :string
  end
end
