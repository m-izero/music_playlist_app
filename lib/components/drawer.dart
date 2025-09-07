import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/home.dart';
import 'package:music_playlist/PAGES/playlist.dart';
import 'package:music_playlist/PAGES/settings.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Custom Drawer Header
            Container(
              height: 200,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6C63FF),
                    Color(0xFF4834DF),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'MusicUp',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Your Music, Your Way',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Navigation Items
            _buildDrawerItem(
              context,
              icon: Icons.home_rounded,
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),

            _buildDrawerItem(
              context,
              icon: Icons.search_rounded,
              title: 'Search',
              onTap: () {
                Navigator.pop(context);
                // Navigate to specific tab if needed
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),

            _buildDrawerItem(
              context,
              icon: Icons.library_music_rounded,
              title: 'Your Library',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),

            _buildDrawerItem(
              context,
              icon: Icons.playlist_play_rounded,
              title: 'Playlists',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),

            // Divider
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Divider(color: Colors.grey[700], thickness: 1),
            ),

            _buildDrawerItem(
              context,
              icon: Icons.favorite_rounded,
              title: 'Favorites',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Favorites feature coming soon!'),
                    backgroundColor: Color(0xFF6C63FF),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),

            _buildDrawerItem(
              context,
              icon: Icons.history_rounded,
              title: 'Recently Played',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Recently played feature coming soon!'),
                    backgroundColor: Color(0xFF6C63FF),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),

            _buildDrawerItem(
              context,
              icon: Icons.download_rounded,
              title: 'Downloads',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Downloads feature coming soon!'),
                    backgroundColor: Color(0xFF6C63FF),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),

            // Another Divider
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Divider(color: Colors.grey[700], thickness: 1),
            ),

            _buildDrawerItem(
              context,
              icon: Icons.settings_rounded,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Screen4()),
                );
              },
            ),

            _buildDrawerItem(
              context,
              icon: Icons.star_rounded,
              title: 'Upgrade to Premium',
              isSpecial: true,
              onTap: () {
                Navigator.pop(context);
                _showUpgradeDialog(context);
              },
            ),

            SizedBox(height: 20),

            // Footer
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '© 2024 MusicUp',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSpecial = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isSpecial
            ? LinearGradient(
                colors: [
                  Color(0xFF6C63FF).withOpacity(0.2),
                  Color(0xFF4834DF).withOpacity(0.2),
                ],
              )
            : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSpecial
                ? Color(0xFF6C63FF).withOpacity(0.3)
                : Color(0xFF1E1E2D),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSpecial ? Color(0xFF6C63FF) : Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSpecial ? Color(0xFF6C63FF) : Colors.white,
            fontSize: 16,
            fontWeight: isSpecial ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: isSpecial
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4834DF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'PRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E1E2D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4834DF)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Upgrade to Premium',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Unlock unlimited music, ad-free experience, and exclusive features',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF0A0E27),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildFeatureItem('✓ Unlimited song uploads'),
                    _buildFeatureItem('✓ Ad-free listening'),
                    _buildFeatureItem('✓ High-quality audio'),
                    _buildFeatureItem('✓ Offline downloads'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Maybe Later',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF4834DF)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Premium upgrade coming soon!'),
                              backgroundColor: Color(0xFF6C63FF),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Upgrade Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
