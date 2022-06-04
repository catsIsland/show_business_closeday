class ChangeColumnToSetting < ActiveRecord::Migration[6.1]
  def change
    change_column_default :settings, :background_color, from: 'CC000', to: 'CC0000'
  end
end
