import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/profile.dart';
import 'package:music_playlist/login_pages/login.dart';

import '../components/drawer.dart';

// class Screen4 extends StatelessWidget {
//   const Screen4({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[100],
//       appBar: AppBar(
//         title: const Text("settings"),
//         backgroundColor: Colors.blue[500],
//         centerTitle: true,
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const ProfilePage()));
//               },
//               icon: const Icon(Icons.person))
//         ],
//       ),
//       drawer: const DrawerPage(),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Container(
//           height: 150,
//           width: 340,
//           decoration: BoxDecoration(
//             color: Colors.blue[500],
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: const Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   "GET MusicUp ViP Services",
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: Row(
//                   children: [
//                     Text("No ads",
//                         style: TextStyle(
//                           fontSize: 15.5,
//                           fontWeight: FontWeight.normal,
//                         )),
//                     SizedBox(),
//                     Text("Free Download"),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// The SettingsPage is a stateful widget because it needs to manage
// the state of various settings like toggles and sliders.
class Screen4 extends StatefulWidget {
  const Screen4({super.key});

  @override
  // Creates the mutable state for this widget.
  State<Screen4> createState() => _Screen4State();
}

// The State class for the SettingsPage.
// This is where the actual UI and state management for the settings are handled.
class _Screen4State extends State<Screen4> {
  // State variables to hold the current values of the settings.
  bool _isDarkModeEnabled = false;
  bool _areNotificationsEnabled = true;
  double _volumeLevel = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text("settings"),
        backgroundColor: Colors.blue[500],
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
              icon: const Icon(Icons.person))
        ],
      ),
      drawer: const DrawerPage(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const ListTile(
            title: Text(
              'General',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode),
            value: _isDarkModeEnabled,
            activeColor: Colors.blue,
            onChanged: (bool value) {
              setState(() {
                _isDarkModeEnabled = value;
                print('Dark Mode is now: $_isDarkModeEnabled');
              });
            },
          ),

          // Notifications toggle.
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive updates and new music alerts.'),
            secondary: const Icon(Icons.notifications),
            value: _areNotificationsEnabled,
            activeColor: Colors.blue,
            onChanged: (bool value) {
              setState(() {
                _areNotificationsEnabled = value;
                print('Notifications are now: $_areNotificationsEnabled');
              });
            },
          ),

          // Volume control slider.
          ListTile(
            title: const Text('Volume'),
            subtitle: Slider(
              value: _volumeLevel,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: (_volumeLevel * 100).round().toString(),
              activeColor: Colors.blue,
              onChanged: (double value) {
                setState(() {
                  _volumeLevel = value;
                });
              },
              onChangeEnd: (double value) {
                // This is a good place to trigger an action after the user
                // has finished adjusting the slider, like saving the setting.
                print('Volume level set to: $_volumeLevel');
              },
            ),
            trailing: Text(
              '${(_volumeLevel * 100).round()}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const Divider(height: 32),

          // Section header for "Account".
          const ListTile(
            title: Text(
              'Account',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),

          // Log Out button.
          ListTile(
            title: const Text('Log Out'),
            leading: const Icon(Icons.logout, color: Colors.black),
            // The `onTap` callback is used to handle user interaction.
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(onTap: () {})));
              print('Log Out button pressed');
              // A simple snackbar to show the button was tapped.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out...')),
              );
            },
          ),
        ],
      ),
    );
  }
}
