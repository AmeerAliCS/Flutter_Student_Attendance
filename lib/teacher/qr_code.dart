import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:student_attendance/constants.dart';
import 'package:intl/intl.dart';



class QRCode extends StatelessWidget {
  static const String id = 'qr_code';
  QRCode({Key? key, this.currentTeacherId}) : super(key: key);

  final currentTeacherId;

  @override
  Widget build(BuildContext context) {
    var map = <String, dynamic>{};
    FirebaseFirestore.instance.collection(currentTeacherId == 'kBTt80oEC7Tug6rN75t3b8rpu1v2' ? 'teacher1': 'teacher2').doc(getFormattedDate(DateTime.now().toString())).set({
      'attendance': FieldValue.arrayUnion([
        map['Students'] =  {
          'Name': '',
          'email': '',
          'department': '',
          'stage': '',
          'timestamp': '',
          'materials': ''
        }
      ])
    },SetOptions(merge: true));


    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          QrImage(
            data: getFormattedDate(DateTime.now().toString()),
            version: QrVersions.auto,
            size: 200.0,
            foregroundColor: gColor,
          ),
          const SizedBox(height: 20.0,),
          const Center(child: Text('شارك هذا الرمز مع الطلاب', style: TextStyle(fontSize: 22, color: kColor),)),
        ],
      ),
    );
  }

  String getFormattedDate(String date) {
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());
    var outputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }

}

