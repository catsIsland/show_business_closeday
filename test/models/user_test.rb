# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  account_delete  :boolean          default(FALSE), not null
#  admin_authority :boolean          default(FALSE), not null
#  mail            :string(255)      not null
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  publish         :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_name_and_mail  (name,mail) UNIQUE
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
