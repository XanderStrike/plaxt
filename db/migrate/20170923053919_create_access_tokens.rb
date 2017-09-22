class CreateAccessTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :access_tokens do |t|
      t.string :uid
      t.string :access_token
      t.string :token_type
      t.string :expires_in
      t.string :refresh_token
      t.string :scope
      t.string :created_at

      t.timestamps
    end

    add_index(:access_tokens, :uid)
  end
end
