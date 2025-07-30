import 'package:flutter/cupertino.dart';
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
        color: const Color(0xff063153),
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text('Home'),
              textColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Screen1()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.search,
                color: Colors.white,
              ),
              title: Text('Search'),
              textColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Screen3()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.playlist_add,
                color: Colors.white,
              ),
              title: Text('Playlist'),
              textColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Screen3()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: Text('settings'),
              textColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Screen4()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              title: Text('favorites'),
              textColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.upgrade,
                color: Colors.white,
              ),
              title: Text('upgrade'),
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
