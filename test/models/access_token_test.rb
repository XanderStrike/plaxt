# == Schema Information
#
# Table name: access_tokens
#
#  id            :integer          not null, primary key
#  uid           :string
#  access_token  :string
#  token_type    :string
#  expires_in    :string
#  refresh_token :string
#  scope         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class AccessTokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
