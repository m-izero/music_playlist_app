import 'dart:html';
import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/home.dart';
import 'package:music_playlist/PAGES/playlist.dart';
import 'package:music_playlist/PAGES/settings.dart';
import 'package:music_playlist/login_pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int myIndex = 0;
  List<Widget> widgetList = const [
    Screen1(),
    Screen3(),
    Screen4(),
    //Text("home"),
    //Text("search"),
    //Text("playlist"),
    //Text("settings"),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),

      // body: Center(
      //   child: widgetList[myIndex],
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.home),
      //         label: 'Home',
      //         backgroundColor: Colors.blue),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.playlist_add),
      //         label: 'Playlist',
      //         backgroundColor: Colors.blue),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.settings),
      //         label: 'Settings',
      //         backgroundColor: Colors.blue),
      //   ],
      //   currentIndex: myIndex,
      //   selectedItemColor: Colors.blue[800],
      //   onTap: (int index) {
      //     setState(() {
      //       myIndex = index;
      //     });
      //   },
      // ),
    );
  }
}
