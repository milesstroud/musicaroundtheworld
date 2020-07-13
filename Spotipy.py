import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import spotipy.util as util
import pandas as pd
cid = '2cfb716804634481b678117914a9d6cd'
secret = 'ecb207bc67d14a71a2841fbdef1bff6c'
client_credentials_manager = SpotifyClientCredentials(client_id=cid, client_secret = secret)
music_data = pd.read_csv("/Users/ashley/Documents/Music_Data.csv")
def find_data(song):
    # Returns results as a list of dictionaries
    results = sp.audio_features(tracks=[song])
    audio_features = pd.DataFrame(results)
    #print(results)
    audio_features = audio_features[
        ['danceability', 'duration_ms', 'energy', 'id',
         'instrumentalness', 'key', 'liveness', 'loudness', 'mode', 'speechiness', 'tempo', 'time_signature',
         'type', 'valence']]
    music_data['Danceability'][index] = audio_features['danceability']
    music_data['Duration'][index] = audio_features['duration_ms']
    music_data['Instrumentalness'][index] = audio_features['instrumentalness']
    music_data['Speechiness'][index] = audio_features['speechiness']
    music_data['Tempo'][index] = audio_features['tempo']

sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)
index = 0
for i in music_data['URL']:
    song = i
    find_data(song)
    index += 1

music_data.to_csv('/Users/ashley/Documents/Music_Data(pandas).csv')
