import 'dart:ffi';

import 'package:blurt/controllers/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../model/items/friend.dart';

/// Create a service to handle authentication actions
class AuthService {
  /// Register a new user to Google Firebase
  Future<User?> registerNewUser(String email, String password) async {
    // Create an instance of the authentication
    FirebaseAuth auth = FirebaseAuth.instance;

    // Create a user credential with the email and password
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Get a user after signing in
    User? user = userCredential.user;

    if (user != null) {
      //Save the user login
      Shared.saveLogin(email, password);
    }
    return user;
  }

  /// Get the full user
  Future<FullUser?> getFullUser(User user) async {
    // Create an instance of firebase firestore
    FirebaseFirestore instance = FirebaseFirestore.instance;

    // Create a reference to the user
    DocumentReference userRef =
        instance.collection("users").doc(user.uid.toString());
    FullUser fullUser = FullUser();

    // Get the user
    DocumentSnapshot doc = await userRef.get();
    if (doc.data() == null) return null;
    final data = doc.data() as Map<String, dynamic>;

    // If the user full information exists
    if (doc.exists) {
      // Set the values
      if (data.containsKey('uid')) {
        fullUser.uid = data['uid'];
      }
      if (data.containsKey('email')) {
        fullUser.email = data['email'];
      }
      if (data.containsKey('firstName')) {
        fullUser.firstName = data['firstName'];
      }
      if (data.containsKey('lastName')) {
        fullUser.lastName = data['lastName'];
      }
      if (data.containsKey('phoneNumber')) {
        fullUser.phoneNumber = data['phoneNumber'];
      }
      if (data.containsKey('birthDate')) {
        fullUser.birthDate = data['birthDate'];
      }

      if (data.containsKey('username')) {
        fullUser.username = data['username'];
      }
      return fullUser;
    } else {
      return null;
    }
  }

  /// Add additional personal information to an existing user
  void addFullUser(User user, String username, String firstName,
      String lastName, String phoneNumber, String birthDate) {
    // Create a user object to write to firebase
    var _userArr = <String, String>{
      "uid": user.uid,
      "email": user.email ?? "",
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "birthDate": birthDate,
    };

    // Create a instance of the user in the database
    FirebaseFirestore doc = FirebaseFirestore.instance;
    doc.collection("users").doc(user.uid.toString()).set(_userArr);
  }

  /// Get the current authenticated full user
  Future<FullUser?> getAuthenticatedUser() async {
    //Create an instance of the firebase authentication
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      // Get the full user if it exists
      return getFullUser(currentUser);
    } else {
      return null;
    }
  }

  /// Sign out the authenticated user
  Future signOut() {
    // Sign out the user
    FirebaseAuth auth = FirebaseAuth.instance;
    Shared.signOut();

    return auth.signOut();
  }

  /// Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    //Create an instance of the firebase authentication
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      //Sign in the user with email and password
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for email: $email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for email: $email.');
      }
      return null;
    }
  }
}
