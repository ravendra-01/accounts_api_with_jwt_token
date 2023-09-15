module AccountBlock
  class Account < ApplicationRecord
    self.table_name = :accounts

    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true
  end
end
