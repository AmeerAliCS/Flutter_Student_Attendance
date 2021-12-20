import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/admin/register.dart';
import 'package:student_attendance/auth/auth.dart';
import 'package:student_attendance/auth/auth_provider.dart';
import 'package:student_attendance/auth/root_page.dart';
import 'package:student_attendance/services/route_generator.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AuthProvider(
    auth: Auth(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: const Color(0xFF495464)
      ),
      home: const RootPage(),
      onGenerateRoute: RouteGenerator.generateRoute,
    ),
  ));
}

//void main() => runApp(
//  DevicePreview(
//    enabled: !kReleaseMode,
//    builder: (context) => HomePage()
//  ),
//);