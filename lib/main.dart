import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:leave_application/Pages/HomePage.dart';
import 'package:leave_application/Pages/loginpage.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.hasData){

              return HomePage();
            }
            else{
              return LoginPage();
            }
          },
        ),
      ),
    );


  }

}


