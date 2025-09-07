// Audio Manager Singleton
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:music_playlist/models/audio_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  List<AudioFile> _audioFiles = [];
  List<Playlist> _playlists = [];
  AudioFile? _currentAudio;
  bool _isPlaying = false;
  bool _isShuffled = false;
  bool _isRepeated = false;
  int _currentIndex = 0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Getters
  List<AudioFile> get audioFiles => _audioFiles;
  List<Playlist> get playlists => _playlists;
  AudioFile? get currentAudio => _currentAudio;
  bool get isPlaying => _isPlaying;
  bool get isShuffled => _isShuffled;
  bool get isRepeated => _isRepeated;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  AudioPlayer get audioPlayer => _audioPlayer;

  // Stream controllers for UI updates
  final List<Function()> _listeners = [];

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  Future<void> init() async {
    await _loadSavedData();

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _isPlaying = state == PlayerState.playing;
      _notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      _totalDuration = duration;
      _notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      _currentPosition = position;
      _notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (_isRepeated) {
        playAudio(_currentAudio!);
      } else {
        playNext();
      }
    });
  }

  Future<void> pickAudioFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.path != null) {
            final audioFile = AudioFile(
              name: file.name,
              path: file.path!,
              size: _formatFileSize(file.size),
              lastModified: DateTime.now(),
              artist: "Unknown Artist",
              album: "Unknown Album",
            );

            if (!_audioFiles
                .any((existing) => existing.path == audioFile.path)) {
              _audioFiles.add(audioFile);
            }
          }
        }
        await _saveData();
        _notifyListeners();
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    int i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
  }

  Future<void> playAudio(AudioFile audioFile) async {
    try {
      _currentAudio = audioFile;
      _currentIndex = _audioFiles.indexOf(audioFile);
      await _audioPlayer.play(DeviceFileSource(audioFile.path));
      await _saveRecentlyPlayed(audioFile);
      _notifyListeners();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  Future<void> playNext() async {
    if (_audioFiles.isEmpty) return;

    int nextIndex;
    if (_isShuffled) {
      nextIndex = Random().nextInt(_audioFiles.length);
    } else {
      nextIndex = (_currentIndex + 1) % _audioFiles.length;
    }

    await playAudio(_audioFiles[nextIndex]);
  }

  Future<void> playPrevious() async {
    if (_audioFiles.isEmpty) return;

    int prevIndex;
    if (_isShuffled) {
      prevIndex = Random().nextInt(_audioFiles.length);
    } else {
      prevIndex = (_currentIndex - 1 + _audioFiles.length) % _audioFiles.length;
    }

    await playAudio(_audioFiles[prevIndex]);
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    _notifyListeners();
  }

  void toggleRepeat() {
    _isRepeated = !_isRepeated;
    _notifyListeners();
  }

  Future<void> createPlaylist(String name, List<AudioFile> songs) async {
    final playlist = Playlist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      songs: songs,
      created: DateTime.now(),
    );
    _playlists.add(playlist);
    await _saveData();
    _notifyListeners();
  }

  Future<void> removeAudioFile(AudioFile audioFile) async {
    _audioFiles.remove(audioFile);
    await _saveData();
    _notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final audioFilesJson = _audioFiles.map((f) => f.toJson()).toList();
    final playlistsJson = _playlists.map((p) => p.toJson()).toList();

    await prefs.setString('audioFiles', jsonEncode(audioFilesJson));
    await prefs.setString('playlists', jsonEncode(playlistsJson));
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    final audioFilesStr = prefs.getString('audioFiles');
    if (audioFilesStr != null) {
      final List<dynamic> audioFilesJson = jsonDecode(audioFilesStr);
      _audioFiles = audioFilesJson.map((f) => AudioFile.fromJson(f)).toList();
    }

    final playlistsStr = prefs.getString('playlists');
    if (playlistsStr != null) {
      final List<dynamic> playlistsJson = jsonDecode(playlistsStr);
      _playlists = playlistsJson.map((p) => Playlist.fromJson(p)).toList();
    }
  }

  Future<void> _saveRecentlyPlayed(AudioFile audioFile) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentlyPlayed = prefs.getStringList('recentlyPlayed') ?? [];

    // Remove if already exists to avoid duplicates
    recentlyPlayed.removeWhere((path) => path == audioFile.path);

    // Add to beginning
    recentlyPlayed.insert(0, audioFile.path);

    // Keep only last 10
    if (recentlyPlayed.length > 10) {
      recentlyPlayed = recentlyPlayed.take(10).toList();
    }

    await prefs.setStringList('recentlyPlayed', recentlyPlayed);
  }

  Future<List<AudioFile>> getRecentlyPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentPaths = prefs.getStringList('recentlyPlayed') ?? [];

    return recentPaths
        .map((path) => _audioFiles.firstWhere(
              (audio) => audio.path == path,
              orElse: () => AudioFile(
                  name: '', path: '', size: '', lastModified: DateTime.now()),
            ))
        .where((audio) => audio.path.isNotEmpty)
        .take(5)
        .toList();
  }

  void addSongToPlaylist(Playlist playlist, AudioFile song) {
    if (!playlist.songs.any((s) => s.path == song.path)) {
      playlist.songs.add(song);
      _notifyListeners();
    }
  }

  void removeSongFromPlaylist(Playlist playlist, AudioFile song) {
    playlist.songs.removeWhere((s) => s.path == song.path);
    _notifyListeners();
  }

  void deletePlaylist(Playlist playlist) {
    playlists.remove(playlist);
    _notifyListeners();
  }

  void updatePlaylistName(Playlist playlist, String newName) {
    playlist.name = newName;
    _notifyListeners();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
