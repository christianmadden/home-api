#!/usr/bin/env python
import soco
from soco.music_services import MusicService

if __name__ == '__main__':

    spotify = MusicService('Spotify')
    spotify.get_metadata(item_id='spotify:user:spotify:playlist:0FQk6BADgIIYd3yTLCThjg')

    #zone_list = list(soco.discover())
    #zone = zone_list[0]
    #coordinator = zone.group.coordinator
    #print zone.player_name
    #print coordinator.player_name
    #coordinator.partymode()
    #coordinator.play_uri('spotify:user:spotify:playlist:1NenSB6iPbCC5ZMv3a2wT7')


    #sonos.play_uri('http://archive.org/download/TenD2005-07-16.flac16/TenD2005-07-16t10Wonderboy_64kb.mp3')
    #track = sonos.get_current_track_info()
    #print track['title']
    #sonos.pause()
    # Play a stopped or paused track
    #sonos.play()
