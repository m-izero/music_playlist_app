import 'package:flutter/material.dart';
import 'package:music_playlist/components/text_fields.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../PAGES/home.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Create an Account in MusicUp🎶",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1d2ec3),
                )),
            const SizedBox(height: 20),

            // Username
            MyTextField(
              controller: usernameController,
              hintText: 'Username',
              displayText: false,
              prefixIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: 15),

            // Email
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              displayText: false,
              prefixIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: 15),

            // Password
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              displayText: true,
              prefixIcon: const Icon(Icons.lock),
            ),
            const SizedBox(height: 15),

            // Confirm Password
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              displayText: true,
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 20),

            // Sign Up button
            GestureDetector(
              onTap: () {
                final username = usernameController.text;
                final email = emailController.text;
                final password = passwordController.text;
                final confirmPassword = confirmPasswordController.text;

                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passwords do not match!"),
                    ),
                  );
                  return;
                }

                // Save user data to provider
                Provider.of<UserProvider>(context, listen: false)
                    .login(username, email);

                // Go to home page after signup
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
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Already have an account? Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // go back to login page
                  },
                  child: const Text(
                    'Login',
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
