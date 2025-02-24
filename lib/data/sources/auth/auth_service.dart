/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-15 10:16:59
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/data/models/auth/create_user_req.dart';
import 'package:cinema_booking/data/models/auth/edit_user_req.dart';
import 'package:cinema_booking/data/models/auth/signin_user_req.dart';
import 'package:cinema_booking/data/models/auth/user.dart';
import 'package:cinema_booking/domain/entities/auth/user.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  Future<Either<String, String>> signup(CreateUserReq createUserReq);
  Future<Either<String, String>> signin(SigninUserReq signinUserReq);
  Future<Either<String, String>> signOut();
  Future<Either<String, UserEntity>> getUser();
  Future<Either<String, String>> editUserInfo(EditUserReq edit);
  Future<Either<String, String>> signInWithGoogle();
  Future<bool> isSignedIn();
}

class AuthServiceImpl extends AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthServiceImpl({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<Either<String, String>> signin(SigninUserReq signinUserReq) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: signinUserReq.email,
        password: signinUserReq.password,
      );
      return const Right('Signin was Successful');
    } catch (e) {
      return Left('Error signing in');
    }
  }

  @override
  Future<Either<String, String>> signup(CreateUserReq createUserReq) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: createUserReq.email!,
            password: createUserReq.password,
          );

      String uid = userCredential.user!.uid;

      // Save user data to Firestore
      await firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': createUserReq.email,
        'fullName': createUserReq.fullName,
        'age': createUserReq.age,
        'gender': createUserReq.gender,
        'createdAt':
            FieldValue.serverTimestamp(), // Store account creation timestamp
      });

      return const Right('Signup was Successful');
    } catch (e) {
      return Left('Error signing up');
    }
  }

  @override
  Future<Either<String, String>> editUserInfo(EditUserReq edit) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && edit.email == user.email && edit.password != null) {
        await user.updatePassword(edit.password!);
      }

      String uid = user!.uid;

      // Save user data to Firestore
      await firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': edit.email,
        'fullName': edit.fullName,
        'age': edit.age,
        'gender': edit.gender,
        'createdAt':
            FieldValue.serverTimestamp(), // Store account creation timestamp
      });

      return const Right('Update was Successful');
    } catch (e) {
      return Left('Update Fails');
    }
  }

  @override
  Future<Either<String, String>> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
      return const Right('Signout was successful');
    } catch (e) {
      return Left('Error signing out');
    }
  }

  @override
  Future<Either<String, UserEntity>> getUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          UserModel userModel = UserModel.fromJson(
            userDoc.data() as Map<String, dynamic>,
          );
          LogHelper.debug(
            tag: "AuthService",
            message: 'userDoc data: ${userDoc.data().toString()}',
          );

          LogHelper.debug(
            tag: "AuthService",
            message: 'userModel data: ${userModel.toString()}',
          );
          return Right(userModel.toEntity()); // Return user model
        } else {
          return Left('User data not found in Firestore');
        }
      } else {
        return Left('No user is currently signed in');
      }
    } catch (e) {
      return Left('Error retrieving user data: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return Left('Google sign-in cancelled');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      return const Right('Google sign-in was successful');
    } catch (e) {
      return Left('Error signing in with Google');
    }
  }

  @override
  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }
}
