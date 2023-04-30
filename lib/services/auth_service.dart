import 'dart:ffi';

import 'package:blurt/services/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class FullUser {
  String? uid;
  String? email;
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
    if (doc.exists) {
      fullUser.uid = doc.get('uid');
      fullUser.email = doc.get('email');
      fullUser.firstName = doc.get('firstName');
      fullUser.lastName = doc.get('lastName');
      fullUser.phoneNumber = doc.get('phoneNumber');
      fullUser.birthDate = doc.get('birthDate');
      return fullUser;
    } else {
      return null;
    }
  }

  void addFullUser(User user, String firstName, String lastName,
      String phoneNumber, String birthDate) {
    var _userArr = <String, String>{
      "uid": user.uid,
      "email": user.email ?? "",
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "birthDate": birthDate,
    };

    FirebaseFirestore doc = FirebaseFirestore.instance;
    doc.collection("users").doc(user.uid.toString()).set(_userArr);
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
