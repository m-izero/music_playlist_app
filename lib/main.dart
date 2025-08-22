import 'package:flutter/material.dart';
import 'package:music_playlist/login_pages/login.dart';
import 'package:music_playlist/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'providers/music_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MusicProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
