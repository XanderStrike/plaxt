class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    payload = JSON.parse(params['payload'])
    return unless payload['event'] == 'media.scrobble'

    access_token = AccessToken.where(uid: params[:uid]).first
    return unless payload['Account']['title'].downcase == access_token.username.downcase

    case payload['Metadata']['librarySectionType']
    when 'show'
      TraktService.scrobble_episode(payload, access_token)
    when 'movie'
      TraktService.scrobble_movie(payload, access_token)
    end
  end
end
