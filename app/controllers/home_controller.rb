class HomeController < ApplicationController
  def index
    if params[:code]
      token_params = TraktService.get_token(params[:code], params[:username], request.base_url)
      token_params.merge!(created_at: nil, uid: SecureRandom.hex(10), username: params[:username])
      @token = AccessToken.new(token_params)
      @success = @token.save
      return render :auth
    end
  end
end
