import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_portal_app/resources/file_storage.dart';
import 'package:job_portal_app/models/job_publisher.dart' as model;

class Auth {
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 final FirebaseAuth _auth = FirebaseAuth.instance;

  // Signing Up User

  Future<String> signUpUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String companyDesc,
    required String companyName,
    required Uint8List file,
  }) async {
    try {
      // registering user in auth with email and password
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String photoUrl =
          await FileStorage().uploadImageToStorage('companyLogo', file);

      model.JobPublisher jobPublisher = model.JobPublisher(
        uid: cred.user!.uid,
        companyLogo: photoUrl,
        email: email,
        companyDesc: companyDesc,
        companyName: companyName,
        jobs: [],
      );

      // adding user in database
      await _firestore
          .collection("jobPublisher")
          .doc(cred.user!.uid)
          .set(jobPublisher.toJson());

      return "success";
    } on FirebaseAuthException catch (err) {
      String errorMessage = "An error occurred during sign-up";

      switch (err.code) {
        case "email-already-in-use":
          errorMessage =
              "The provided email is already registered. Please use a different email.";
          break;
        case "weak-password":
          errorMessage =
              "The password is too weak. Please use a stronger password.";
          break;
      }
      
      return errorMessage;
    } catch (e) {
      return "An unexpected error occurred during sign-up";
    }
  }

// logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (err) {
      return err.toString();
    }
    return res;
  }

  //sign out a user
  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  //get jobPublisher details
  Future<model.JobPublisher> getJobPublisherDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('jobPublisher').doc(currentUser.uid).get();

    return model.JobPublisher.fromSnap(documentSnapshot);
  }
}
