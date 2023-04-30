import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

class Shared {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static void saveLogin(String email, String password) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  static Future signOut() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('email');
    await prefs.remove('password');
  }

  static Future<User?> isLoggedIn() async {
    final SharedPreferences prefs = await _prefs;
    String? email = await prefs.getString('email');
    String? password = await prefs.getString('password');
    print("email $email ; password $password");

    if (email != null && password != null) {
      AuthService auth = AuthService();
      return auth.signInWithEmailAndPassword(email, password);
    } else {
      //No defaults for email and password
      return null;
    }
  }
}
