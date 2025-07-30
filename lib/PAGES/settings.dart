import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/profile.dart';
import 'package:music_playlist/components/drawer.dart';

class Screen4 extends StatelessWidget {
  const Screen4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text("settings"),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 150,
          width: 340,
          decoration: BoxDecoration(
            color: Colors.blue[500],
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "GET MusicUp ViP Services",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("No ads",
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.normal,
                        )),
                    SizedBox(),
                    Text("Free Download"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
