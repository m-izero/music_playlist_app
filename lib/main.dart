import 'package:flutter/material.dart';
import 'package:music_playlist/login_pages/login.dart';
import 'package:provider/provider.dart';
import 'providers/music_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => MusicProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Consistent theme color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(
        onTap: () {},
      ),
    );
  }
}
