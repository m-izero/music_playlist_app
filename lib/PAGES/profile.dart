import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: const SizedBox(
        height: 20,
        width: 50,
      ),
    );
  }
}
