import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: SizedBox(
        child: Container(
          height: 20,
          width: 50,
        ),
      ),
    );
  }
}
