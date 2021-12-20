import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_attendance/admin/register.dart';
import 'package:student_attendance/auth/auth_provider.dart';
import 'package:student_attendance/auth/login.dart';
import 'package:student_attendance/components/progress.dart';
import 'package:student_attendance/components/rounded_button.dart';
import 'package:student_attendance/constants.dart';
import 'package:student_attendance/pages/students_data.dart';
import 'package:student_attendance/teacher/teacher_data.dart';


class AdminHome extends StatelessWidget {
  static const String id = 'admin_home';
  final currentAdminId;
  const AdminHome({Key? key, this.currentAdminId}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentAdminId != '' ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  _showText(),
                  const SizedBox(height: 80.0,),
                  _showImage(context),
                  const SizedBox(height: 80.0,),
                  _showStudentsData(context),
                  _showTeacherData(context),
                  // _showAddStudent(context),
                  _showLogout(context),

                ],
              ),
            ),
          ),
        ) : Center(
          child: circularProgress(),
        )
    );
  }

  Widget _showText(){
    return const Text('Dashboard', style: TextStyle(fontSize: 34, color: kColor, fontWeight: FontWeight.bold),);
  }
  _showImage(context){
    return GestureDetector(
      child: SvgPicture.asset('assets/admin_img.svg'),
      onLongPress: () => _signOut(context),
    );
  }

  Widget _showStudentsData(context){
    return RoundedButton(
        title: 'بيانات الطلاب',
        colour: gColor,
        onPressed: (){
          Navigator.of(context).pushNamed(StudentsData.id);
        },
        heightSize: 0,
        widthSize: 0,
       );
  }

  Widget _showTeacherData(context){
    return RoundedButton(
      title: 'بيانات الاساتذة',
      colour: gColor,
      onPressed: (){
        Navigator.of(context).pushNamed(TeacherData.id);
      },
      heightSize: 0,
      widthSize: 0,
    );
  }

  Widget _showAddStudent(context){
    return RoundedButton(
      title: 'اضافة طالب',
      colour: kColor,
      onPressed: (){
        Navigator.of(context).pushNamed(Register.id);
      },
      heightSize: 0,
      widthSize: 0,
    );
  }

  Widget _showLogout(context){
    return RoundedButton(
      title: 'تسجيل الخروج',
      colour: oColor,
      onPressed: () => _signOut(context),
      heightSize: 0,
      widthSize: 0,
    );
  }

  void _signOut(BuildContext context) async {
    try{
      var auth = AuthProvider.of(context)!.auth;
      await auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login()),
              (Route<dynamic> route) => false);
    } catch(e){
      print('Error: $e');
    }
  }

}
