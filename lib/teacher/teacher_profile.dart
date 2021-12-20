import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_attendance/auth/auth_provider.dart';
import 'package:student_attendance/auth/login.dart';
import 'package:student_attendance/components/progress.dart';
import 'package:student_attendance/components/rounded_button.dart';
import 'package:student_attendance/constants.dart';
import 'package:student_attendance/teacher/qr_code.dart';
import 'package:student_attendance/teacher/students_attendance.dart';

class TeacherProfile extends StatelessWidget {
  final currentTeacherId;
  const TeacherProfile({Key? key, this.currentTeacherId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentTeacherId != '' ? Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                _showText(),
                const SizedBox(height: 40.0),
                _showImage(context),
                const SizedBox(height: 15.0),
                // _showTeacherName(),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
                    var userData=snapshot.data;
                    return snapshot.hasData?Container(
                      padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                                Text(userData!.get('displayName')),
                                const SizedBox(height: 20.0,),
                                _showQrCode(context, userData.id),
                                _showStudentAattendance(context),
                                _showLogout(context),
                            ],
                          )
                        ),
                      ),
                    ):Center(
                      child: circularProgress(),
                    );
                  },
                ),

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
    return const Text('Teacher Profile', style: TextStyle(fontSize: 34, color: kColor, fontWeight: FontWeight.bold),);
  }

  _showImage(context){
    return GestureDetector(
        child: SvgPicture.asset('assets/teacher_profile_img.svg'),
        onLongPress: () => _signOut(context),
    );
  }

  Widget _showQrCode(context, currentTeacherId){
    return RoundedButton(
      title: 'QR Code',
      colour: kColor,
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => QRCode(currentTeacherId: currentTeacherId,)));
      },
      heightSize: 0,
      widthSize: 0,
    );
  }

  Widget _showStudentAattendance(context){
    return RoundedButton(
      title: 'حضور الطلاب',
      colour: gColor,
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => StudentsAttendance(currentTeacherId: currentTeacherId)));
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
    // ignore: empty_catches
    } catch(e){

    }
  }
  }

