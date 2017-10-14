# frozen_string_literal: true
require 'pp'

class TraktService
  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']

  ROUTE_DICT = {
    'play' => 'start',
    'pause' => 'pause',
    'resume' => 'start',
    'stop' => 'stop',
    'scrobble' => 'stop'
  }.freeze

  PROGRESS_DICT = {
    'play' => 0.0,
    'pause' => nil,
    'resume' => nil,
    'stop' => nil,
    'scrobble' => 90.0
  }.freeze

  class << self
    def build_auth_link(redirect_uri)
      "https://trakt.tv/oauth/authorize?client_id=#{CLIENT_ID}&redirect_uri=#{URI.encode(redirect_uri)}%3Fusername=USERNAME&response_type=code"
    end

    def get_token(code, username, redirect_uri)
      values = {
        code: code,
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        redirect_uri: "#{redirect_uri}?username=#{username}",
        grant_type: 'authorization_code'
      }

      headers = {
        content_type: 'application/json'
      }

      response = RestClient.post 'https://api.trakt.tv/oauth/token', JSON.generate(values), headers
      JSON.parse(response)
    end

    def submit_movie(action, info, access_token)
      values = {
        movie: find_movie(info['Metadata']['title'], info['Metadata']['year']),
        progress: PROGRESS_DICT[action],
        app_version: '1.0',
        app_date: '2017-09-22'
      }

      puts values

      send_scrobble(ROUTE_DICT[action], values, access_token)
    end

    def submit_episode(action, info, access_token)
      guid = info['Metadata']['guid'].match(/thetvdb:\/\/(\d*)\/(\d*)\/(\d*)/)

      values = {
        episode: find_episode(guid[1].to_i, guid[2].to_i, guid[3].to_i),
        progress: PROGRESS_DICT[action],
        app_version: '1.0',
        app_date: '2017-09-22'
      }

      send_scrobble(ROUTE_DICT[action], values, access_token)
    end

    private

    def send_scrobble(route, values, access_token)
      headers = {
        content_type: 'application/json',
        authorization: "Bearer #{access_token.access_token}",
        trakt_api_version: '2',
        trakt_api_key: CLIENT_ID
      }

      response = RestClient.post "https://api.trakt.tv/scrobble/#{route}", JSON.generate(values), headers
      JSON.parse(response)
    end

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
