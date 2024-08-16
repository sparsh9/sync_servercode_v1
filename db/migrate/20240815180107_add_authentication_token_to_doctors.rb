class AddAuthenticationTokenToDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :authentication_token, :string
    add_index :doctors, :authentication_token, unique: true
  end
end