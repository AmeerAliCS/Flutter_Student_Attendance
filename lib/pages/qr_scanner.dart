import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key, this.studentName, this.email, this.stage, this.department, this.timestamp, this.material}) : super(key: key);

  final studentName;
  final email;
  final stage;
  final department;
  final timestamp;
  final material;

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isAttendance = false;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),

          Expanded(
            flex: 1,
            child: Center(
              child: isAttendance ? const Text('تم تسجيل حضورك بنجاح') : const Text('لتسجيل حضورك QR Code ضع الكاميرا على رمز ال')
            ),
          ),

        ],
      ),
    );
  }

  void addStudentAttendance(result) async{

    var map = <String, dynamic>{};
    var doc = await FirebaseFirestore.instance.collection(widget.material == 'english' ? 'teacher1' : 'teacher2').doc(result).get();
    if (doc.exists){
      await FirebaseFirestore.instance.collection(widget.material == 'english' ? 'teacher1' : 'teacher2').doc(result).set({
        'attendance': FieldValue.arrayUnion([
          map['Students'] =  {
            'name': widget.studentName,
            'email': widget.email,
            'department': widget.department,
            'stage': widget.stage,
            'timestamp': DateFormat.yMEd().add_j().format(DateTime.now()),
            'materials': widget.material
          }
        ])
      },SetOptions(merge: true)).then((_){
        setState(() {
          isAttendance = true;
        });
      });
    }

  }

  String getFormattedDate(String date, String key) {
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = key == 'collection' ? DateFormat('yyyy-MM-dd') : DateFormat('yyyy-MM-dd hh:mm');
    var inputDate = inputFormat.parse(localDate.toString());
    var outputFormat = key == 'collection' ? DateFormat('yyyy-MM-dd') : DateFormat('yyyy-MM-dd hh:mm');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }



  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      addStudentAttendance(scanData.code);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}
