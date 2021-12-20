import 'package:flutter/material.dart';
import 'package:student_attendance/admin/admin_home.dart';
import 'package:student_attendance/admin/register.dart';
import 'package:student_attendance/auth/login.dart';
import 'package:student_attendance/auth/root_page.dart';
import 'package:student_attendance/pages/profile.dart';
import 'package:student_attendance/pages/students_data.dart';
import 'package:student_attendance/teacher/qr_code.dart';
import 'package:student_attendance/teacher/students_attendance.dart';
import 'package:student_attendance/teacher/teacher_data.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {

      case RootPage.id:
        return MaterialPageRoute(builder: (_) => const RootPage());
        break;

      case Login.id:
        return MaterialPageRoute(builder: (_) => const Login());
        break;

      case Profile.id:
        return MaterialPageRoute(builder: (_) => Profile(currentUserId: args,));
        break;

      case AdminHome.id:
        return MaterialPageRoute(builder: (_) => const AdminHome());
        break;

      case StudentsData.id:
        return MaterialPageRoute(builder: (_) => const StudentsData());
        break;

      case TeacherData.id:
        return MaterialPageRoute(builder: (_) => const TeacherData());
        break;

      case QRCode.id:
        return MaterialPageRoute(builder: (_) => QRCode());
        break;

      case StudentsAttendance.id:
        return MaterialPageRoute(builder: (_) => const StudentsAttendance());
        break;

      case Register.id:
        return MaterialPageRoute(builder: (_) => const Register());
        break;

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}