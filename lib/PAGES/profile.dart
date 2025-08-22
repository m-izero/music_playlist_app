import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

// class UserProfile {
//   final String name;
//   final String email;
//   final String avatarUrl;
//   final List<String> favoriteGenres;

//   UserProfile({
//     required this.name,
//     required this.email,
//     required this.avatarUrl,
//     required this.favoriteGenres,
//   });
// }

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   // UserProfile? _userProfile;

//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     // In a real application, you would fetch data from an API or a database here.
//     // For this example, we'll simulate a network delay.
//     _fetchUserProfile();
//   }

//   Future<void> _fetchUserProfile() async {
//     // Simulate a network delay of 2 seconds.
//     await Future.delayed(const Duration(seconds: 2));

//     // After the delay, we update the state with the dummy user data.
//     setState(() {
//       _userProfile = UserProfile(
//         avatarUrl:
//             'https://www.flaticon.com/free-icon/user_9187604?term=profile&related_id=9187604',
//         favoriteGenres: ['Hip Hop', 'R&B', 'Electronic', 'Jazz'],
//         name: user?.name,
//         email: user?.email,
//       );
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserProvider>(context);

//     return Scaffold(
//       backgroundColor: Colors.blue[100],
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text(
//           'Profile',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Center(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       CircleAvatar(
//                         radius: 60,
//                         backgroundImage:
//                             _userProfile!.avatarUrl.startsWith('http')
//                                 ? NetworkImage(_userProfile!.avatarUrl)
//                                 : FileImage(File(_userProfile!.avatarUrl))
//                                     as ImageProvider,
//                       ),

//                       const SizedBox(height: 16),

//                       Text(
//                         "${user?.username}",
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       // Display the user's email from the fetched data.
//                       Text(
//                         "${user?.email}",
//                         // _userProfile!.email,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       const Text(
//                         'Favorite Genres',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       // Use a `...map` to dynamically create chips from the list of genres.
//                       Wrap(
//                         spacing: 8.0,
//                         runSpacing: 4.0,
//                         children: _userProfile!.favoriteGenres
//                             .map((genre) => Chip(label: Text(genre)))
//                             .toList(),
//                       ),
//                       const SizedBox(height: 24),
//                       ElevatedButton.icon(
//                         onPressed: () async {
//                           // Action for editing the profile.
//                           print('Edit Profile button pressed');
//                           // Use Navigator.push to navigate to the new EditProfilePage.
//                           // The `await` keyword waits for the page to be popped (closed),
//                           // and the result (the updated UserProfile object) is returned.
//                           final updatedProfile = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => EditProfilePage(
//                                 initialProfile: _userProfile!,
//                               ),
//                             ),
//                           );

//                           // If the user saved changes, `updatedProfile` will not be null.
//                           // We then update the state of the ProfilePage to reflect the changes.
//                           if (updatedProfile != null) {
//                             setState(() {
//                               _userProfile = updatedProfile as UserProfile;
//                             });
//                           }
//                         },
//                         icon: const Icon(Icons.edit),
//                         label: const Text('Edit Profile'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: user.avatarUrl.startsWith("http")
                      ? NetworkImage(user.avatarUrl)
                      : FileImage(File(user.avatarUrl)) as ImageProvider,
                ),
                const SizedBox(height: 16),
                Text(
                  user.username.isNotEmpty ? user.username : "No Username",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email.isNotEmpty ? user.email : "No Email",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Favorite Genres",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: user.favoriteGenres
                      .map((g) => Chip(label: Text(g)))
                      .toList(),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// A new StatefulWidget for the profile editing page.
// class EditProfilePage extends StatefulWidget {
//   // It takes the current profile as an argument to pre-fill the text fields.
//   final UserProfile initialProfile;
//   const EditProfilePage({super.key, required this.initialProfile});

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   // Controllers for the text fields to manage user input.
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   final List<String> _genres = [];
//   final TextEditingController _newGenreController = TextEditingController();

//   // The avatar URL is now managed here to be passed back to the ProfilePage.
//   late String _avatarUrl;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the controllers and avatar URL with the data from the initial profile.
//     _nameController = TextEditingController(text: widget.initialProfile.name);
//     _emailController = TextEditingController(text: widget.initialProfile.email);
//     _genres.addAll(widget.initialProfile.favoriteGenres);
//     _avatarUrl = widget.initialProfile.avatarUrl;
//   }

//   @override
//   void dispose() {
//     // Dispose of the controllers when the widget is removed to free up resources.
//     _nameController.dispose();
//     _emailController.dispose();
//     _newGenreController.dispose();
//     super.dispose();
//   }

//   // A method to handle adding a new genre.
//   void _addGenre() {
//     final newGenre = _newGenreController.text.trim();
//     if (newGenre.isNotEmpty) {
//       setState(() {
//         _genres.add(newGenre);
//         _newGenreController.clear();
//       });
//     }
//   }

//   // A method to handle removing a genre.
//   void _removeGenre(String genre) {
//     setState(() {
//       _genres.remove(genre);
//     });
//   }

//   // A method to save the changes and navigate back.
//   void _saveChanges() {
//     // Create a new UserProfile object with the updated information.
//     final updatedProfile = UserProfile(
//       name: _nameController.text,
//       email: _emailController.text,
//       avatarUrl: _avatarUrl, // Pass the potentially new avatar URL.
//       favoriteGenres: _genres,
//     );

//     // Pop the current page from the navigation stack and pass the updated profile back.
//     Navigator.pop(context, updatedProfile);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[100],
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text('Edit Profile'),
//         centerTitle: true,
//         // The save button in the app bar.
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _saveChanges,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             // The profile picture section with an edit button.
//             Center(
//               child: Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 60,
//                     backgroundImage: _avatarUrl.startsWith('http')
//                         ? NetworkImage(_avatarUrl)
//                         : FileImage(File(_avatarUrl)) as ImageProvider,
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: InkWell(
//                       onTap: () async {
//                         // Navigate to the picture editing page and wait for the result.
//                         final newImagePath = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => EditProfilePicturePage(
//                               initialImagePath: _avatarUrl,
//                             ),
//                           ),
//                         );
//                         // If a new path is returned, update the state.
//                         if (newImagePath != null) {
//                           setState(() {
//                             _avatarUrl = newImagePath;
//                           });
//                         }
//                       },
//                       child: const CircleAvatar(
//                         radius: 18,
//                         backgroundColor: Colors.blue,
//                         child: Icon(
//                           Icons.edit,
//                           color: Colors.white,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Text field for editing the name.
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//                 prefixIcon: Icon(Icons.person),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Text field for editing the email.
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 prefixIcon: Icon(Icons.email),
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 24),
//             // Section for editing genres.
//             const Text(
//               'Favorite Genres',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Row for adding a new genre.
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _newGenreController,
//                     decoration: const InputDecoration(
//                       hintText: 'Add a new genre',
//                     ),
//                     onSubmitted: (_) => _addGenre(),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.add_circle),
//                   onPressed: _addGenre,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             // A wrap to display the current genres with a delete icon.
//             Wrap(
//               spacing: 8.0,
//               runSpacing: 4.0,
//               children: _genres.map((genre) {
//                 return Chip(
//                   label: Text(genre),
//                   onDeleted: () => _removeGenre(genre),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final TextEditingController _newGenreController = TextEditingController();
  List<String> _genres = [];
  late String _avatarUrl;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: user.username);
    _emailController = TextEditingController(text: user.email);
    _genres = List.from(user.favoriteGenres);
    _avatarUrl = user.avatarUrl;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _avatarUrl = image.path;
      });
    }
  }

  void _addGenre() {
    final newGenre = _newGenreController.text.trim();
    if (newGenre.isNotEmpty) {
      setState(() {
        _genres.add(newGenre);
        _newGenreController.clear();
      });
    }
  }

  void _saveChanges() {
    Provider.of<UserProvider>(context, listen: false).updateProfile(
      username: _nameController.text,
      email: _emailController.text,
      avatarUrl: _avatarUrl,
      genres: _genres,
    );
    Navigator.pop(context); // go back to profile page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveChanges),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _avatarUrl.startsWith("http")
                      ? NetworkImage(_avatarUrl)
                      : FileImage(File(_avatarUrl)) as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Favorite Genres",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newGenreController,
                    decoration: const InputDecoration(hintText: "Add genre"),
                    onSubmitted: (_) => _addGenre(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addGenre),
              ],
            ),
            Wrap(
              spacing: 8,
              children: _genres
                  .map((g) => Chip(
                        label: Text(g),
                        onDeleted: () => setState(() => _genres.remove(g)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// A new StatefulWidget for the profile picture editing page.
class EditProfilePicturePage extends StatefulWidget {
  final String initialImagePath;
  const EditProfilePicturePage({super.key, required this.initialImagePath});

  @override
  State<EditProfilePicturePage> createState() => _EditProfilePicturePageState();
}

class _EditProfilePicturePageState extends State<EditProfilePicturePage> {
  // State variable to hold the new image URL.
  late String _currentImagePath;

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.initialImagePath;
  }

  // A method to handle picking a new picture.
  void _pickImage() async {
    // We create an instance of ImagePicker.
    final ImagePicker picker = ImagePicker();
    // Use the picker to select an image from the gallery.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // If an image was selected, update the state with its file path.
      setState(() {
        _currentImagePath = image.path;
      });
      // You can also provide a simple confirmation message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Picture changed! Tap save to apply.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Change Profile Picture'),
        centerTitle: true,
        actions: [
          // Save button to pass the new image path back.
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context, _currentImagePath);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the current (or new) profile picture.
            CircleAvatar(
              radius: 100,
              backgroundImage: _currentImagePath.startsWith('http')
                  ? NetworkImage(_currentImagePath)
                  : FileImage(File(_currentImagePath)) as ImageProvider,
            ),
            const SizedBox(height: 32),
            // Button to trigger the image picker function.
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Change Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
