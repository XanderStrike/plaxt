class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    payload = JSON.parse(params['payload'])

    access_token = AccessToken.where(uid: params[:uid]).first
    return unless payload['Account']['title'].downcase == access_token.username.downcase

    case payload['Metadata']['librarySectionType']
    when 'show'
      TraktService.submit_episode(payload['event'].gsub('media.', ''), payload, access_token)
    when 'movie'
      TraktService.submit_movie(payload['event'].gsub('media.', ''), payload, access_token)
    end
  end
end
