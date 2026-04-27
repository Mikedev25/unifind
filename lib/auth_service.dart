import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges(); // to know if the user is logged in or not

  //Sign in function
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  //Sign up function
  Future<UserCredential> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    
    // Update user profile with username
    await userCredential.user?.updateDisplayName(username);
    
    // Send email verification
    await sendEmailVerification();
    
    return userCredential;
  }

  //Send email verification
  Future<void> sendEmailVerification() async {
    if (currentUser != null && !currentUser!.emailVerified) {
      await currentUser!.sendEmailVerification();
    }
  }

  //Check if email is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  //Log out function
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  //Forgot password
  Future<void> forgotPassword({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  //Change password function
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = 
        EmailAuthProvider.credential(email: email, password: currentPassword);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }

  //Update username function
  Future<void> updateUsername({
    required String username,
  }) async {
    await currentUser!.updateDisplayName(username);
  }

  //Delete account function
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = 
        EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }
}