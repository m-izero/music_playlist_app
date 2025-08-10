// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/music_provider.dart';

// class MusicPlayerScreen extends StatelessWidget {
//   const MusicPlayerScreen({super.key});

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MusicProvider>(
//       builder: (context, musicProvider, child) {
//         final currentSong = musicProvider.currentSong;
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Now Playing'),
//           ),
//           body: currentSong == null
//               ? const Center(child: Text('No song is playing'))
//               : Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(16.0),
//                         child: Image.network(
//                           currentSong.albumArtUrl,
//                           height: 300,
//                           width: 300,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         currentSong.title,
//                         style: const TextStyle(
//                             fontSize: 24, fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         currentSong.artist,
//                         style: const TextStyle(fontSize: 18),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 40),
//                       Slider(
//                         min: 0.0,
//                         max: musicProvider.duration.inSeconds.toDouble(),
//                         value: musicProvider.position.inSeconds
//                             .toDouble()
//                             .clamp(0.0,
//                                 musicProvider.duration.inSeconds.toDouble()),
//                         onChanged: (value) {
//                           musicProvider.seek(value);
//                         },
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(_formatDuration(musicProvider.position)),
//                             Text(_formatDuration(musicProvider.duration)),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           IconButton(
//                             iconSize: 48,
//                             icon: const Icon(Icons.skip_previous),
//                             onPressed: musicProvider.playPreviousSong,
//                           ),
//                           const SizedBox(width: 20),
//                           IconButton(
//                             iconSize: 64,
//                             icon: musicProvider.isPlaying
//                                 ? const Icon(Icons.pause_circle_filled)
//                                 : const Icon(Icons.play_circle_filled),
//                             onPressed: () {
//                               if (musicProvider.isPlaying) {
//                                 musicProvider.pauseSong();
//                               } else {
//                                 musicProvider.resumeSong();
//                               }
//                             },
//                           ),
//                           const SizedBox(width: 20),
//                           IconButton(
//                             iconSize: 48,
//                             icon: const Icon(Icons.skip_next),
//                             onPressed: musicProvider.playNextSong,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//         );
//       },
//     );
//   }
// }
