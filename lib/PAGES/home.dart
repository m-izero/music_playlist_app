import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_playlist/PAGES/profile.dart';
import 'package:music_playlist/PAGES/settings.dart';
import 'package:music_playlist/components/audio_manager.dart';
import 'package:music_playlist/models/audio_models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'dart:io';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  final GlobalKey<_HomePageState> _homePageKey = GlobalKey<_HomePageState>();
  final GlobalKey<_PlaylistPageState> _playlistPageKey =
      GlobalKey<_PlaylistPageState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomePage(key: _homePageKey),
          PlaylistPage(key: _playlistPageKey),
          MusicPlayerPage(),
          const Screen4(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xFF1A1A2E)],
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xff6c63ff),
          unselectedItemColor: Colors.grey,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Now Playing',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// HOME PAGE
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioManager _audioManager = AudioManager();
  List<AudioFile> _recentlyPlayed = [];

  @override
  void initState() {
    super.initState();
    _audioManager.init();
    _audioManager.addListener(_onAudioManagerUpdate);
    _loadRecentlyPlayed();
  }

  @override
  void dispose() {
    _audioManager.removeListener(_onAudioManagerUpdate);
    super.dispose();
  }

  void _onAudioManagerUpdate() {
    if (mounted) {
      setState(() {});
      _loadRecentlyPlayed();
    }
  }

  Future<void> _loadRecentlyPlayed() async {
    final recent = await _audioManager.getRecentlyPlayed();
    setState(() {
      _recentlyPlayed = recent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF16213E),
              Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good ${_getGreeting()}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Music Lover',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.person),
                      )
                    ],
                  ),

                  SizedBox(height: 30),

                  // Add Music Button
                  GestureDetector(
                    onTap: () async {
                      await _audioManager.pickAudioFiles();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF4834DF)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add_circle_outline,
                              color: Colors.white, size: 30),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add Music Files',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Pick audio files from your device',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Music Library Info
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E2D),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.music_note,
                            color: Color(0xFF6C63FF), size: 30),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Music Library',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_audioManager.audioFiles.length} songs • ${_audioManager.playlists.length} playlists',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Recently Played
                  if (_recentlyPlayed.isNotEmpty) ...[
                    Text(
                      'Recently Played',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _recentlyPlayed.length,
                        itemBuilder: (context, index) {
                          AudioFile audioFile = _recentlyPlayed[index];
                          return GestureDetector(
                            onTap: () => _audioManager.playAudio(audioFile),
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.only(right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF667eea),
                                          Color(0xFF764ba2),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    audioFile.displayName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    audioFile.artist ?? 'Unknown Artist',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                  ],

                  // Quick Actions
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAction(
                          'All Songs',
                          '${_audioManager.audioFiles.length} tracks',
                          Icons.music_note,
                          () {
                            // Navigate to all songs
                          },
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildQuickAction(
                          'Playlists',
                          '${_audioManager.playlists.length} lists',
                          Icons.playlist_play,
                          () {
                            // Navigate to playlists
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E2D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Color(0xFF6C63FF), size: 24),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}

// PLAYLIST/LIBRARY PAGE - Enhanced Version
class PlaylistPage extends StatefulWidget {
  PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage>
    with SingleTickerProviderStateMixin {
  final AudioManager _audioManager = AudioManager();
  late TabController _tabController;
  final TextEditingController _playlistNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _audioManager.addListener(_onAudioManagerUpdate);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _playlistNameController.dispose();
    _audioManager.removeListener(_onAudioManagerUpdate);
    super.dispose();
  }

  void _onAudioManagerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF16213E),
              Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Library',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: _showCreatePlaylistDialog,
                        ),
                        IconButton(
                          icon: Icon(Icons.search, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Color(0xFF6C63FF),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[400],
                  tabs: [
                    Tab(text: 'All Songs (${_audioManager.audioFiles.length})'),
                    Tab(text: 'Playlists (${_audioManager.playlists.length})'),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Tab Bar View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAllSongsTab(),
                    _buildPlaylistsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllSongsTab() {
    if (_audioManager.audioFiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_off, color: Colors.grey[400], size: 64),
            SizedBox(height: 16),
            Text(
              'No music files found',
              style: TextStyle(color: Colors.grey[400], fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Add some music from the home screen',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _audioManager.pickAudioFiles,
              child: Text('Add Music'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C63FF),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: _audioManager.audioFiles.length,
      itemBuilder: (context, index) {
        AudioFile audioFile = _audioManager.audioFiles[index];
        bool isCurrentPlaying =
            _audioManager.currentAudio?.path == audioFile.path;

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            tileColor: isCurrentPlaying
                ? Color(0xFF6C63FF).withOpacity(0.1)
                : Color(0xFF1E1E2D),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF6C63FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                  isCurrentPlaying && _audioManager.isPlaying
                      ? Icons.pause
                      : Icons.music_note,
                  color: Colors.white),
            ),
            title: Text(
              audioFile.displayName,
              style: TextStyle(
                color: isCurrentPlaying ? Color(0xFF6C63FF) : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${audioFile.artist ?? "Unknown Artist"} • ${audioFile.size}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.grey[400]),
              color: Color(0xFF1E1E2D),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.playlist_add, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Add to Playlist',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  value: 'add_to_playlist',
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Remove', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  value: 'remove',
                ),
              ],
              onSelected: (value) {
                if (value == 'remove') {
                  _audioManager.removeAudioFile(audioFile);
                } else if (value == 'add_to_playlist') {
                  _showAddToPlaylistDialog(audioFile);
                }
              },
            ),
            onTap: () {
              if (isCurrentPlaying) {
                _audioManager.togglePlayPause();
              } else {
                _audioManager.playAudio(audioFile);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildPlaylistsTab() {
    if (_audioManager.playlists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.playlist_add, color: Colors.grey[400], size: 64),
            SizedBox(height: 16),
            Text(
              'No playlists created',
              style: TextStyle(color: Colors.grey[400], fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Create your first playlist',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showCreatePlaylistDialog,
              child: Text('Create Playlist'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C63FF),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: _audioManager.playlists.length,
      itemBuilder: (context, index) {
        Playlist playlist = _audioManager.playlists[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaylistDetailPage(playlist: playlist),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFF1E1E2D),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF667eea),
                        Color(0xFF764ba2),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.playlist_play,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playlist.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${playlist.songs.length} songs',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                  color: Color(0xFF1E1E2D),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Play All',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      value: 'play_all',
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.shuffle, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Shuffle Play',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      value: 'shuffle_play',
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Edit', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      value: 'edit',
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      value: 'delete',
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'play_all') {
                      _playPlaylist(playlist, false);
                    } else if (value == 'shuffle_play') {
                      _playPlaylist(playlist, true);
                    } else if (value == 'edit') {
                      _showEditPlaylistDialog(playlist);
                    } else if (value == 'delete') {
                      _showDeletePlaylistDialog(playlist);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _playPlaylist(Playlist playlist, bool shuffle) {
    if (playlist.songs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This playlist is empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (shuffle) {
      _audioManager.toggleShuffle();
      final randomIndex = Random().nextInt(playlist.songs.length);
      _audioManager.playAudio(playlist.songs[randomIndex]);
    } else {
      _audioManager.playAudio(playlist.songs[0]);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(shuffle
            ? 'Shuffling ${playlist.name}'
            : 'Playing ${playlist.name}'),
        backgroundColor: Color(0xFF6C63FF),
      ),
    );
  }

  void _showCreatePlaylistDialog() {
    _playlistNameController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E1E2D),
        title: Text('Create Playlist', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _playlistNameController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter playlist name',
            hintStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6C63FF)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6C63FF)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () {
              if (_playlistNameController.text.trim().isNotEmpty) {
                _audioManager
                    .createPlaylist(_playlistNameController.text.trim(), []);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Playlist "${_playlistNameController.text.trim()}" created'),
                    backgroundColor: Color(0xFF6C63FF),
                  ),
                );
              }
            },
            child: Text('Create', style: TextStyle(color: Color(0xFF6C63FF))),
          ),
        ],
      ),
    );
  }

  void _showEditPlaylistDialog(Playlist playlist) {
    _playlistNameController.text = playlist.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E1E2D),
        title: Text('Edit Playlist', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _playlistNameController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter playlist name',
            hintStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6C63FF)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6C63FF)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () {
              if (_playlistNameController.text.trim().isNotEmpty) {
                // Update playlist name logic would go here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Playlist renamed to "${_playlistNameController.text.trim()}"'),
                    backgroundColor: Color(0xFF6C63FF),
                  ),
                );
              }
            },
            child: Text('Save', style: TextStyle(color: Color(0xFF6C63FF))),
          ),
        ],
      ),
    );
  }

  void _showDeletePlaylistDialog(Playlist playlist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E1E2D),
        title: Text('Delete Playlist', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${playlist.name}"? This action cannot be undone.',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () {
              // Actually delete the playlist from the AudioManager
              _audioManager.playlists.remove(playlist);
              Navigator.pop(context);
              setState(() {}); // Refresh the UI
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Playlist "${playlist.name}" deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddToPlaylistDialog(AudioFile audioFile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E1E2D),
        title: Text('Add to Playlist', style: TextStyle(color: Colors.white)),
        content: Container(
          width: double.maxFinite,
          height: _audioManager.playlists.isEmpty
              ? 100
              : _audioManager.playlists.length > 5
                  ? 300
                  : _audioManager.playlists.length * 60.0,
          child: _audioManager.playlists.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.playlist_add,
                          color: Colors.grey[400], size: 48),
                      SizedBox(height: 8),
                      Text(
                        'No playlists available',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _audioManager.playlists.length,
                  itemBuilder: (context, index) {
                    Playlist playlist = _audioManager.playlists[index];
                    bool songExists = playlist.songs
                        .any((song) => song.path == audioFile.path);

                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: songExists ? Colors.green : Color(0xFF6C63FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          songExists ? Icons.check : Icons.playlist_play,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(playlist.name,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                        songExists
                            ? 'Already added • ${playlist.songs.length} songs'
                            : '${playlist.songs.length} songs',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      onTap: songExists
                          ? null
                          : () {
                              // Add song to playlist logic
                              playlist.songs.add(audioFile);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Added "${audioFile.displayName}" to "${playlist.name}"'),
                                  backgroundColor: Color(0xFF6C63FF),
                                ),
                              );
                              setState(() {}); // Refresh the UI
                            },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.grey[400])),
          ),
          if (_audioManager.playlists.isEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showCreatePlaylistDialog();
              },
              child: Text('Create Playlist',
                  style: TextStyle(color: Color(0xFF6C63FF))),
            ),
        ],
      ),
    );
  }
}

