// import 'dart:math';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../models/song.dart';

// enum RepeatMode { off, all, one }

// class MusicProvider with ChangeNotifier {
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   final List<Song> _playlist = [];
//   List<int> _shuffledIndices = [];
//   int _currentIndex = 0;
//   int _shuffleIndex = 0;
//   bool _isPlaying = false;
//   Duration _currentPosition = Duration.zero;
//   Duration _totalDuration = Duration.zero;
//   double _volume = 1.0;
//   bool _isShuffleOn = false;
//   RepeatMode _repeatMode = RepeatMode.off;
//   bool _isInitialized = false;
//   bool _isPickingFiles = false;

//   MusicProvider() {
//     _initializePlayer();
//   }

//   // Getters
//   List<Song> get playlist => _playlist;
//   Song? get currentSong => _playlist.isEmpty ? null : _playlist[_currentIndex];
//   bool get isPlaying => _isPlaying;
//   Duration get currentPosition => _currentPosition;
//   Duration get totalDuration => _totalDuration;
//   double get volume => _volume;
//   bool get isShuffleOn => _isShuffleOn;
//   RepeatMode get repeatMode => _repeatMode;
//   int get currentIndex => _currentIndex;
//   bool get isPickingFiles => _isPickingFiles;

//   Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;

//   void _initializePlayer() {
//     print('Initializing audio player...');

//     _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
//       print('Player state changed: $state');
//       final wasPlaying = _isPlaying;
//       _isPlaying = state == PlayerState.playing;

//       if (_isPlaying != wasPlaying) {
//         notifyListeners();
//       }
//     });

//     _audioPlayer.onDurationChanged.listen((Duration duration) {
//       print('Duration changed: ${_formatDuration(duration)}');
//       _totalDuration = duration;
//       notifyListeners();
//     });

//     _audioPlayer.onPositionChanged.listen((Duration position) {
//       _currentPosition = position;
//       notifyListeners();
//     });

//     _audioPlayer.onPlayerComplete.listen((event) {
//       print('Song completed');
//       _onSongComplete();
//     });

//     _audioPlayer.setReleaseMode(ReleaseMode.stop);
//     _audioPlayer.setVolume(_volume);
//     _isInitialized = true;
//     print('Audio player initialized');
//   }

//   Future<bool> _requestStoragePermission() async {
//     try {
//       print('Checking platform: ${Platform.operatingSystem}');

//       if (Platform.isAndroid) {
//         print('Requesting Android permissions...');

//         var storage = await Permission.storage.status;
//         var audio = await Permission.audio.status;

//         print('Permission status:');
//         print('   - Storage: $storage');
//         print('   - Audio: $audio');

//         List<Permission> permissionsToRequest = [];

//         if (audio.isDenied) {
//           permissionsToRequest.add(Permission.audio);
//         }

//         if (storage.isDenied) {
//           permissionsToRequest.add(Permission.storage);
//         }

//         if (permissionsToRequest.isNotEmpty) {
//           print('Requesting permissions: $permissionsToRequest');
//           Map<Permission, PermissionStatus> statuses =
//               await permissionsToRequest.request();

//           print('Permission results: $statuses');

//           bool hasAudioPermission = statuses[Permission.audio]?.isGranted ??
//               await Permission.audio.isGranted;
//           bool hasStoragePermission = statuses[Permission.storage]?.isGranted ??
//               await Permission.storage.isGranted;

//           print('Final permission check:');
//           print('   - Audio: $hasAudioPermission');
//           print('   - Storage: $hasStoragePermission');

//           return hasAudioPermission || hasStoragePermission;
//         }

//         return true;
//       } else if (Platform.isIOS) {
//         print('iOS detected - permissions handled by file picker');
//         return true;
//       }

//       return true;
//     } catch (e) {
//       print('Error requesting permissions: $e');
//       return false;
//     }
//   }

//   Future<void> testFilePicker() async {
//     try {
//       print('Testing file picker...');
//       final result = await FilePicker.platform.pickFiles();
//       print('Test result: ${result?.files.length ?? 0} files');
//     } catch (e) {
//       print('Test error: $e');
//     }
//   }

