class CreateAccount < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :first_name
      t.string :last_name
      t.bigint :phone_number
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
