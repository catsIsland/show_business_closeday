class CreateDaiNumberCloseDays < ActiveRecord::Migration[6.1]
  def change
    create_table :dai_number_close_days do |t|
      t.references :user, null: false, foreign_key: true
      t.string :dai_week_number
      t.string :dai_close_day_number

      t.timestamps
    end
  end
end
