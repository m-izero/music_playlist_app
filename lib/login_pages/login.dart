import 'package:flutter/material.dart';
import 'package:music_playlist/components/text_fields.dart';
import 'package:music_playlist/login_pages/signup_page.dart';
import 'package:provider/provider.dart';

import '../PAGES/home.dart';
import '../providers/user_provider.dart';

class LoginPage extends StatelessWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  void signInUser() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 28),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        'lib/images/music_icon.jpg',
                        fit: BoxFit.fill,
                      )),
                ),
              ),
            ),
            const SizedBox(height: 20),
            //title
            const Text("LOGIN to MusicUp🎵",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1d2ec3),
                )),
            const SizedBox(height: 20),
            //inputs
            MyTextField(
              controller: userNameController,
              hintText: 'Email',
              displayText: false,
              prefixIcon: const Icon(Icons.email),
            ),

            const SizedBox(height: 15),

            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              displayText: true,
              prefixIcon: const Icon(Icons.lock),
            ),
            //forget message
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: null,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //button

            GestureDetector(
              onTap: () {
                final username = userNameController.text;
                final password = userNameController.text;

                // Save to provider
                Provider.of<UserProvider>(context, listen: false)
                    .login(username, password);

                // Navigate to the next screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Screen1()),
                );
              },
              child: Container(
                height: 50,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            //continue with google
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.7,
                      color: Color(0xff2b2a2a),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text("Or Continue With"),
                  SizedBox(width: 5),
                  Expanded(
                    child: Divider(
                      thickness: 0.7,
                      color: Color(0xff2b2a2a),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            //buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'lib/images/Apple_music_icon.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'lib/images/spotify_icon.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'lib/images/Google_icon.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            //signup option
            //signup option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Do not have an account?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
