// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/song.dart';
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

//         // ✅ UPDATED: Show file picker when no songs are available
//         if (musicProvider.playlist.isEmpty) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Music Player'),
//             ),
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.library_music,
//                     size: 80,
//                     color: Colors.grey.shade400,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'No songs in your library',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Add some music to get started',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade500,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton.icon(
//                     onPressed: () => musicProvider.pickAudioFiles(),
//                     icon: const Icon(Icons.add),
//                     label: const Text('Add Music'),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 15),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

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
//                   // ✅ Custom App Bar with Add Music option
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
//                           onPressed: () =>
//                               _showOptionsMenu(context, musicProvider),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // ✅ UPDATED: Album Art with fallback for local files
//                   SizedBox.square(
//                     dimension: 280,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: currentSong.albumArtUrl != null
//                           ? Image.network(
//                               currentSong.albumArtUrl!,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return _buildDefaultAlbumArt();
//                               },
//                             )
//                           : _buildDefaultAlbumArt(),
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

//                   // ✅ Progress Bar + Time (unchanged)
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

//                   // ✅ Control Buttons (unchanged)
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

//                   // ✅ Volume Control (unchanged)
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
//                                 musicProvider.setVolume(newValue);
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

//   // ✅ NEW: Default album art widget for local files
//   Widget _buildDefaultAlbumArt() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.blue.shade200,
//             Colors.blue.shade400,
//           ],
//         ),
//       ),
//       child: const Icon(
//         Icons.music_note,
//         size: 100,
//         color: Colors.white,
//       ),
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$twoDigitMinutes:$twoDigitSeconds';
//   }

//   // ✅ UPDATED: Options menu with local file management
//   void _showOptionsMenu(BuildContext context, MusicProvider musicProvider) {
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
//                 leading: const Icon(Icons.add),
//                 title: const Text('Add More Music'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   musicProvider.pickAudioFiles();
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.delete),
//                 title: const Text('Remove Current Song'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   musicProvider.removeSong(musicProvider.currentIndex);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.clear_all),
//                 title: const Text('Clear Playlist'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showClearPlaylistDialog(context, musicProvider);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.info),
//                 title: const Text('Song Info'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showSongInfo(context, musicProvider.currentSong!);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ✅ NEW: Clear playlist confirmation dialog
//   void _showClearPlaylistDialog(
//       BuildContext context, MusicProvider musicProvider) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Clear Playlist'),
//           content: const Text(
//               'Are you sure you want to remove all songs from your playlist?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 musicProvider.clearPlaylist();
//               },
//               child: const Text('Clear'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ✅ NEW: Show song information dialog
//   void _showSongInfo(BuildContext context, Song song) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Song Information'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildInfoRow('Title', song.title),
//               _buildInfoRow('Artist', song.artist),
//               _buildInfoRow('File Path', song.filePath),
//               if (song.duration != null)
//                 _buildInfoRow('Duration', _formatDuration(song.duration!)),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ✅ NEW: Helper widget for info rows
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade700,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }
