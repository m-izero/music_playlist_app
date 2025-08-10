import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Song {
  final String title;
  final String artist;
  final String url;
  final String albumArtUrl;

  Song({
    required this.title,
    required this.artist,
    required this.url,
    required this.albumArtUrl,
  });
}

class MusicProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  final List<Song> _songs = [
    // Add your sample songs here
    Song(
      title: 'Song 1',
      artist: 'Artist A',
      url: 'https://audiojungle.net/item/epic-song/59286171',
      albumArtUrl: 'https://picsum.photos/200/200',
    ),
    Song(
      title: 'Song 2',
      artist: 'Artist B',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      albumArtUrl: 'https://picsum.photos/201/201',
    ),
    Song(
      title: 'Song 3',
      artist: 'Artist C',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      albumArtUrl: 'https://picsum.photos/202/202',
    ),
  ];

  int? _currentSongIndex;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  MusicProvider() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      _duration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _position = newPosition;
      notifyListeners();
    });
  }

  List<Song> get songs => _songs;
  Song? get currentSong =>
      _currentSongIndex != null ? _songs[_currentSongIndex!] : null;
  PlayerState get playerState => _playerState;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get isPlaying => _playerState == PlayerState.playing;

  Future<void> playSong(int index) async {
    if (index >= 0 && index < _songs.length) {
      if (_currentSongIndex != index) {
        _currentSongIndex = index;
        print('Playing song with URL: ${_songs[index].url}');
        await _audioPlayer.play(UrlSource(_songs[index].url));
      } else {
        print('Resuming song...');
        await resumeSong();
      }
      notifyListeners();
    } else {
      print('Invalid song index: $index');
    }
  }
  // Future<void> playSong(int index) async {
  //   if (index >= 0 && index < _songs.length) {
  //     if (_currentSongIndex != index) {
  //       _currentSongIndex = index;
  //       await _audioPlayer.play(UrlSource(_songs[index].url));
  //     } else {
  //       await resumeSong();
  //     }
  //     notifyListeners();
  //   }
  // }

  Future<void> pauseSong() async {
    await _audioPlayer.pause();
    notifyListeners();
  }

  Future<void> resumeSong() async {
    await _audioPlayer.resume();
    notifyListeners();
  }

  Future<void> seek(double seconds) async {
    await _audioPlayer.seek(Duration(seconds: seconds.toInt()));
    notifyListeners();
  }

  Future<void> playNextSong() async {
    if (_currentSongIndex != null && _currentSongIndex! < _songs.length - 1) {
      await playSong(_currentSongIndex! + 1);
    }
  }

  Future<void> playPreviousSong() async {
    if (_currentSongIndex != null && _currentSongIndex! > 0) {
      await playSong(_currentSongIndex! - 1);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
