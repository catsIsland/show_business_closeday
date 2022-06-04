class AddSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :weekly_days, :string
  end
end