//   Future<void> pickAudioFiles() async {
//     if (_isPickingFiles) {
//       print('File picking already in progress');
//       return;
//     }

//     try {
//       _isPickingFiles = true;
//       notifyListeners();

//       print('Starting file picker process...');

//       bool hasPermission = await _requestStoragePermission();
//       if (!hasPermission) {
//         print('Storage permission denied');
//         _showPermissionError();
//         return;
//       }
//       print('Permissions granted');

//       FilePickerResult? result;

//       try {
//         result = await FilePicker.platform.pickFiles(
//           type: FileType.custom,
//           allowedExtensions: ['mp3', 'wav', 'aac', 'm4a', 'flac', 'ogg', 'wma'],
//           allowMultiple: true,
//           allowCompression: false,
//         );
//       } on PlatformException catch (e) {
//         print('Platform exception during file picking: $e');
//         if (e.code == 'read_external_storage_denied') {
//           _showPermissionError();
//           return;
//         }
//         rethrow;
//       }

//       print('File picker result: ${result?.files.length ?? 0} files');

//       if (result != null && result.files.isNotEmpty) {
//         print('Selected ${result.files.length} files:');

//         List<Song> newSongs = [];
//         int successCount = 0;
//         int failCount = 0;

//         for (int i = 0; i < result.files.length; i++) {
//           PlatformFile file = result.files[i];
//           print('Processing file ${i + 1}/${result.files.length}:');
//           print('   - Name: ${file.name}');
//           print('   - Path: ${file.path}');
//           print('   - Size: ${file.size} bytes');
//           print('   - Extension: ${file.extension}');

//           String? filePath = file.path;
//           if (filePath != null && filePath.isNotEmpty) {
//             final fileExists = await File(filePath).exists();
//             print('   - File exists: $fileExists');

//             if (fileExists) {
//               Song song = _createSong(filePath, file.name);
//               newSongs.add(song);
//               successCount++;
//               print('   - Successfully added: ${song.title}');
//             } else {
//               failCount++;
//               print('   - File does not exist at path');
//             }
//           } else {
//             failCount++;
//             print('   - No valid file path');
//           }
//         }

//         print('Processing complete:');
//         print('   - Success: $successCount');
//         print('   - Failed: $failCount');

//         if (newSongs.isNotEmpty) {
//           final oldLength = _playlist.length;
//           _playlist.addAll(newSongs);
//           _generateShuffleList();

//           if (oldLength == 0) {
//             _currentIndex = 0;
//             print('Auto-playing first song');
//             await playAtIndex(0);
//           }

//           notifyListeners();
//           print('Successfully added ${newSongs.length} songs to playlist');
//           _showSuccessMessage(newSongs.length);
//         } else {
//           print('No songs were successfully added');
//           _showNoFilesError();
//         }
//       } else {
//         print('No files selected or result was null');
//       }
//     } catch (e, stackTrace) {
//       print('Error in pickAudioFiles: $e');
//       print('Stack trace: $stackTrace');
//       _showGenericError(e.toString());
//     } finally {
//       _isPickingFiles = false;
//       notifyListeners();
//     }
//   }

//   Song _createSong(String filePath, String fileName) {
//     return Song.fromFileMetadata(
//       filePath: filePath,
//       fileName: fileName,
//     );
//   }

//   void _showPermissionError() {
//     print('PERMISSION ERROR: User needs to grant storage permissions');
//   }

//   void _showNoFilesError() {
//     print('NO FILES ERROR: No valid audio files found');
//   }

//   void _showGenericError(String error) {
//     print('GENERIC ERROR: $error');
//   }

//   void _showSuccessMessage(int count) {
//     print('SUCCESS: Added $count songs to playlist');
//   }

//   Future<void> pickAudioFilesSimple() async {
//     if (_isPickingFiles) return;

//     try {
//       _isPickingFiles = true;
//       notifyListeners();

//       print('Using simple file picker...');

//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.audio,
//         allowMultiple: true,
//       );

//       if (result != null && result.files.isNotEmpty) {
//         print('Simple picker got ${result.files.length} files');

