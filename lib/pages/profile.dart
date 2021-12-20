import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/auth/auth_provider.dart';
import 'package:student_attendance/auth/login.dart';
import 'package:student_attendance/components/progress.dart';
import 'package:student_attendance/components/rounded_button.dart';
import 'package:student_attendance/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_attendance/pages/materials.dart';

class Profile extends StatefulWidget {
  static const String id = 'profile';

  const Profile({Key? key, required this.currentUserId}) : super(key: key);

  final currentUserId;


  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool isLoading = false;
  String email = '';


  @override
  Widget build(BuildContext context) => Scaffold(

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
          var userData=snapshot.data;
          return snapshot.hasData?Container(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15.0,),
                    _showText(),
                     const SizedBox(height: 20.0,),
                    _showImage(),
                    const SizedBox(height: 15.0,),
                    _showStudentDetails(userData),
                    _showQrImg(
                      name: userData!.get('displayName'),
                      email: userData.get('email'),
                      department: userData.get('department'),
                      stage: userData.get('stage'),
                      timestamp: userData.get('timestamp')
                    ),
                    const SizedBox(height: 15.0,),
                    _showLogout(context),
                    // _showVacImg(userData),
                  ],
                ),
              ),
            ),
          ):Center(
            child: circularProgress(),
          );

        },

      ));

  Widget _showText(){
    return const Text('Student Profile', style: TextStyle(fontSize: 34, color: kColor, fontWeight: FontWeight.bold),);
  }

  Widget _showImage() {
    return GestureDetector(
      onLongPress: () =>_signOut(context),
      child: Align(
          alignment: Alignment.topCenter,
          child: SvgPicture.asset('assets/profile_img.svg', height: 270.0,)),
    );
  }

  Widget _showStudentDetails(userData) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Directionality(textDirection: TextDirection.rtl,
              child: Text(userData.get('displayName') ?? '', style: const TextStyle(fontSize: 22, color: kColor, fontWeight: FontWeight.bold),)),
          const Text(" :الاسم", style: TextStyle(fontSize: 22, color: kColor, fontWeight: FontWeight.bold)),
        ],),
      //
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Directionality(textDirection: TextDirection.rtl,
              child: Text(userData.get("department") ?? '', style: const TextStyle(fontSize: 22, color: kColor, fontWeight: FontWeight.bold),)),
          const Text(" :القسم", style: TextStyle(fontSize: 22, color: kColor, fontWeight: FontWeight.bold)),
        ],),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Directionality(textDirection: TextDirection.rtl,
              child: Text(userData.get("stage") ?? '', style: const TextStyle(fontSize: 22, color: kColor, fontWeight: FontWeight.bold),)),
          const Text(" :المرحلة", style: TextStyle(fontSize: 22, color: kColor, fontWeight: FontWeight.bold)),
        ],),

    ],);
  }

  Widget _showQrImg({name, email, stage, department, timestamp}){
    return GestureDetector(
      child: SvgPicture.asset('assets/qr_logo.svg'),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Materials(studentName: name, email: email, stage: stage, department: department, timestamp: timestamp)));
        // Navigator.push(context, MaterialPageRoute(builder: (context) => QrScanner(studentName: name, email: email, stage: stage, department: department, timestamp: timestamp)));
      },
    );
  }

  Widget _showLogout(context){
    return RoundedButton(
      title: 'تسجيل الخروج',
      colour: oColor,
      onPressed: () => _signOut(context),
      heightSize: 60.0,
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

