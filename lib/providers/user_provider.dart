// import 'package:flutter/material.dart';

// class UserProvider with ChangeNotifier {
//   UserModel? _user;

//   UserModel? get user => _user;

//   void login(String username, String email) {
//     _user = UserModel(username: username, email: email);
//     notifyListeners();
//   }

//   void logout() {
//     _user = null;
//     notifyListeners();
//   }
// }

// //usermodel class

// class UserModel {
//   final String username;
//   final String email;

//   UserModel({required this.username, required this.email});
// }

// import 'package:flutter/material.dart';

// class UserProvider with ChangeNotifier {
//   String? _username;
//   String? _email;

//   String? get username => _username;
//   String? get email => _email;

//   void login(String username, String email) {
//     _username = username;
//     _email = email;
//     notifyListeners();
//   }

//   void logout() {
//     _username = null;
//     _email = null;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = "";
  String _email = "";
  String _avatarUrl = ""; // can be file path or network URL
  List<String> _favoriteGenres = [];

  // Getters
  String get username => _username;
  String get email => _email;
  String get avatarUrl => _avatarUrl.isNotEmpty
      ? _avatarUrl
      : "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";
  List<String> get favoriteGenres => _favoriteGenres;

  // Login or SignUp
  void login(String username, String email) {
    _username = username;
    _email = email;
    notifyListeners();
  }

  // Update profile
  void updateProfile({
    String? username,
    String? email,
    String? avatarUrl,
    List<String>? genres,
  }) {
    if (username != null) _username = username;
    if (email != null) _email = email;
    if (avatarUrl != null) _avatarUrl = avatarUrl;
    if (genres != null) _favoriteGenres = genres;
    notifyListeners();
  }

  // Logout
  void logout() {
    _username = "";
    _email = "";
    _avatarUrl = "";
    _favoriteGenres = [];
    notifyListeners();
  }
}
