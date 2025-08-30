import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
