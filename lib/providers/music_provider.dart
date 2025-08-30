// // import 'dart:math';
// // import 'package:flutter/foundation.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import '../models/song.dart';

// // enum RepeatMode { off, all, one }

// // class MusicProvider with ChangeNotifier {
// //   final AudioPlayer _audioPlayer = AudioPlayer();

// //   List<Song> _playlist = [];
// //   List<int> _shuffledIndices = [];
// //   int _currentIndex = 0;
// //   int _shuffleIndex = 0;
// //   bool _isPlaying = false;
// //   Duration _currentPosition = Duration.zero;
// //   Duration _totalDuration = Duration.zero;
// //   double _volume = 1.0;
// //   bool _isShuffleOn = false;
// //   RepeatMode _repeatMode = RepeatMode.off;

// //   MusicProvider() {
// //     _initializePlayer();
// //     _loadSampleSongs();
// //   }

// //   // Getters
// //   List<Song> get playlist => _playlist;
// //   Song? get currentSong => _playlist.isEmpty ? null : _playlist[_currentIndex];
// //   bool get isPlaying => _isPlaying;
// //   Duration get currentPosition => _currentPosition;
// //   Duration get totalDuration => _totalDuration;
// //   double get volume => _volume;
// //   bool get isShuffleOn => _isShuffleOn;
// //   RepeatMode get repeatMode => _repeatMode;
// //   int get currentIndex => _currentIndex;

// //   // ✅ Use audioplayers built-in position stream
// //   Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;

// //   void _initializePlayer() {
// //     _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
// //       _isPlaying = state == PlayerState.playing;
// //       notifyListeners();
// //     });

// //     _audioPlayer.onDurationChanged.listen((Duration duration) {
// //       _totalDuration = duration;
// //       notifyListeners();
// //     });

// //     _audioPlayer.onPositionChanged.listen((Duration position) {
// //       _currentPosition = position;
// //       notifyListeners();
// //     });

// //     _audioPlayer.onPlayerComplete.listen((event) {
// //       _onSongComplete();
// //     });

// //     _audioPlayer.setVolume(_volume);
// //   }

// //   void _loadSampleSongs() {
// //     _playlist = [
// //       Song(
// //         title: 'Sample Song 1',
// //         artist: 'Artist 1',
// //         url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
// //         albumArtUrl: 'https://picsum.photos/300/300?random=1',
// //       ),
// //       Song(
// //         title: 'Sample Song 2',
// //         artist: 'Artist 2',
// //         url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
// //         albumArtUrl: 'https://picsum.photos/300/300?random=2',
// //       ),
// //       Song(
// //         title: 'Sample Song 3',
// //         artist: 'Artist 3',
// //         url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
// //         albumArtUrl: 'https://picsum.photos/300/300?random=3',
// //       ),
// //     ];
// //     _generateShuffleList();
// //     notifyListeners();
// //   }

// //   void _generateShuffleList() {
// //     _shuffledIndices = List.generate(_playlist.length, (index) => index);
// //     _shuffledIndices.shuffle(Random());
// //     _shuffleIndex = 0;
// //   }

// //   // ✅ Play a song at index
// //   Future<void> playAtIndex(int index) async {
// //     if (index < 0 || index >= _playlist.length) return;

// //     try {
// //       _currentIndex = index;
// //       _currentPosition = Duration.zero;

// //       await _audioPlayer.stop();
// //       await _audioPlayer.play(UrlSource(_playlist[index].url));
// //       _isPlaying = true;
// //       notifyListeners();
// //     } catch (e) {
// //       print('Error playing song: $e');
// //       _isPlaying = false;
// //       notifyListeners();
// //     }
// //   }

// //   // ✅ Toggle play/pause
// //   Future<void> togglePlayPause() async {
// //     try {
// //       if (_isPlaying) {
// //         await _audioPlayer.pause();
// //       } else {
// //         if (_playlist.isEmpty) return;

// //         if (_currentPosition == Duration.zero && !_isPlaying) {
// //           await playAtIndex(_currentIndex);
// //         } else {
// //           await _audioPlayer.resume();
// //         }
// //       }
// //     } catch (e) {
// //       print('Error toggling play/pause: $e');
// //     }
// //   }

