# frozen_string_literal: true
require 'pp'

class TraktService
  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']
  REDIRECT_URI = 'http://plaxt.herokuapp.com'

  class << self
    def build_auth_link
      "https://trakt.tv/oauth/authorize?client_id=#{CLIENT_ID}&redirect_uri=http%3A%2F%2Fplaxt.herokuapp.com%3Fusername=USERNAME&response_type=code"
    end

    def get_token(code, username)
      values = {
        code: code,
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        redirect_uri: "#{REDIRECT_URI}?username=#{username}",
        grant_type: 'authorization_code'
      }

      headers = {
        content_type: 'application/json'
      }

      response = RestClient.post 'https://api.trakt.tv/oauth/token', JSON.generate(values), headers
      JSON.parse(response)
    end

    def scrobble_movie(info, access_token)
      values = {
        movie: find_movie(info['Metadata']['title'], info['Metadata']['year']),
        progress: 90.0,
        app_version: '1.0',
        app_date: '2017-09-22'
      }

      headers = {
        content_type: 'application/json',
        authorization: "Bearer #{access_token.access_token}",
        trakt_api_version: '2',
        trakt_api_key: CLIENT_ID
      }

      response = RestClient.post 'https://api.trakt.tv/scrobble/stop', JSON.generate(values), headers
      JSON.parse(response)
    end

    def scrobble_episode(info, access_token)
      guid = info['Metadata']['guid'].match(/thetvdb:\/\/(\d*)\/(\d*)\/(\d)*/)

      values = {
        episode: find_episode(guid[1].to_i, guid[2].to_i, guid[3].to_i),
        progress: 90.0,
        app_version: '1.0',
        app_date: '2017-09-22'
      }

      headers = {
        content_type: 'application/json',
        authorization: "Bearer #{access_token.access_token}",
        trakt_api_version: '2',
        trakt_api_key: CLIENT_ID
      }

      response = RestClient.post 'https://api.trakt.tv/scrobble/stop', JSON.generate(values), headers
      JSON.parse(response)
    end

    # private

    def find_episode(id, season, episode)
      headers = {
        content_type: 'application/json',
        trakt_api_version: '2',
        trakt_api_key: CLIENT_ID
      }

      response = RestClient.get "https://api.trakt.tv/search/tvdb/#{id}?type=show", headers
      trakt_id = JSON.parse(response).first['show']['ids']['trakt']

      response = RestClient.get "https://api.trakt.tv/shows/#{trakt_id}/seasons?extended=episodes", headers
      JSON.parse(response).find { |s| s['number'] == season }['episodes'].find { |e| e['number'] == episode }
    end

    def find_show(title)
      headers = {
        content_type: 'application/json',
        trakt_api_version: '2',
        trakt_api_key: CLIENT_ID
      }

      response = RestClient.get "https://api.trakt.tv/search/movie?query=#{title}", headers
      JSON.parse(response).each do |movie|
        return movie['movie'] if movie['movie']['year'].to_i == year.to_i
      end
    end

    def find_movie(title, year)
      headers = {
        content_type: 'application/json',
        trakt_api_version: '2',
        trakt_api_key: CLIENT_ID
      }

      response = RestClient.get "https://api.trakt.tv/search/movie?query=#{title}", headers
      JSON.parse(response).each do |movie|
        return movie['movie'] if movie['movie']['year'].to_i == year.to_i
      end
    end
  end
end
