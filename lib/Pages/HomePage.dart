import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            Expanded(child:SizedBox()),
            Text("${user.email}",style: TextStyle(color: Colors.white),),
            SizedBox(height: 10,),
            TextButton(
              child: Text("Sign Out", style: TextStyle(color: Colors.white),),
              onPressed: (){
                FirebaseAuth.instance.signOut();
              },
            ),
            Expanded(child:SizedBox()),
          ],
        ),
      ),
      );
  }
}
