import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:student_attendance/constants.dart';
import 'dart:ui' as ui;

class StudentsAttendance extends StatefulWidget {
  static const String id = 'students_attendance';
  final currentTeacherId;

  const StudentsAttendance({Key? key, this.currentTeacherId}) : super(key: key);

  @override
  State<StudentsAttendance> createState() => _StudentsAttendanceState();
}


class _StudentsAttendanceState extends State<StudentsAttendance> {

  @override
  Widget build(BuildContext context) {
    var attendance = FirebaseFirestore.instance.collection((widget.currentTeacherId == 'kBTt80oEC7Tug6rN75t3b8rpu1v2') ? 'teacher1': (widget.currentTeacherId == 'SWfJLpsbFShN9EJEgsdLVMxQDzG2') ? 'teacher2': '');
    return Scaffold(
        backgroundColor: const Color(0xFFEAEAEA),
        body: StreamBuilder<QuerySnapshot>(
            stream: attendance.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var data = snapshot.data!.docs;
              return ListView(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: (){
                                      Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          title: 'هل تريد حذف هذا السجل',
                                          buttons: [
                                            DialogButton(
                                              child: const Text(
                                                "حذف",
                                                style:TextStyle(color: Colors.white, fontSize: 20),
                                              ),
                                              onPressed: () {
                                                FirebaseFirestore.instance.collection((widget.currentTeacherId == 'kBTt80oEC7Tug6rN75t3b8rpu1v2') ? 'teacher1': (widget.currentTeacherId == 'SWfJLpsbFShN9EJEgsdLVMxQDzG2') ? 'teacher2': '')
                                                    .doc(data[index].id).delete();
                                                Navigator.pop(context);
                                              },
                                              width: 120,
                                            )
                                          ]
                                      ).show();
                                      return null;
                                    },
                                    icon: Icon(Icons.delete, color: oColor, size: 32.0,)
                                ),


                                Text(getFormattedDate(data[index].id) , style: const TextStyle(
                                        fontSize: 24, color: kColor),
                                    ),
                              ],
                            ),
                            // const SizedBox(height: 10.0),
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection(widget.currentTeacherId == 'kBTt80oEC7Tug6rN75t3b8rpu1v2' ? 'teacher1': 'teacher2').doc(data[index].id).get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Something went wrong");
                                }

                                if (snapshot.hasData &&
                                    !snapshot.data!.exists) {
                                  return const Text("Document does not exist");
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: data["attendance"].length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 7.0, vertical: 2.0),
                                          child: data["attendance"][index]
                                          ["email"] != '' ? Card(
                                            elevation: 2,
                                            child: ListTile(
                                              trailing: const CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 22.0,
                                                backgroundImage: AssetImage(
                                                    'assets/student_img.png'),
                                              ),
                                              title: Directionality(
                                                textDirection: ui.TextDirection.rtl,
                                                child: Text(
                                                    data["attendance"][index]
                                                    ["name"],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: kColor),
                                                    ),
                                              ),
                                              subtitle: Directionality(child: Text(data["attendance"][index]['timestamp']),textDirection: ui.TextDirection.rtl),
                                            ),
                                          ) : const Text('')
                                        );
                                      });
                                }

                                return const Text("loading");
                              },
                            ),
                            const SizedBox(height: 30.0),
                            Divider(height: 10.0, thickness: 1.0),
                          ],
                        );
                      }),
                ],
              );
            }));
  }

  String getFormattedDate(String date) {
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd hh:mm');
    var inputDate = inputFormat.parse(localDate.toString());
    var outputFormat = DateFormat('yyyy-MM-dd hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }
}