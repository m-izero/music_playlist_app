import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/playlist.dart';
import 'package:music_playlist/PAGES/profile.dart';
import 'package:music_playlist/PAGES/settings.dart';
import 'package:music_playlist/components/drawer.dart';
import 'package:provider/provider.dart';

import '../providers/music_provider.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // We don't need to listen here, just access the songs list and methods
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.blue[100],
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
        ],
      ),
      drawer: const DrawerPage(),
      body: ListView.builder(
        itemCount: musicProvider.songs.length,
        itemBuilder: (context, index) {
          final song = musicProvider.songs[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(song.albumArtUrl),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            onTap: () async {
              await musicProvider.playSong(index);
            },
          );
        },
      ),
    );
  }
}
