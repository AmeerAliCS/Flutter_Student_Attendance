import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_attendance/auth/login.dart';


abstract class BaseAuth{
  Stream<String> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword (String _email, String _password);
  Future<String> createUserWithEmailAndPassword (String _email, String _password);
  Future<String> currentUser();
  Future<void> signOut();
  late String displayName;
  late String studentDepartment;
  late String studentStage;

}

class Auth implements BaseAuth {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DateTime timestamp = DateTime.now();
  late String name;
  late String department;
  late String stage;

  @override
  set displayName(String _displayName) {
    name = _displayName;
  }

  @override
  String get displayName => name;

  @override
  set studentDepartment(String _studentDepartment) {
    department = _studentDepartment;
  }

  @override
  String get studentDepartment => department;

  @override
  set studentStage(String _studentStage) {
    stage = _studentStage;
  }

  @override
  String get studentStage => stage;



  createUserInFirestoreByEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await usersRef.doc(user.uid).get();

    if (!doc.exists) {
      usersRef.doc(user.uid).set({
        'userId': user.uid,
        'displayName': displayName,
        'email': user.email,
        'department' : department,
        'stage' : stage,
        'timestamp': timestamp,
        'role': 'student'
      });
    }

  }

  @override
  Stream<String> get onAuthStateChanged{
    return firebaseAuth.authStateChanges().map((user) => user!.uid);
  }

  @override
  Future<String> signInWithEmailAndPassword (String _email, String _password) async {
    final user = await firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);
    return '$user';
  }

  @override
  Future<String> createUserWithEmailAndPassword (String _email, String _password) async {
    final user = await firebaseAuth.createUserWithEmailAndPassword(email: _email, password: _password);
    await createUserInFirestoreByEmail();
    return '$user';
  }

  @override
  Future<String> currentUser () async {
    User user = firebaseAuth.currentUser!;
    return user.uid;
  }

  @override
  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

}