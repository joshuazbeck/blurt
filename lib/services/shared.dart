import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

class Shared {
  /// Get the shared storage
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  /// Save the login to shared defaults for future app launches
  static void saveLogin(String email, String password) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  /// Remove the login information to shared defaults
  static Future signOut() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('email');
    await prefs.remove('password');
  }

  /// Check if the user is logged in based off the stored shared preferences
  static Future<User?> isLoggedIn() async {
    final SharedPreferences prefs = await _prefs;
    String? email = await prefs.getString('email');
    String? password = await prefs.getString('password');

    if (email != null && password != null) {
      AuthService auth = AuthService();
      return auth.signInWithEmailAndPassword(email, password);
    } else {
      //No defaults for email and password
      return null;
    }
  }
}
