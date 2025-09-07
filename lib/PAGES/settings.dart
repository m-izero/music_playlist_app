import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/profile.dart';
import 'package:music_playlist/login_pages/login.dart';
import '../components/drawer.dart';

class Screen4 extends StatefulWidget {
  const Screen4({super.key});

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  bool _isDarkModeEnabled = true; // Already dark by default
  bool _areNotificationsEnabled = true;
  double _volumeLevel = 0.5;
  bool _autoPlayEnabled = true;
  bool _downloadOnWifiOnly = true;
  double _audioQuality = 0.8; // 0-1 scale

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerPage(),
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
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E2D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[800]!, width: 1),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E2D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[800]!, width: 1),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.person, color: Color(0xFF6C63FF)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  children: [
                    // App Settings Section
                    _buildSectionHeader('App Settings', Icons.settings),
                    SizedBox(height: 16),

                    // Dark Mode Switch
                    _buildSettingCard(
                      child: SwitchListTile(
                        title: Text(
                          'Dark Mode',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        subtitle: Text(
                          'Currently enabled system-wide',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        secondary: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C63FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              Icon(Icons.dark_mode, color: Color(0xFF6C63FF)),
                        ),
                        value: _isDarkModeEnabled,
                        activeColor: Color(0xFF6C63FF),
                        onChanged: (bool value) {
                          setState(() {
                            _isDarkModeEnabled = value;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Dark mode ${value ? 'enabled' : 'disabled'}'),
                              backgroundColor: Color(0xFF6C63FF),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 12),

                    // Notifications Switch
                    _buildSettingCard(
                      child: SwitchListTile(
                        title: Text(
                          'Push Notifications',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        subtitle: Text(
                          'Get notified about new music and updates',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        secondary: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C63FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.notifications,
                              color: Color(0xFF6C63FF)),
                        ),
                        value: _areNotificationsEnabled,
                        activeColor: Color(0xFF6C63FF),
                        onChanged: (bool value) {
                          setState(() {
                            _areNotificationsEnabled = value;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 12),

                    // Auto Play Switch
                    _buildSettingCard(
                      child: SwitchListTile(
                        title: Text(
                          'Auto Play Next',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        subtitle: Text(
                          'Automatically play next song in queue',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        secondary: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C63FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              Icon(Icons.skip_next, color: Color(0xFF6C63FF)),
                        ),
                        value: _autoPlayEnabled,
                        activeColor: Color(0xFF6C63FF),
                        onChanged: (bool value) {
                          setState(() {
                            _autoPlayEnabled = value;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 30),

                    // Audio Settings Section
                    _buildSectionHeader('Audio Settings', Icons.volume_up),
                    SizedBox(height: 16),

                    // Volume Control
                    _buildSettingCard(
                      child: ListTile(
                        title: Text(
                          'Volume',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Color(0xFF6C63FF),
                                inactiveTrackColor: Colors.grey[700],
                                thumbColor: Color(0xFF6C63FF),
                                thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 8,
                                ),
                                overlayShape: RoundSliderOverlayShape(
                                  overlayRadius: 16,
                                ),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: _volumeLevel,
                                min: 0.0,
                                max: 1.0,
                                divisions: 20,
                                onChanged: (double value) {
                                  setState(() {
                                    _volumeLevel = value;
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '0%',
                                  style: TextStyle(
                                      color: Colors.grey[400], fontSize: 12),
                                ),
                                Text(
                                  '${(_volumeLevel * 100).round()}%',
                                  style: TextStyle(
                                    color: Color(0xFF6C63FF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '100%',
                                  style: TextStyle(
                                      color: Colors.grey[400], fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C63FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _volumeLevel == 0
                                ? Icons.volume_off
                                : _volumeLevel < 0.5
                                    ? Icons.volume_down
                                    : Icons.volume_up,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Audio Quality
                    _buildSettingCard(
                      child: ListTile(
                        title: Text(
                          'Audio Quality',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              _getQualityLabel(_audioQuality),
                              style: TextStyle(
                                  color: Color(0xFF6C63FF), fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Color(0xFF6C63FF),
                                inactiveTrackColor: Colors.grey[700],
                                thumbColor: Color(0xFF6C63FF),
                                thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 8,
                                ),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: _audioQuality,
                                min: 0.0,
                                max: 1.0,
                                divisions: 2,
                                onChanged: (double value) {
                                  setState(() {
                                    _audioQuality = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C63FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.high_quality,
                              color: Color(0xFF6C63FF)),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Download Settings
                    _buildSectionHeader('Download Settings', Icons.download),
                    SizedBox(height: 16),

                    _buildSettingCard(
                      child: SwitchListTile(
                        title: Text(
                          'Download on Wi-Fi only',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        subtitle: Text(
                          'Save mobile data when downloading music',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        secondary: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C63FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.wifi, color: Color(0xFF6C63FF)),
                        ),
                        value: _downloadOnWifiOnly,
                        activeColor: Color(0xFF6C63FF),
                        onChanged: (bool value) {
                          setState(() {
                            _downloadOnWifiOnly = value;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 30),

                    // Account Section
                    _buildSectionHeader('Account', Icons.person_outline),
                    SizedBox(height: 16),

                    // View Profile
                    _buildSettingCard(
                      child: ListTile(
                        title: Text(
                          'View Profile',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        subtitle: Text(
                          'Manage your profile and preferences',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C63FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.person, color: Color(0xFF6C63FF)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Colors.grey[400], size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 12),

                    // Storage Management
                    _buildSettingCard(
                      child: ListTile(
                        title: Text(
                          'Storage Management',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        subtitle: Text(
                          'Manage downloaded music and cache',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C63FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.storage, color: Color(0xFF6C63FF)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Colors.grey[400], size: 16),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Storage management coming soon'),
                              backgroundColor: Color(0xFF6C63FF),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 30),

                    // Danger Zone
                    _buildSectionHeader(
                        'Account Actions', Icons.warning_outlined),
                    SizedBox(height: 16),

                    // Log Out Button
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E2D),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Sign out of your account',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.logout, color: Colors.red),
                        ),
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF6C63FF), size: 24),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E1E2D),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  String _getQualityLabel(double quality) {
    if (quality <= 0.33) return 'Low Quality (128 kbps)';
    if (quality <= 0.66) return 'Standard Quality (256 kbps)';
    return 'High Quality (320 kbps)';
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E1E2D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Sign Out', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          'Are you sure you want to sign out of your account?',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(onTap: () {}),
                ),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully signed out'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
