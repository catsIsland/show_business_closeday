# == Schema Information
#
# Table name: dai_number_close_days
#
#  id                   :bigint           not null, primary key
#  dai_close_day_number :string(255)
#  dai_week_number      :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_dai_number_close_days_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class DaiNumberCloseDay < ApplicationRecord
  belongs_to :user
end
