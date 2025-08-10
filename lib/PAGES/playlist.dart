import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/profile.dart';
import 'package:music_playlist/components/drawer.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<Map<String, dynamic>> playlists = [];

  Future<void> _createPlaylist() async {
    String playlistName = "";
    List<Map<String, String>> songs = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Create New Playlist"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Playlist Name",
                      ),
                      onChanged: (value) {
                        playlistName = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: [
                            'mp3',
                            'wav',
                            'aac',
                            'm4a',
                            'mp4'
                          ],
                          allowMultiple: true,
                        );

                        if (result != null) {
                          songs = result.paths
                              .where((path) => path != null)
                              .map((path) => {
                                    "name": path!.split('/').last,
                                    "path": path,
                                  })
                              .toList();
                          setDialogState(() {});
                        }
                      },
                      child: const Text("Select Songs"),
                    ),
                    if (songs.isNotEmpty)
                      Column(
                        children: songs
                            .map((song) => ListTile(
                                  leading: const Icon(Icons.music_note,
                                      color: Colors.blue),
                                  title: Text(song["name"]!),
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (playlistName.trim().isNotEmpty && songs.isNotEmpty) {
                      setState(() {
                        playlists.add({
                          "name": playlistName,
                          "songs": songs,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openPlaylist(Map<String, dynamic> playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistSongsPage(
          playlistName: playlist["name"],
          songs: playlist["songs"],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text("playlist"),
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
      body: playlists.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "lib/images/noPlaylist.png",
                      height: 70,
                      width: 70,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No playlists yet.\nTap + to create one.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(playlists[index]["name"]),
                  subtitle: Text("${playlists[index]["songs"].length} songs"),
                  leading: const Icon(Icons.folder, color: Colors.blue),
                  onTap: () => _openPlaylist(playlists[index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPlaylist,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 40,
        ),
      ),
    );
  }
}

class PlaylistSongsPage extends StatefulWidget {
  final String playlistName;
  final List<Map<String, String>> songs;

  const PlaylistSongsPage({
    super.key,
    required this.playlistName,
    required this.songs,
  });

  @override
  State<PlaylistSongsPage> createState() => _PlaylistSongsPageState();
}

class _PlaylistSongsPageState extends State<PlaylistSongsPage> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentlyPlaying;
  bool _isPlaying = false;

  void _playSong(String path) async {
    if (_currentlyPlaying == path && _isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      await _player.play(DeviceFileSource(path));
      setState(() {
        _currentlyPlaying = path;
        _isPlaying = true;
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
      ),
      body: ListView.builder(
        itemCount: widget.songs.length,
        itemBuilder: (context, index) {
          String songName = widget.songs[index]["name"]!;
          String songPath = widget.songs[index]["path"]!;
          bool isCurrent = _currentlyPlaying == songPath;

          return ListTile(
            leading: Icon(
              isCurrent && _isPlaying ? Icons.pause_circle : Icons.play_circle,
              color: Colors.blue,
            ),
            title: Text(songName),
            onTap: () => _playSong(songPath),
          );
        },
      ),
    );
  }
}
