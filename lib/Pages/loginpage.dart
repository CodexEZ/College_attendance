import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leave_application/Pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void dispose(){
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100,),
              Container(
                height: 50,
                child: AnimatedTextKit(
                    animatedTexts:[
                      TyperAnimatedText(
                        "HELLO!",
                        textStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.white, fontSize: 30)),
                        speed: const Duration(milliseconds: 200)
                    ),
                      TyperAnimatedText(
                          "HOLA",
                          textStyle: GoogleFonts.sacramento(textStyle: const TextStyle(color: Colors.white, fontSize: 30)),
                          speed: const Duration(milliseconds: 200)
                      )
          ],
                  totalRepeatCount:2,
                  pause: const Duration(milliseconds: 100),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: false,
                ),
              ),
              const SizedBox(height: 100,),
              Text(
                "LOGIN",
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
                  child:  Padding(
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
                    signIn();
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
                    "New here?",
                    style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white,fontSize: 16)),
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUp()),
                        );
                      },
                      child: Text(
                        "Sign Up",
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
  Future signIn() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=>Center(child: CircularProgressIndicator(),)
    );
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
    Navigator.pop(context);
  }
}
// Text("HELLO! THERE",style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white,fontSize: 30)))