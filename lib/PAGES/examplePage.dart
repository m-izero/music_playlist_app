// import 'package:flutter/material.dart';
// import 'package:music_playlist/PAGES/playlist.dart';
// import 'package:music_playlist/PAGES/profile.dart';
// import 'package:music_playlist/PAGES/settings.dart';
// import 'package:music_playlist/components/drawer.dart';
// import 'package:provider/provider.dart';

// import '../providers/music_provider.dart';
// import 'music_player_screen.dart';

// class Screen1 extends StatefulWidget {
//   const Screen1({super.key});

//   @override
//   State<Screen1> createState() => _Screen1State();
// }

// class _Screen1State extends State<Screen1> {
//   int myIndex = 0;
//   static const List<Widget> widgetList = [
//     HomePage(),
//     PlaylistPage(),
//     Screen4(),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widgetList[myIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.blue[500],
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//               backgroundColor: Colors.blue),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.playlist_add),
//               label: 'Playlist',
//               backgroundColor: Colors.blue),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.settings),
//               label: 'Settings',
//               backgroundColor: Colors.blue),
//         ],
//         currentIndex: myIndex,
//         selectedItemColor: Colors.black,
//         onTap: (int index) {
//           setState(() {
//             myIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text("Home"),
//         backgroundColor: Colors.blue[500],
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const ProfilePage(),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.person),
//           )
//         ],
//       ),
//       drawer: const DrawerPage(),
//       body: Consumer<MusicProvider>(
//         builder: (context, musicProvider, child) {
//           // ✅ UPDATED: Show empty state with file picker options
//           if (musicProvider.playlist.isEmpty) {
//             return _buildEmptyState(context, musicProvider);
//           }

//           return Column(
//             children: [
//               // ✅ Header with playlist info and actions
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.library_music,
//                       color: Colors.blue[600],
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'My Music Library',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[800],
//                             ),
//                           ),
//                           Text(
//                             '${musicProvider.playlist.length} songs',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // ✅ Show loading indicator when picking files
//                     if (musicProvider.isPickingFiles)
//                       const Padding(
//                         padding: EdgeInsets.only(right: 8),
//                         child: SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         ),
//                       ),
//                     ElevatedButton.icon(
//                       onPressed: musicProvider.isPickingFiles
//                           ? null
//                           : () => musicProvider.pickAudioFiles(),
//                       icon: const Icon(Icons.add, size: 18),
//                       label: Text(
//                           musicProvider.isPickingFiles ? 'Adding...' : 'Add'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue[500],
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // ✅ Song list
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: musicProvider.playlist.length,
//                   itemBuilder: (context, index) {
//                     final song = musicProvider.playlist[index];
//                     final isCurrentSong = index == musicProvider.currentIndex;

//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4),
//                       elevation: isCurrentSong ? 4 : 1,
//                       color: isCurrentSong ? Colors.blue.shade50 : null,
//                       child: ListTile(
//                         leading: Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             gradient: song.albumArtUrl != null
//                                 ? null
//                                 : LinearGradient(
//                                     colors: [
//                                       Colors.blue.shade200,
//                                       Colors.blue.shade400,
//                                     ],
//                                   ),
//                           ),
//                           child: song.albumArtUrl != null
//                               ? ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Image.network(
//                                     song.albumArtUrl!,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return _buildDefaultAlbumArt(
//                                           isCurrentSong, musicProvider);
//                                     },
//                                   ),
//                                 )
//                               : _buildDefaultAlbumArt(
//                                   isCurrentSong, musicProvider),
//                         ),
//                         title: Text(
//                           song.title,
//                           style: TextStyle(
//                             fontWeight: isCurrentSong
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                             color: isCurrentSong ? Colors.blue : null,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         subtitle: Text(
//                           song.artist,
//                           style: TextStyle(
//                             color: isCurrentSong
//                                 ? Colors.blue.shade600
//                                 : Colors.grey.shade600,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             if (song.duration != null)
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8),
//                                 child: Text(
//                                   _formatDuration(song.duration!),
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ),
//                             IconButton(
//                               icon: Icon(
//                                 isCurrentSong && musicProvider.isPlaying
//                                     ? Icons.pause_circle_filled
//                                     : Icons.play_circle_filled,
//                                 color: Colors.blue,
//                                 size: 32,
//                               ),
//                               onPressed: () {
//                                 if (isCurrentSong) {
//                                   musicProvider.togglePlayPause();
//                                 } else {
//                                   musicProvider.playAtIndex(index);
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                         onTap: () {
//                           if (!isCurrentSong) {
//                             musicProvider.playAtIndex(index);
//                           }
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const MusicPlayerScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               // ✅ Bottom mini player when song is playing
//               if (musicProvider.currentSong != null)
//                 _buildMiniPlayer(context, musicProvider),
//             ],
//           );
//         },
//       ),
//       // ✅ NEW: Floating action button as alternative file picker
//       floatingActionButton: Consumer<MusicProvider>(
//         builder: (context, musicProvider, child) {
//           return FloatingActionButton(
//             onPressed: musicProvider.isPickingFiles
//                 ? null
//                 : () => _showFilePickerOptions(context, musicProvider),
//             backgroundColor:
//                 musicProvider.isPickingFiles ? Colors.grey : Colors.blue[500],
//             child: musicProvider.isPickingFiles
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 : const Icon(Icons.add, color: Colors.white),
//           );
//         },
//       ),
//     );
//   }

//   // ✅ NEW: File picker options dialog
//   void _showFilePickerOptions(
//       BuildContext context, MusicProvider musicProvider) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Add Music Files',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ListTile(
//                 leading: const Icon(Icons.audiotrack, color: Colors.blue),
//                 title: const Text('Pick Audio Files'),
//                 subtitle: const Text('MP3, WAV, AAC, M4A, FLAC, OGG'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   musicProvider.pickAudioFiles();
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.audio_file, color: Colors.green),
//                 title: const Text('Simple File Picker'),
//                 subtitle: const Text('Alternative method if above fails'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   musicProvider.pickAudioFilesSimple();
//                 },
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Having trouble? Check app permissions in device settings.',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[500],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ✅ Enhanced empty state with debugging info
//   Widget _buildEmptyState(BuildContext context, MusicProvider musicProvider) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.library_music,
//               size: 120,
//               color: Colors.grey.shade300,
//             ),
//             const SizedBox(height: 30),
//             Text(
//               'Welcome to Your Music Player',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[700],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'Start building your music library by adding songs from your device',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[500],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 40),

