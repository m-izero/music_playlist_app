import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/home.dart';
import 'package:music_playlist/PAGES/playlist.dart';
import 'package:music_playlist/PAGES/settings.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xff266ba4),
        width: 200,
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: const Text('Home'),
              textColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Screen1()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              title: const Text('Search'),
              textColor: Colors.white,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlaylistPage()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.playlist_add,
                color: Colors.white,
              ),
              title: const Text('Playlist'),
              textColor: Colors.white,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlaylistPage()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: const Text('settings'),
              textColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Screen4()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              title: const Text('favorites'),
              textColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.upgrade,
                color: Colors.white,
              ),
              title: const Text('upgrade'),
              textColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
