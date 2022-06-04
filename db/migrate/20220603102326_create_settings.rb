class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :publish, default: false, null: false
      t.boolean :weekly_repeat, default: true, null: false
      t.boolean :element_id_flag, default: true, null: false
      t.string :title
      t.string :element_name
      t.string :background_color, default: 'CC000', null: false
      t.string :font_color, default: 'FFFFFF', null: false
      t.timestamps
    end
  end
end
