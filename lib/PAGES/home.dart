import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/playlist.dart';
import 'package:music_playlist/PAGES/profile.dart';
import 'package:music_playlist/PAGES/settings.dart';
import 'package:music_playlist/components/drawer.dart';
import 'package:provider/provider.dart';

import '../providers/music_provider.dart';
import 'music_player_screen.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  int myIndex = 0;
  static const List<Widget> widgetList = [
    HomePage(),
    PlaylistPage(),
    Screen4(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList[myIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[500],
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add),
              label: 'Playlist',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.blue),
        ],
        currentIndex: myIndex,
        selectedItemColor: Colors.black,
        onTap: (int index) {
          setState(() {
            myIndex = index;
          });
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
          title: const Text("Home"),
          backgroundColor: Colors.blue[500],
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person))
          ]),
      drawer: const DrawerPage(),
      body: Consumer<MusicProvider>(
        builder: (context, musicProvider, child) {
          if (musicProvider.playlist.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: musicProvider.playlist.length,
            itemBuilder: (context, index) {
              final song = musicProvider.playlist[index];
              final isCurrentSong = index == musicProvider.currentIndex;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(song.albumArtUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: isCurrentSong && musicProvider.isPlaying
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black54,
                            ),
                            child: const Icon(
                              Icons.pause,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  title: Text(
                    song.title,
                    style: TextStyle(
                      fontWeight:
                          isCurrentSong ? FontWeight.bold : FontWeight.normal,
                      color: isCurrentSong ? Colors.blue : null,
                    ),
                  ),
                  subtitle: Text(song.artist),
                  trailing: IconButton(
                    icon: Icon(
                      isCurrentSong && musicProvider.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.blue,
                      size: 32,
                    ),
                    onPressed: () {
                      if (isCurrentSong) {
                        musicProvider.togglePlayPause();
                      } else {
                        musicProvider.playAtIndex(index);
                      }
                    },
                  ),
                  onTap: () {
                    if (!isCurrentSong) {
                      musicProvider.playAtIndex(index);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MusicPlayerScreen(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
