import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/profile.dart';
import 'package:music_playlist/components/drawer.dart';

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text("Home"),
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
      drawer: const DrawerPage(),
      body: ListView(),

      /*Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: 160,
              color: Colors.black54,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: 160,
              color: Colors.black54,
            ),
          ),
        ],
      ),*/
    );
  }
}
