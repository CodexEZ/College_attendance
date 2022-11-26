



import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leave_application/Pages/sidemenu.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
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
              // children: [
              //   Expanded(child: SizedBox()),
              //   CircleAvatar(
              //     backgroundColor: Colors.red,
              //     child: IconButton(
              //       icon: Icon(Icons.arrow_upward),
              //       onPressed: ()async {
              //         try {
              //           bool a = await Nearby().startAdvertising(
              //             id!,
              //             strategy,
              //             onConnectionInitiated: onConnectionInit,
              //             onConnectionResult: (id, status) {
              //               showSnackbar(status);
              //             },
              //             onDisconnected: (id) {
              //               showSnackbar(
              //                   "Disconnected: ${endpointMap[id]!.endpointName}, id $id");
              //               setState(() {
              //                 endpointMap.remove(id);
              //               });
              //             },
              //           );
              //           showSnackbar("ADVERTISING: " + a.toString());
              //         } catch (exception) {
              //           showSnackbar(exception);
              //         }
              //       },
              //     ),
              //   ),
              //   ElevatedButton(
              //       child: Text("Stop Advertising"),
              //       onPressed: () async {
              //         await Nearby().stopAdvertising();
              //       }
              //   ),
              //   Expanded(child: SizedBox())
              // ],
            ),
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
                            // show sheet automatically to request connection
                            showModalBottomSheet(
                              backgroundColor: Colors.blue[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                              ),
                              context: context,
                              builder: (builder) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Column(
                                      children: <Widget>[
                                        // Text("id: " + id),
                                        Text("Name: " + name, style: GoogleFonts.roboto(textStyle: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,

                                        )),),
                                        // Text("ServiceId: " + serviceId),
                                        SizedBox(height: 10,),
                                        ElevatedButton(
                                          child: Text("Mark Present"),
                                          onPressed: () {
                                            FirebaseFirestore.instance.collection('std').doc().set({
                                              "attendance":name,
                                              "check":true
                                            }
                                            );
                                            Navigator.pop(context);
                                            Nearby().requestConnection(
                                              "Teacher",
                                              id,
                                              onConnectionInitiated: (id, info) {
                                                onMarked(id, info);
                                              },
                                              onConnectionResult: (id, status) {
                                                showSnackbar(status);
                                              },
                                              onDisconnected: (id) {
                                                setState(() {
                                                  endpointMap.remove(id);
                                                });
                                                showSnackbar(
                                                    "Disconnected from: ${endpointMap[id]!.endpointName}, id $id");
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
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
                // Expanded(child: SizedBox()),
                // ElevatedButton(
                //   child: Text("Stop Discovery"),
                //   onPressed: () async {
                //     await Nearby().stopDiscovery();
                //   },
                // ),
                Expanded(child: SizedBox()),
              ],
            ),
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

  Future<bool> moveFile(String uri, String fileName) async {
    String parentDir = (await getExternalStorageDirectory())!.absolute.path;
    final b =
    await Nearby().copyFileAndDeleteOriginal(uri, '$parentDir/$fileName');

    showSnackbar("Moved file:" + b.toString());
    return b;
  }
  void onMarked (String id, ConnectionInfo info)async{
    await Nearby().rejectConnection(id);
  }
  void onConnectionInit(String id, ConnectionInfo info) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Center(
          child: Column(
            children: <Widget>[
              Text("id: " + id),
              Text("Token: " + info.authenticationToken),
              Text("Name" + info.endpointName),
              Text("Incoming: " + info.isIncomingConnection.toString()),
              ElevatedButton(
                child: Text("Accept Connection"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    endpointMap[id] = info;
                  });
                  Nearby().acceptConnection(
                    id,
                    onPayLoadRecieved: (endid, payload) async {
                      if (payload.type == PayloadType.BYTES) {
                        String str = String.fromCharCodes(payload.bytes!);
                        showSnackbar(endid + ": " + str);

                        if (str.contains(':')) {
                          // used for file payload as file payload is mapped as
                          // payloadId:filename
                          int payloadId = int.parse(str.split(':')[0]);
                          String fileName = (str.split(':')[1]);

                          if (map.containsKey(payloadId)) {
                            if (tempFileUri != null) {
                              moveFile(tempFileUri!, fileName);
                            } else {
                              showSnackbar("File doesn't exist");
                            }
                          } else {
                            //add to map if not already
                            map[payloadId] = fileName;
                          }
                        }
                      } else if (payload.type == PayloadType.FILE) {
                        showSnackbar(endid + ": File transfer started");
                        tempFileUri = payload.uri;
                      }
                    },
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                      if (payloadTransferUpdate.status ==
                          PayloadStatus.IN_PROGRESS) {
                        print(payloadTransferUpdate.bytesTransferred);
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.FAILURE) {
                        print("failed");
                        showSnackbar(endid + ": FAILED to transfer file");
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.SUCCESS) {
                        showSnackbar(
                            "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");

                        if (map.containsKey(payloadTransferUpdate.id)) {
                          //rename the file now
                          String name = map[payloadTransferUpdate.id]!;
                          moveFile(tempFileUri!, name);
                        } else {
                          //bytes not received till yet
                          map[payloadTransferUpdate.id] = "";
                        }
                      }
                    },
                  );
                },
              ),
              ElevatedButton(
                child: Text("Reject Connection"),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await Nearby().rejectConnection(id);
                  } catch (e) {
                    showSnackbar(e);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

}

