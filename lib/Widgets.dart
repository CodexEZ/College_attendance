import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leave_application/Pages/HomePage.dart';
import 'package:nearby_connections/nearby_connections.dart';

class StudentTile extends StatefulWidget {
  Student student;
  StudentTile({required this.student});

  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  Color status = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white10
        ),
        child: Center(
          child: GestureDetector(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: Icon(Icons.check_circle_outline_sharp, color: status,size: 30,),
              ),
              title: Text(widget.student.name,
                style:GoogleFonts.roboto(textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                )) ,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
            onTap: () async{
               await FirebaseFirestore.instance.collection('std').doc().set({
                "attendance":widget.student.name,
                "check":true
              });
              await Nearby().requestConnection(
                "Teacher",
                widget.student.id,
                onConnectionInitiated: (id, info) async{
                  await Nearby().rejectConnection(id);
                },
                onConnectionResult: (id, status) {
                  showSnackbar(status);
                },
                onDisconnected: (id) {
                  // setState(() {
                  //   endpointMap.remove(id);
                  // });
                  // showSnackbar(
                  //     "Disconnected from: ${endpointMap[id]!.endpointName}, id $id");
                },
              );
              setState((){status=Colors.green;});
            },
          ),
        ),
      ),
    );
  }
  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }
}
