# == Schema Information
#
# Table name: settings
#
#  id               :bigint           not null, primary key
#  background_color :string(255)      default("CC0000"), not null
#  element_id_flag  :boolean          default(TRUE), not null
#  element_name     :string(255)
#  font_color       :string(255)      default("FFFFFF"), not null
#  publish          :boolean          default(FALSE), not null
#  title            :string(255)
#  weekly_days      :string(255)
#  weekly_repeat    :boolean          default(TRUE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_settings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Setting < ApplicationRecord
  belongs_to :user
end
