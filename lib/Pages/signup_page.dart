import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leave_application/Pages/loginpage.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rollController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100,),
              Text(
                "Sign Up",
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 30,
                    )
                ),
              ),
              const SizedBox(height:50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "University Roll No."
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height:25,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child:  Padding(
                    padding: EdgeInsets.all(4),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "Email"
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height:25,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          hintText: "Password"
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25,),
              CircleAvatar(
                backgroundColor: Colors.cyan,
                radius: 25,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: (){
                    signUp();
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Signed Up?",
                    style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white,fontSize: 16)),
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Log in.",
                        style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.cyan,fontSize: 16)),
                      )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future signUp() async{
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context)=>Center(child: CircularProgressIndicator(),)
      );
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
      User? user = result.user;
      if (user != null) {
        //add display name for just created user
        user.updateDisplayName(rollController.text);
        //get updated user
        await user.reload();
        user = await FirebaseAuth.instance.currentUser;
        //print final version to console
        print("Registered user:");
        print(user);
      }
      Navigator.pop(context);
    } on Exception catch (e) {
      print(e);
    }
  }
}
