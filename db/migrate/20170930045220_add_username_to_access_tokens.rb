class AddUsernameToAccessTokens < ActiveRecord::Migration[5.1]
  def change
    add_column :access_tokens, :username, :string
  end
end
