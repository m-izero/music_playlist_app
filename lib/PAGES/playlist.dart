import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/profile.dart';
import 'package:music_playlist/components/drawer.dart';

class Screen3 extends StatelessWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text("playlist"),
        backgroundColor: Colors.blue[500],
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: const Center(child: Text("hello playlist")),
    );
  }
}