//             // ✅ Primary add button
//             ElevatedButton.icon(
//               onPressed: musicProvider.isPickingFiles
//                   ? null
//                   : () => musicProvider.pickAudioFiles(),
//               icon: musicProvider.isPickingFiles
//                   ? const SizedBox(
//                       width: 16,
//                       height: 16,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                   : const Icon(Icons.add, size: 24),
//               label: Text(
//                 musicProvider.isPickingFiles
//                     ? 'Adding Music...'
//                     : 'Add Your Music',
//                 style: const TextStyle(fontSize: 16),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue[500],
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 32,
//                   vertical: 16,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 4,
//               ),
//             ),

//             const SizedBox(height: 16),

//             // ✅ Alternative picker button
//             TextButton.icon(
//               onPressed: musicProvider.isPickingFiles
//                   ? null
//                   : () => musicProvider.pickAudioFilesSimple(),
//               icon: const Icon(Icons.audio_file, size: 20),
//               label: const Text('Try Alternative Picker'),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.blue[600],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // ✅ Supported formats info
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.blue.shade200),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.info_outline,
//                         color: Colors.blue[600],
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Supported Audio Formats',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.blue[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'MP3 • WAV • AAC • M4A • FLAC • OGG • WMA',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.blue[600],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // ✅ Troubleshooting info
//             Text(
//               'Having trouble? Make sure to grant storage permissions when prompted.',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[400],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ✅ Default album art for local files
//   Widget _buildDefaultAlbumArt(
//       bool isCurrentSong, MusicProvider musicProvider) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         gradient: LinearGradient(
//           colors: [
//             Colors.blue.shade200,
//             Colors.blue.shade400,
//           ],
//         ),
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Icon(
//             Icons.music_note,
//             color: Colors.white,
//             size: 24,
//           ),
//           if (isCurrentSong && musicProvider.isPlaying)
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.black54,
//               ),
//               child: const Icon(
//                 Icons.equalizer,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   // ✅ Mini player at bottom
//   Widget _buildMiniPlayer(BuildContext context, MusicProvider musicProvider) {
//     final currentSong = musicProvider.currentSong!;

//     return Container(
//       height: 70,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: ListTile(
//         leading: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             gradient: currentSong.albumArtUrl != null
//                 ? null
//                 : LinearGradient(
//                     colors: [
//                       Colors.blue.shade200,
//                       Colors.blue.shade400,
//                     ],
//                   ),
//           ),
//           child: currentSong.albumArtUrl != null
//               ? ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     currentSong.albumArtUrl!,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Icon(
//                         Icons.music_note,
//                         color: Colors.white,
//                         size: 24,
//                       );
//                     },
//                   ),
//                 )
//               : const Icon(
//                   Icons.music_note,
//                   color: Colors.white,
//                   size: 24,
//                 ),
//         ),
//         title: Text(
//           currentSong.title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         subtitle: Text(
//           currentSong.artist,
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 12,
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: Icon(
//                 Icons.skip_previous,
//                 color: Colors.grey[700],
//               ),
//               onPressed: musicProvider.playPrevious,
//             ),
//             IconButton(
//               icon: Icon(
//                 musicProvider.isPlaying ? Icons.pause : Icons.play_arrow,
//                 color: Colors.blue,
//                 size: 28,
//               ),
//               onPressed: musicProvider.togglePlayPause,
//             ),
//             IconButton(
//               icon: Icon(
//                 Icons.skip_next,
//                 color: Colors.grey[700],
//               ),
//               onPressed: musicProvider.playNext,
//             ),
//           ],
//         ),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const MusicPlayerScreen(),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$twoDigitMinutes:$twoDigitSeconds';
//   }
// }
