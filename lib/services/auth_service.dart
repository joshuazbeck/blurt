import 'dart:ffi';

import 'package:blurt/services/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class FullUser {
  String? uid;
  String? email;
  String? username;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? birthDate;
}

enum AuthenticationState {
  unauthenticated,
  authenticated,
  loading,
  missingInfo
}

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<User?> registerNewUser(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {
      //Save the user login
      Shared.saveLogin(email, password);
    }
    return user;
  }

  Future<FullUser?> getFullUser(User user) async {
    FirebaseFirestore _instance = FirebaseFirestore.instance;
    DocumentReference _userRef =
        _instance.collection("users").doc(user.uid.toString());
    FullUser fullUser = FullUser();

    DocumentSnapshot doc = await _userRef.get();
    if (doc.data() == null) return null;
    final data = doc.data() as Map<String, dynamic>;
    if (doc.exists) {
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

  void addFullUser(User user, String username, String firstName,
      String lastName, String phoneNumber, String birthDate) {
    var _userArr = <String, String>{
      "uid": user.uid,
      "email": user.email ?? "",
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "birthDate": birthDate,
    };

    FirebaseFirestore doc = FirebaseFirestore.instance;
    doc.collection("users").doc(user.uid.toString()).set(_userArr);
  }

  Future<FullUser?> getAuthenticatedUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      return getFullUser(currentUser);
    } else {
      return null;
    }
  }

  Future signOut() {
    FirebaseAuth auth = FirebaseAuth.instance;
    Shared.signOut();

    return auth.signOut();
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
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