// //   Future<void> playNext() async {
// //     if (_playlist.isEmpty) return;

// //     int nextIndex;
// //     if (_isShuffleOn) {
// //       _shuffleIndex = (_shuffleIndex + 1) % _shuffledIndices.length;
// //       nextIndex = _shuffledIndices[_shuffleIndex];
// //     } else {
// //       nextIndex = _currentIndex + 1;
// //       if (nextIndex >= _playlist.length) {
// //         if (_repeatMode == RepeatMode.all) {
// //           nextIndex = 0;
// //         } else {
// //           return;
// //         }
// //       }
// //     }
// //     await playAtIndex(nextIndex);
// //   }

// //   Future<void> playPrevious() async {
// //     if (_playlist.isEmpty) return;

// //     if (_currentPosition.inSeconds > 3) {
// //       await seek(Duration.zero);
// //       return;
// //     }

// //     int previousIndex;
// //     if (_isShuffleOn) {
// //       _shuffleIndex = (_shuffleIndex - 1 + _shuffledIndices.length) %
// //           _shuffledIndices.length;
// //       previousIndex = _shuffledIndices[_shuffleIndex];
// //     } else {
// //       previousIndex = _currentIndex - 1;
// //       if (previousIndex < 0) {
// //         if (_repeatMode == RepeatMode.all) {
// //           previousIndex = _playlist.length - 1;
// //         } else {
// //           previousIndex = 0;
// //         }
// //       }
// //     }
// //     await playAtIndex(previousIndex);
// //   }

// //   Future<void> seek(Duration position) async {
// //     try {
// //       await _audioPlayer.seek(position);
// //       _currentPosition = position;
// //       notifyListeners();
// //     } catch (e) {
// //       print('Error seeking: $e');
// //     }
// //   }

// //   Future<void> setVolume(double volume) async {
// //     try {
// //       _volume = volume.clamp(0.0, 1.0);
// //       await _audioPlayer.setVolume(_volume);
// //       notifyListeners();
// //     } catch (e) {
// //       print('Error setting volume: $e');
// //     }
// //   }

// //   void toggleShuffle() {
// //     _isShuffleOn = !_isShuffleOn;
// //     if (_isShuffleOn) {
// //       _generateShuffleList();
// //       _shuffleIndex = _shuffledIndices.indexOf(_currentIndex);
// //     }
// //     notifyListeners();
// //   }

// //   void toggleRepeatMode() {
// //     switch (_repeatMode) {
// //       case RepeatMode.off:
// //         _repeatMode = RepeatMode.all;
// //         break;
// //       case RepeatMode.all:
// //         _repeatMode = RepeatMode.one;
// //         break;
// //       case RepeatMode.one:
// //         _repeatMode = RepeatMode.off;
// //         break;
// //     }
// //     notifyListeners();
// //   }

// //   void _onSongComplete() async {
// //     switch (_repeatMode) {
// //       case RepeatMode.one:
// //         await playAtIndex(_currentIndex);
// //         break;
// //       case RepeatMode.all:
// //         await playNext();
// //         break;
// //       case RepeatMode.off:
// //         if ((_isShuffleOn && _shuffleIndex < _shuffledIndices.length - 1) ||
// //             (!_isShuffleOn && _currentIndex < _playlist.length - 1)) {
// //           await playNext();
// //         } else {
// //           _isPlaying = false;
// //           _currentPosition = Duration.zero;
// //           notifyListeners();
// //         }
// //         break;
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _audioPlayer.dispose();
// //     super.dispose();
// //   }
// // }
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';

enum RepeatMode { off, all, one }

class MusicProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Song> _playlist = [];
  List<int> _shuffledIndices = [];
  int _currentIndex = 0;
  int _shuffleIndex = 0;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _volume = 1.0;
  bool _isShuffleOn = false;
  RepeatMode _repeatMode = RepeatMode.off;
  bool _isInitialized = false;

  MusicProvider() {
    _initializePlayer();
    _loadSampleSongs();
  }

  // Getters
  List<Song> get playlist => _playlist;
  Song? get currentSong => _playlist.isEmpty ? null : _playlist[_currentIndex];
  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  double get volume => _volume;
  bool get isShuffleOn => _isShuffleOn;
  RepeatMode get repeatMode => _repeatMode;
  int get currentIndex => _currentIndex;

  // ✅ Use audioplayers built-in position stream
  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;

  void _initializePlayer() {
    print('🎵 Initializing audio player...');

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      print('🎵 Player state changed: $state');
      final wasPlaying = _isPlaying;
      _isPlaying = state == PlayerState.playing;

      if (_isPlaying != wasPlaying) {
        notifyListeners();
      }
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      print('🎵 Duration changed: ${_formatDuration(duration)}');
      _totalDuration = duration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      _currentPosition = position;
      // Don't notify listeners here to avoid too many updates
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      print('🎵 Song completed');
      _onSongComplete();
    });

    // Set initial volume and mark as initialized
    _audioPlayer.setVolume(_volume);
    _isInitialized = true;
    print('🎵 Audio player initialized');
  }

  void _loadSampleSongs() {
    print('🎵 Loading sample songs...');
    _playlist = [
      Song(
        title: 'SoundHelix Song 1',
        artist: 'SoundHelix Artist',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        albumArtUrl: 'https://picsum.photos/300/300?random=1',
      ),
      Song(
        title: 'SoundHelix Song 2',
        artist: 'SoundHelix Artist',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        albumArtUrl: 'https://picsum.photos/300/300?random=2',
      ),
      Song(
        title: 'SoundHelix Song 3',
        artist: 'SoundHelix Artist',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        albumArtUrl: 'https://picsum.photos/300/300?random=3',
      ),
    ];
    _generateShuffleList();
    print('🎵 Loaded ${_playlist.length} songs');
    notifyListeners();
  }

  void _generateShuffleList() {
    _shuffledIndices = List.generate(_playlist.length, (index) => index);
    _shuffledIndices.shuffle(Random());
    _shuffleIndex = 0;
  }

  // ✅ Play a song at index - FIXED VERSION
  Future<void> playAtIndex(int index) async {
    if (index < 0 || index >= _playlist.length) {
      print(
          '🎵 ❌ Invalid index: $index (playlist length: ${_playlist.length})');
      return;
    }

    if (!_isInitialized) {
      print('🎵 ❌ Player not initialized yet');
      return;
    }

    try {
      _currentIndex = index;
      final song = _playlist[index];

      print('🎵 🎯 Playing song at index $index: "${song.title}"');
      print('🎵 🔗 URL: ${song.url}');

      // Reset position and duration
      _currentPosition = Duration.zero;
      _totalDuration = Duration.zero;

      // Stop current playback completely
      await _audioPlayer.stop();

      // Small delay to ensure stop completes
      await Future.delayed(const Duration(milliseconds: 100));

      // Start playing new song
      await _audioPlayer.play(UrlSource(song.url));

      print('🎵 ✅ Play command sent successfully');
      notifyListeners();
    } catch (e) {
      print('🎵 ❌ Error playing song: $e');
      _isPlaying = false;
      notifyListeners();
    }
  }

  // ✅ Toggle play/pause - FIXED VERSION
  Future<void> togglePlayPause() async {
    if (!_isInitialized) {
      print('🎵 ❌ Player not initialized');
      return;
    }

    if (_playlist.isEmpty) {
      print('🎵 ❌ Playlist is empty');
      return;
    }

    try {
      print(
          '🎵 🎯 Toggle play/pause - Current state: ${_isPlaying ? "playing" : "stopped/paused"}');

      if (_isPlaying) {
        print('🎵 ⏸️ Pausing...');
        await _audioPlayer.pause();
      } else {
        // If we haven't played anything yet, or if we're at the beginning
        if (_totalDuration == Duration.zero) {
          print('🎵 ▶️ Starting fresh playback...');
          await playAtIndex(_currentIndex);
        } else {
          print('🎵 ▶️ Resuming playback...');
          await _audioPlayer.resume();
        }
      }
    } catch (e) {
      print('🎵 ❌ Error in togglePlayPause: $e');
    }
  }

  Future<void> playNext() async {
    if (_playlist.isEmpty) return;

    int nextIndex;
    if (_isShuffleOn) {
      _shuffleIndex = (_shuffleIndex + 1) % _shuffledIndices.length;
      nextIndex = _shuffledIndices[_shuffleIndex];
    } else {
      nextIndex = _currentIndex + 1;
      if (nextIndex >= _playlist.length) {
        if (_repeatMode == RepeatMode.all) {
          nextIndex = 0;
        } else {
          print('🎵 End of playlist reached');
          return;
        }
      }
    }

    print('🎵 ⏭️ Playing next song (index: $nextIndex)');
    await playAtIndex(nextIndex);
  }

  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;

    // If more than 3 seconds into the song, restart current song
    if (_currentPosition.inSeconds > 3) {
      print('🎵 ⏪ Restarting current song');
      await seek(Duration.zero);
      return;
    }

    int previousIndex;
    if (_isShuffleOn) {
      _shuffleIndex = (_shuffleIndex - 1 + _shuffledIndices.length) %
          _shuffledIndices.length;
      previousIndex = _shuffledIndices[_shuffleIndex];
    } else {
      previousIndex = _currentIndex - 1;
      if (previousIndex < 0) {
        if (_repeatMode == RepeatMode.all) {
          previousIndex = _playlist.length - 1;
        } else {
          previousIndex = 0;
        }
      }
    }

    print('🎵 ⏮️ Playing previous song (index: $previousIndex)');
    await playAtIndex(previousIndex);
  }

  Future<void> seek(Duration position) async {
    try {
      print('🎵 🎯 Seeking to: ${_formatDuration(position)}');
      await _audioPlayer.seek(position);
      _currentPosition = position;
      notifyListeners();
    } catch (e) {
      print('🎵 ❌ Error seeking: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      _volume = volume.clamp(0.0, 1.0);
      await _audioPlayer.setVolume(_volume);
      print('🎵 🔊 Volume set to: ${(_volume * 100).round()}%');
      notifyListeners();
    } catch (e) {
      print('🎵 ❌ Error setting volume: $e');
    }
  }

  void toggleShuffle() {
    _isShuffleOn = !_isShuffleOn;
    if (_isShuffleOn) {
      _generateShuffleList();
      _shuffleIndex = _shuffledIndices.indexOf(_currentIndex);
    }
    print('🎵 🔀 Shuffle ${_isShuffleOn ? "ON" : "OFF"}');
    notifyListeners();
  }

  void toggleRepeatMode() {
    switch (_repeatMode) {
      case RepeatMode.off:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.off;
        break;
    }
    print('🎵 🔁 Repeat mode: $_repeatMode');
    notifyListeners();
  }

  void _onSongComplete() async {
    print('🎵 🏁 Song completed - Repeat mode: $_repeatMode');

    switch (_repeatMode) {
      case RepeatMode.one:
        print('🎵 🔂 Repeating current song');
        await playAtIndex(_currentIndex);
        break;
      case RepeatMode.all:
        print('🎵 🔁 Playing next song (repeat all)');
        await playNext();
        break;
      case RepeatMode.off:
        if ((_isShuffleOn && _shuffleIndex < _shuffledIndices.length - 1) ||
            (!_isShuffleOn && _currentIndex < _playlist.length - 1)) {
          print('🎵 ⏭️ Playing next song');
          await playNext();
        } else {
          print('🎵 🛑 Playlist finished');
          _isPlaying = false;
          _currentPosition = Duration.zero;
          notifyListeners();
        }
        break;
    }
  }

  // Add a method to manually trigger first song playback
  Future<void> playFirstSong() async {
    print('🎵 🎯 Playing first song manually');
    if (_playlist.isNotEmpty) {
      await playAtIndex(0);
    }
  }

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    print('🎵 🗑️ Disposing music provider');
    _audioPlayer.dispose();
    super.dispose();
  }
}