//         List<Song> newSongs = [];
//         for (PlatformFile file in result.files) {
//           if (file.path != null && file.path!.isNotEmpty) {
//             Song song = _createSong(file.path!, file.name);
//             newSongs.add(song);
//             print('Added: ${song.title}');
//           }
//         }

//         if (newSongs.isNotEmpty) {
//           final oldLength = _playlist.length;
//           _playlist.addAll(newSongs);
//           _generateShuffleList();

//           if (oldLength == 0) {
//             _currentIndex = 0;
//             await playAtIndex(0);
//           }

//           notifyListeners();
//           _showSuccessMessage(newSongs.length);
//         }
//       }
//     } catch (e) {
//       print('Simple picker error: $e');
//       _showGenericError(e.toString());
//     } finally {
//       _isPickingFiles = false;
//       notifyListeners();
//     }
//   }

//   void removeSong(int index) {
//     if (index < 0 || index >= _playlist.length) return;

//     String removedTitle = _playlist[index].title;
//     _playlist.removeAt(index);

//     if (index < _currentIndex) {
//       _currentIndex--;
//     } else if (index == _currentIndex) {
//       if (_playlist.isEmpty) {
//         _audioPlayer.stop();
//         _currentIndex = 0;
//         _isPlaying = false;
//         _currentPosition = Duration.zero;
//         _totalDuration = Duration.zero;
//       } else {
//         if (_currentIndex >= _playlist.length) {
//           _currentIndex = _playlist.length - 1;
//         }
//         playAtIndex(_currentIndex);
//       }
//     }

//     _generateShuffleList();
//     notifyListeners();
//     print('Removed: $removedTitle');
//   }

//   void clearPlaylist() {
//     _audioPlayer.stop();
//     _playlist.clear();
//     _currentIndex = 0;
//     _isPlaying = false;
//     _currentPosition = Duration.zero;
//     _totalDuration = Duration.zero;
//     _generateShuffleList();
//     notifyListeners();
//     print('Playlist cleared');
//   }

//   void _generateShuffleList() {
//     _shuffledIndices = List.generate(_playlist.length, (index) => index);
//     _shuffledIndices.shuffle(Random());
//     _shuffleIndex = 0;
//   }

//   // SIMPLIFIED: Basic playback without complex duration detection
//   Future<void> playAtIndex(int index) async {
//     if (index < 0 || index >= _playlist.length) {
//       print('Invalid index: $index (playlist length: ${_playlist.length})');
//       return;
//     }

//     if (!_isInitialized) {
//       print('Player not initialized yet');
//       return;
//     }

//     try {
//       _currentIndex = index;
//       final song = _playlist[index];

//       print('Playing song at index $index: "${song.title}"');
//       print('File path: ${song.filePath}');

//       // Verify file exists
//       final file = File(song.filePath);
//       final exists = await file.exists();
//       print('File exists: $exists');

//       if (!exists) {
//         print('File not found at path: ${song.filePath}');
//         removeSong(index);
//         return;
//       }

//       // Stop current playback
//       await _audioPlayer.stop();

//       // Reset state
//       _currentPosition = Duration.zero;
//       _totalDuration = Duration.zero;
//       notifyListeners();

//       // Start playing - the duration should come from onDurationChanged listener
//       print('Starting playback...');
//       await _audioPlayer.play(DeviceFileSource(song.filePath));

//       print('Playback command sent');
//       notifyListeners();
//     } catch (e, stackTrace) {
//       print('Error playing file: $e');
//       print('Stack trace: $stackTrace');
//       _isPlaying = false;
//       notifyListeners();
//     }
//   }

//   Future<void> togglePlayPause() async {
//     if (!_isInitialized) {
//       print('Player not initialized');
//       return;
//     }

//     if (_playlist.isEmpty) {
//       print('Playlist is empty');
//       return;
//     }

//     try {
//       print(
//           'Toggle play/pause - Current state: ${_isPlaying ? "playing" : "stopped/paused"}');

//       if (_isPlaying) {
//         print('Pausing...');
//         await _audioPlayer.pause();
//       } else {
//         print('Resuming...');
//         await _audioPlayer.resume();
//       }
//     } catch (e) {
//       print('Error in togglePlayPause: $e');
//       // If resume fails, try playing from the current index
//       await playAtIndex(_currentIndex);
//     }
//   }