// PLAYLIST DETAIL PAGE
class PlaylistDetailPage extends StatelessWidget {
  final Playlist playlist;
  final AudioManager _audioManager = AudioManager();

  PlaylistDetailPage({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF16213E),
              Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        playlist.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.shuffle, color: Color(0xFF6C63FF)),
                      onPressed: () {
                        if (playlist.songs.isNotEmpty) {
                          _audioManager.toggleShuffle();
                          final randomSong = playlist
                              .songs[Random().nextInt(playlist.songs.length)];
                          _audioManager.playAudio(randomSong);
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Playlist Info
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E2D),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                      ),
                      child: Icon(Icons.playlist_play,
                          color: Colors.white, size: 40),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playlist.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${playlist.songs.length} songs',
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 14),
                          ),
                          Text(
                            'Created ${_formatDate(playlist.created)}',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Songs List
              Expanded(
                child: playlist.songs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.music_off,
                                color: Colors.grey[400], size: 64),
                            SizedBox(height: 16),
                            Text(
                              'No songs in this playlist',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: playlist.songs.length,
                        itemBuilder: (context, index) {
                          AudioFile song = playlist.songs[index];
                          bool isCurrentPlaying =
                              _audioManager.currentAudio?.path == song.path;

                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              tileColor: isCurrentPlaying
                                  ? Color(0xFF6C63FF).withOpacity(0.1)
                                  : Colors.transparent,
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF6C63FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                    isCurrentPlaying && _audioManager.isPlaying
                                        ? Icons.pause
                                        : Icons.music_note,
                                    color: Colors.white),
                              ),
                              title: Text(
                                song.displayName,
                                style: TextStyle(
                                  color: isCurrentPlaying
                                      ? Color(0xFF6C63FF)
                                      : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${song.artist ?? "Unknown Artist"} • ${song.size}',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(Icons.more_vert,
                                  color: Colors.grey[400]),
                              onTap: () {
                                if (isCurrentPlaying) {
                                  _audioManager.togglePlayPause();
                                } else {
                                  _audioManager.playAudio(song);
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'today';
    if (difference == 1) return 'yesterday';
    if (difference < 7) return '$difference days ago';
    if (difference < 30) return '${(difference / 7).round()} weeks ago';
    return '${(difference / 30).round()} months ago';
  }
}

// MUSIC PLAYER PAGE
class MusicPlayerPage extends StatefulWidget {
  MusicPlayerPage();

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with TickerProviderStateMixin {
  final AudioManager _audioManager = AudioManager();
  late AnimationController _rotationController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _audioManager.addListener(_onAudioManagerUpdate);

    _rotationController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    if (_audioManager.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _audioManager.removeListener(_onAudioManagerUpdate);
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onAudioManagerUpdate() {
    if (mounted) {
      setState(() {
        if (_audioManager.isPlaying) {
          if (!_rotationController.isAnimating) {
            _rotationController.repeat();
          }
        } else {
          _rotationController.stop();
        }
      });
    }
  }

  void _togglePlayPause() async {
    await _audioManager.togglePlayPause();

    if (_audioManager.isPlaying) {
      _scaleController.forward();
    } else {
      _scaleController.reverse();
    }

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final currentAudio = _audioManager.currentAudio;

    if (currentAudio == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2D1B69),
                Color(0xFF0A0E27),
                Color(0xFF000000),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_off, color: Colors.grey[400], size: 64),
                  SizedBox(height: 20),
                  Text(
                    'No music playing',
                    style: TextStyle(color: Colors.grey[400], fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Select a song to start playing',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D1B69),
              Color(0xFF0A0E27),
              Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Column(
                      children: [
                        Text(
                          'NOW PLAYING',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Local Storage',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Album Art
                    AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationController.value * 2 * pi,
                          child: Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color(0xFF6C63FF),
                                  Color(0xFF4834DF),
                                  Color(0xFF2D1B69),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF6C63FF).withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black26,
                                ),
                                child: Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Song Info
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Text(
                            currentAudio.displayName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            currentAudio.artist ?? 'Unknown Artist',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Progress Bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Color(0xFF6C63FF),
                              inactiveTrackColor: Colors.grey[800],
                              thumbColor: Color(0xFF6C63FF),
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value:
                                  _audioManager.totalDuration.inMilliseconds > 0
                                      ? _audioManager
                                              .currentPosition.inMilliseconds /
                                          _audioManager
                                              .totalDuration.inMilliseconds
                                      : 0.0,
                              onChanged: (value) {
                                final position = Duration(
                                  milliseconds: (value *
                                          _audioManager
                                              .totalDuration.inMilliseconds)
                                      .round(),
                                );
                                _audioManager.seek(position);
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_audioManager.currentPosition),
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _formatDuration(_audioManager.totalDuration),
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Control Buttons
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.shuffle,
                              color: _audioManager.isShuffled
                                  ? Color(0xFF6C63FF)
                                  : Colors.grey[400],
                              size: 24,
                            ),
                            onPressed: _audioManager.toggleShuffle,
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_previous,
                                color: Colors.white, size: 40),
                            onPressed: _audioManager.playPrevious,
                          ),
                          GestureDetector(
                            onTap: _togglePlayPause,
                            child: AnimatedScale(
                              scale: _audioManager.isPlaying ? 1.1 : 1.0,
                              duration: Duration(milliseconds: 200),
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF6C63FF),
                                      Color(0xFF4834DF),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF6C63FF).withOpacity(0.4),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _audioManager.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_next,
                                color: Colors.white, size: 40),
                            onPressed: _audioManager.playNext,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.repeat,
                              color: _audioManager.isRepeated
                                  ? Color(0xFF6C63FF)
                                  : Colors.grey[400],
                              size: 24,
                            ),
                            onPressed: _audioManager.toggleRepeat,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Controls
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border,
                          color: Colors.grey[400], size: 24),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.playlist_add,
                          color: Colors.grey[400], size: 24),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
