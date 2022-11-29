



import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leave_application/Pages/sidemenu.dart';
import 'package:leave_application/Widgets.dart';



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:sidebarx/sidebarx.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student>student=[Student(name: "", id: "", serviceId: "")];
  String? id = FirebaseAuth.instance.currentUser?.email;
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = Map();
  int button = 0;

  String? tempFileUri; //reference to the file currently being transferred
  Map<int, String> map =
  Map();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      drawer: SideBar(),
      appBar: AppBar(
        backgroundColor: Colors.black,

        actions: [
          IconButton(
            icon: Icon(Icons.gps_fixed),
            onPressed:() async {
              if (await Nearby().askLocationPermission()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Location Permission granted :)")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                    Text("Location permissions not granted :(")));
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: (){
              Nearby().askBluetoothPermission();
        },
          ),
          IconButton(
            icon: Icon(Icons.pin_drop),
            onPressed: ()async{
              if (await Nearby().enableLocationServices()) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Location Service Enabled :)")));
              } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
              Text("Enabling Location Service Failed :(")));
              }
            },
          )
        ],
        ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: SizedBox()),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(40),
                      primary: button==0?Colors.green:Colors.red
                  ),
                  child: Icon(button==0?Icons.waving_hand:Icons.front_hand, size: 70,),
                  onPressed: () async {
                    if(button==0){
                      try {
                        bool a = await Nearby().startDiscovery(
                          id!,
                          strategy,
                          onEndpointFound: (id, name, serviceId) {
                            setState((){student.add(Student(name: name, id: id, serviceId: serviceId));});
                            // show sheet automatically to request connection
                          },
                          onEndpointLost: (id) {
                            showSnackbar(
                                "Lost discovered Endpoint: ${endpointMap[id]!.endpointName}, id $id");
                          },
                        );
                        showSnackbar("DISCOVERING: " + a.toString());
                      } catch (e) {
                        showSnackbar(e);
                      }
                      setState((){button = 1;});
                    }
                    else if(button == 1){
                      await Nearby().stopDiscovery();
                      setState((){button = 0;});
                    }
                  },
                ),
                Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              height: MediaQuery.of(context).size.height-252
              ,
              child: student.length==1?Center(child: Text("Start Marking to show List of Students",style: TextStyle(color: Colors.white),)):ListView(
                scrollDirection: Axis.vertical,
                children:[
                  for(var i=1; i<student.length;i++)...[
                    StudentTile(student: student[i])
                  ]
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  void onMarked (String id, ConnectionInfo info)async{
    await Nearby().rejectConnection(id);
  }

}

class Student{
  String name;
  String id;
  String serviceId;
  Student({
    required this.name, required this.id, required this.serviceId
});
}