//   Future<void> playNext() async {
//     if (_playlist.isEmpty) return;

//     int nextIndex;
//     if (_isShuffleOn) {
//       _shuffleIndex = (_shuffleIndex + 1) % _shuffledIndices.length;
//       nextIndex = _shuffledIndices[_shuffleIndex];
//     } else {
//       nextIndex = _currentIndex + 1;
//       if (nextIndex >= _playlist.length) {
//         if (_repeatMode == RepeatMode.all) {
//           nextIndex = 0;
//         } else {
//           print('End of playlist reached');
//           return;
//         }
//       }
//     }

//     print('Playing next song (index: $nextIndex)');
//     await playAtIndex(nextIndex);
//   }

//   Future<void> playPrevious() async {
//     if (_playlist.isEmpty) return;

//     if (_currentPosition.inSeconds > 3) {
//       print('Restarting current song');
//       await seek(Duration.zero);
//       return;
//     }

//     int previousIndex;
//     if (_isShuffleOn) {
//       _shuffleIndex = (_shuffleIndex - 1 + _shuffledIndices.length) %
//           _shuffledIndices.length;
//       previousIndex = _shuffledIndices[_shuffleIndex];
//     } else {
//       previousIndex = _currentIndex - 1;
//       if (previousIndex < 0) {
//         if (_repeatMode == RepeatMode.all) {
//           previousIndex = _playlist.length - 1;
//         } else {
//           previousIndex = 0;
//         }
//       }
//     }

//     print('Playing previous song (index: $previousIndex)');
//     await playAtIndex(previousIndex);
//   }

//   Future<void> seek(Duration position) async {
//     try {
//       print('Seeking to: ${_formatDuration(position)}');
//       await _audioPlayer.seek(position);
//       _currentPosition = position;
//       notifyListeners();
//     } catch (e) {
//       print('Error seeking: $e');
//     }
//   }

//   Future<void> setVolume(double volume) async {
//     try {
//       _volume = volume.clamp(0.0, 1.0);
//       await _audioPlayer.setVolume(_volume);
//       print('Volume set to: ${(_volume * 100).round()}%');
//       notifyListeners();
//     } catch (e) {
//       print('Error setting volume: $e');
//     }
//   }

//   void toggleShuffle() {
//     _isShuffleOn = !_isShuffleOn;
//     if (_isShuffleOn) {
//       _generateShuffleList();
//       _shuffleIndex = _shuffledIndices.indexOf(_currentIndex);
//     }
//     print('Shuffle ${_isShuffleOn ? "ON" : "OFF"}');
//     notifyListeners();
//   }

//   void toggleRepeatMode() {
//     switch (_repeatMode) {
//       case RepeatMode.off:
//         _repeatMode = RepeatMode.all;
//         break;
//       case RepeatMode.all:
//         _repeatMode = RepeatMode.one;
//         break;
//       case RepeatMode.one:
//         _repeatMode = RepeatMode.off;
//         break;
//     }
//     print('Repeat mode: $_repeatMode');
//     notifyListeners();
//   }

//   void _onSongComplete() async {
//     print('Song completed - Repeat mode: $_repeatMode');

//     switch (_repeatMode) {
//       case RepeatMode.one:
//         print('Repeating current song');
//         await playAtIndex(_currentIndex);
//         break;
//       case RepeatMode.all:
//         print('Playing next song (repeat all)');
//         await playNext();
//         break;
//       case RepeatMode.off:
//         if ((_isShuffleOn && _shuffleIndex < _shuffledIndices.length - 1) ||
//             (!_isShuffleOn && _currentIndex < _playlist.length - 1)) {
//           print('Playing next song');
//           await playNext();
//         } else {
//           print('Playlist finished');
//           _isPlaying = false;
//           _currentPosition = Duration.zero;
//           notifyListeners();
//         }
//         break;
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$twoDigitMinutes:$twoDigitSeconds';
//   }

//   @override
//   void dispose() {
//     print('Disposing music provider');
//     _audioPlayer.dispose();
//     super.dispose();
//   }
// }
