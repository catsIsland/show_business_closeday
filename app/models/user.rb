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
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_name_and_mail  (name,mail) UNIQUE
#
class User < ApplicationRecord
  has_many :settings, dependent: :destroy
  has_many :DaiNumberCloseDay, dependent: :destroy

  has_secure_password
  
  validates :name,
    presence: true,
    uniqueness: true,
    length: { maximum: 16 },
    format: {
      with: /\A[a-z0-9]+\z/,
      message: 'は小文字英数字で入力してください'
    }
  validates :password,
    length: { minimum: 8 }
end
