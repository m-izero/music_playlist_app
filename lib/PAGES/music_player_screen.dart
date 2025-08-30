// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/music_provider.dart';

// class MusicPlayerScreen extends StatefulWidget {
//   const MusicPlayerScreen({super.key});

//   @override
//   State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
// }

// class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
//   bool _isLiked = false;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MusicProvider>(
//       builder: (context, musicProvider, child) {
//         final currentSong = musicProvider.currentSong;

//         if (currentSong == null) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Music Player'),
//             ),
//             body: const Center(
//               child: Text('No song selected'),
//             ),
//           );
//         }

//         return Scaffold(
//           backgroundColor: Colors.blue[100],
//           body: SafeArea(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.blue.shade300, Colors.blue.shade50],
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   // ✅ Custom App Bar
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.keyboard_arrow_down, size: 32),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                         const Text(
//                           'Now Playing',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.more_vert),
//                           onPressed: () => _showOptionsMenu(context),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // ✅ Album Art
//                   SizedBox.square(
//                     dimension: 280,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image.network(
//                         currentSong.albumArtUrl,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             color: Colors.grey.shade300,
//                             child: const Icon(
//                               Icons.music_note,
//                               size: 100,
//                               color: Colors.grey,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // ✅ Song Info + Like
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: Column(
//                       children: [
//                         Text(
//                           currentSong.title,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           currentSong.artist,
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.grey.shade600,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 10),
//                         IconButton(
//                           onPressed: () => setState(() => _isLiked = !_isLiked),
//                           icon: Icon(
//                             _isLiked ? Icons.favorite : Icons.favorite_border,
//                             color: _isLiked ? Colors.red : Colors.grey.shade600,
//                             size: 28,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const Spacer(),

//                   // ✅ Progress Bar + Time
//                   StreamBuilder<Duration>(
//                     stream: musicProvider.positionStream,
//                     builder: (context, snapshot) {
//                       final position = snapshot.data ?? Duration.zero;
//                       final duration = musicProvider.totalDuration;
//                       final value = (duration.inMilliseconds == 0)
//                           ? 0.0
//                           : (position.inMilliseconds / duration.inMilliseconds)
//                               .clamp(0.0, 1.0);

//                       return Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 40),
//                             child: SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 thumbShape: const RoundSliderThumbShape(
//                                     enabledThumbRadius: 8),
//                                 trackHeight: 4,
//                               ),
//                               child: Slider(
//                                 value: value,
//                                 onChanged: (newValue) {
//                                   final newPosition = Duration(
//                                     milliseconds:
//                                         (newValue * duration.inMilliseconds)
//                                             .round(),
//                                   );
//                                   musicProvider.seek(newPosition);
//                                 },
//                                 activeColor: Colors.blue,
//                                 inactiveColor: Colors.grey.shade300,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 40),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   _formatDuration(position),
//                                   style: TextStyle(color: Colors.grey.shade600),
//                                 ),
//                                 Text(
//                                   _formatDuration(duration),
//                                   style: TextStyle(color: Colors.grey.shade600),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),

//                   const SizedBox(height: 25),

//                   // ✅ Control Buttons
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         IconButton(
//                           onPressed: musicProvider.toggleShuffle,
//                           icon: Icon(
//                             Icons.shuffle,
//                             color: musicProvider.isShuffleOn
//                                 ? Colors.blue
//                                 : Colors.grey.shade600,
//                             size: 32,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: musicProvider.playPrevious,
//                           icon: Icon(
//                             Icons.skip_previous,
//                             size: 36,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.blue,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.blue.withOpacity(0.3),
//                                 blurRadius: 12,
//                                 offset: const Offset(0, 5),
//                               ),
//                             ],
//                           ),
//                           child: IconButton(
//                             onPressed: musicProvider.togglePlayPause,
//                             icon: Icon(
//                               musicProvider.isPlaying
//                                   ? Icons.pause
//                                   : Icons.play_arrow,
//                               color: Colors.white,
//                               size: 36,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: musicProvider.playNext,
//                           icon: Icon(
//                             Icons.skip_next,
//                             size: 36,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: musicProvider.toggleRepeatMode,
//                           icon: Icon(
//                             musicProvider.repeatMode == RepeatMode.one
//                                 ? Icons.repeat_one
//                                 : Icons.repeat,
//                             color: musicProvider.repeatMode != RepeatMode.off
//                                 ? Colors.blue
//                                 : Colors.grey.shade600,
//                             size: 32,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 25),

//                   // ✅ Volume Control (fixed async issue)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Row(
//                       children: [
//                         Icon(Icons.volume_down, color: Colors.grey.shade600),
//                         Expanded(
//                           child: SliderTheme(
//                             data: SliderTheme.of(context).copyWith(
//                               thumbShape: const RoundSliderThumbShape(
//                                   enabledThumbRadius: 6),
//                               trackHeight: 3,
//                             ),
//                             child: Slider(
//                               value: musicProvider.volume,
//                               onChanged: (newValue) {
//                                 musicProvider.setVolume(newValue); // FIXED
//                               },
//                               activeColor: Colors.blue,
//                               inactiveColor: Colors.grey.shade300,
//                             ),
//                           ),
//                         ),
//                         Icon(Icons.volume_up, color: Colors.grey.shade600),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$twoDigitMinutes:$twoDigitSeconds';
//   }

//   void _showOptionsMenu(BuildContext context) {
//     showModalBottomSheet(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.playlist_add),
//                 title: const Text('Add to Playlist'),
//                 onTap: () => Navigator.pop(context),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.share),
//                 title: const Text('Share'),
//                 onTap: () => Navigator.pop(context),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.info),
//                 title: const Text('Song Info'),
//                 onTap: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<MusicProvider>(
        builder: (context, musicProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Card
                Card(
                  color: musicProvider.isPlaying
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          musicProvider.isPlaying
                              ? Icons.play_circle
                              : Icons.pause_circle,
                          size: 48,
                          color: musicProvider.isPlaying
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          musicProvider.isPlaying ? 'PLAYING' : 'STOPPED',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: musicProvider.isPlaying
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        if (musicProvider.currentSong != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            musicProvider.currentSong!.title,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${_formatDuration(musicProvider.currentPosition)} / ${_formatDuration(musicProvider.totalDuration)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Control Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => musicProvider.playFirstSong(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play First'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => musicProvider.togglePlayPause(),
                      icon: Icon(musicProvider.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                      label: Text(musicProvider.isPlaying ? 'Pause' : 'Play'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Playlist
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.blue.shade50,
                          child: Row(
                            children: [
                              const Icon(Icons.playlist_play),
                              const SizedBox(width: 8),
                              Text(
                                'Playlist (${musicProvider.playlist.length} songs)',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: musicProvider.playlist.length,
                            itemBuilder: (context, index) {
                              final song = musicProvider.playlist[index];
                              final isCurrentSong =
                                  index == musicProvider.currentIndex;

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isCurrentSong
                                      ? (musicProvider.isPlaying
                                          ? Colors.green
                                          : Colors.orange)
                                      : Colors.grey.shade300,
                                  child: Icon(
                                    isCurrentSong
                                        ? (musicProvider.isPlaying
                                            ? Icons.volume_up
                                            : Icons.pause)
                                        : Icons.music_note,
                                    color: isCurrentSong
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                  ),
                                ),
                                title: Text(
                                  song.title,
                                  style: TextStyle(
                                    fontWeight: isCurrentSong
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isCurrentSong ? Colors.blue : null,
                                  ),
                                ),
                                subtitle: Text(song.artist),
                                trailing: isCurrentSong
                                    ? Icon(Icons.equalizer, color: Colors.blue)
                                    : null,
                                onTap: () {
                                  print('🎵 User tapped song at index $index');
                                  musicProvider.playAtIndex(index);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Progress Bar
                if (musicProvider.totalDuration.inMilliseconds > 0)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      StreamBuilder<Duration>(
                        stream: musicProvider.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final duration = musicProvider.totalDuration;
                          final value = duration.inMilliseconds > 0
                              ? (position.inMilliseconds /
                                      duration.inMilliseconds)
                                  .clamp(0.0, 1.0)
                              : 0.0;

                          return Column(
                            children: [
                              Slider(
                                value: value,
                                onChanged: (newValue) {
                                  final newPosition = Duration(
                                    milliseconds:
                                        (newValue * duration.inMilliseconds)
                                            .round(),
                                  );
                                  musicProvider.seek(newPosition);
                                },
                                activeColor: Colors.blue,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_formatDuration(position)),
                                    Text(_formatDuration(duration)),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
