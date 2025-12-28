# # app/services/spotify_service.rb
# require 'rspotify'

# class SpotifyService
#   def initialize
#     @client_id = ENV['SPOTIFY_CLIENT_ID']
#     @client_secret = ENV['SPOTIFY_CLIENT_SECRET']
#   end

#   def search_playlists(category, mood, limit = 15)
#     return [] unless @client_id.present? && @client_secret.present?

#     # Authenticate with Spotify
#     RSpotify.authenticate(@client_id, @client_secret)

#     query = build_playlist_query(category, mood)

#     # Search for playlists
#     playlists = RSpotify::Playlist.search(query, limit: limit)

#     playlists.map do |playlist|
#       {
#         name: playlist.name,
#         url: playlist.external_urls['spotify'],
#         image_url: playlist.images.first&.[]('url'),
#         description: playlist.description,
#         tracks_total: playlist.total,
#         owner: playlist.owner.display_name
#       }
#     end
#   rescue => e
#     Rails.logger.error "Spotify API Error: #{e.message}"
#     []
#   end

#   def search_tracks(category, mood, limit = 15)
#     return [] unless @client_id.present? && @client_secret.present?

#     RSpotify.authenticate(@client_id, @client_secret)

#     query = build_track_query(category, mood)

#     # Search for individual tracks
#     tracks = RSpotify::Track.search(query, limit: limit)

#     tracks.map do |track|
#       {
#         name: track.name,
#         artist: track.artists.first.name,
#         album: track.album.name,
#         url: track.external_urls['spotify'],
#         preview_url: track.preview_url,
#         image_url: track.album.images.first&.[]('url'),
#         duration_ms: track.duration_ms
#       }
#     end
#   rescue => e
#     Rails.logger.error "Spotify Track Error: #{e.message}"
#     []
#   end

#   private

#   def build_playlist_query(category, mood)
#     queries = {
#       'happy' => {
#         'uplifting' => 'happy upbeat positive vibes',
#         'calming' => 'chill happy relaxing',
#         'motivational' => 'workout motivation energy pump up',
#         'serious' => 'focus concentration happy'
#       },
#       'sad' => {
#         'uplifting' => 'uplifting hopeful inspiring healing',
#         'calming' => 'peaceful calm soothing meditation',
#         'motivational' => 'empowering strength overcome',
#         'serious' => 'melancholic reflective sad'
#       },
#       'meh' => {
#         'uplifting' => 'energizing upbeat feel good',
#         'calming' => 'ambient relaxing lofi chill',
#         'motivational' => 'motivation productivity focus',
#         'serious' => 'instrumental focus study'
#       }
#     }

#     queries.dig(mood, category) || 'chill vibes'
#   end

#   def build_track_query(category, mood)
#     # Similar to playlist query but for individual songs
#     build_playlist_query(category, mood)
#   end
# end
class SpotifyService
  # ... initialize and authentication logic ...

  def search_playlists(category, mood, limit = 10)
    RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
    query = build_playlist_query(category, mood)
    playlists = RSpotify::Playlist.search(query, limit: limit)

    playlists.map do |playlist|
      {
        title: playlist.name,
        blog: "A collection of sounds for your #{mood} heart.", # Using 'blog' field for consistency
        url: playlist.external_urls['spotify'],
        # THIS IS THE KEY PART:
        embed_url: "https://open.spotify.com/embed/playlist/#{playlist.id}?utm_source=generator&theme=0",
        content_type: 'music'
      }
    end
  end

  def search_tracks(category, mood, limit = 5)
    # Similar logic for tracks
    tracks = RSpotify::Track.search(build_track_query(category, mood), limit: limit)
    tracks.map do |track|
      {
        title: track.name,
        blog: track.artists.first.name,
        url: track.external_urls['spotify'],
        # TRACK EMBED URL:
        embed_url: "https://open.spotify.com/embed/track/#{track.id}?utm_source=generator&theme=0",
        content_type: 'music'
      }
    end
  end
end
