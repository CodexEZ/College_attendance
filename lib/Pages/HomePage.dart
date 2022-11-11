import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wifi_scan/wifi_scan.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;

  bool get isStreaming => subscription != null;

  Future<void> _startScan(BuildContext context) async {
    // check if "can" startScan
    if (shouldCheckCan) {
      // check if can-startScan
      final can = await WiFiScan.instance.canStartScan();
      // if can-not, then show error
      if (can != CanStartScan.yes) {
        if (mounted) kShowSnackBar(context, "Cannot start scan: $can");
        return;
      }
    }

    // call startScan API
    final result = await WiFiScan.instance.startScan();
    if (mounted) kShowSnackBar(context, "startScan: $result");
    // reset access points.
    setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      // check if can-getScannedResults
      final can = await WiFiScan.instance.canGetScannedResults();
      // if can-not, then show error
      if (can != CanGetScannedResults.yes) {
        if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  Future<void> _getScannedResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      // get scanned results
      final results = await WiFiScan.instance.getScannedResults();
      setState(() => accessPoints = results);
    }
  }

  Future<void> _startListeningToScanResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      subscription = WiFiScan.instance.onScannedResultsAvailable
          .listen((result) => setState(() => accessPoints = result));
    }
  }

  void _stopListeningToScanResults() {
    subscription?.cancel();
    setState(() => subscription = null);
  }

  @override
  void dispose() {
    super.dispose();
    // stop subscription for scanned results
    _stopListeningToScanResults();
  }

  // build toggle with label
  Widget _buildToggle({
    String? label,
    bool value = false,
    ValueChanged<bool>? onChanged,
    Color? activeColor,
  }) =>
      Row(
        children: [
          if (label != null) Text(label, style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),),
          Switch(value: value, onChanged: onChanged, activeColor: activeColor),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title:  Text(
          "Student List",
          style: GoogleFonts.lato(textStyle: TextStyle(
            color: Colors.white
          )),
        ),
        actions: [
          _buildToggle(
            label: "Scan Access",
            value: shouldCheckCan,
            onChanged: (v)=>setState(()=>shouldCheckCan=v),
            activeColor: Colors.green
          )
        ],
      ),
      body: Builder(
        builder: (context)=>Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:  MaterialStateProperty.all<Color>(Colors.white24)
                    ),
                    icon: Icon(Icons.wifi),
                    label: Text(
                      "SCAN",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.white
                        )
                      ),
                    ),
                    onPressed: () async=>_startScan(context),
                  ),
                  Expanded(child: SizedBox()),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:  MaterialStateProperty.all<Color>(Colors.white24)
                    ),
                    icon: Icon(Icons.refresh),
                    label: Text(
                      "Refresh",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white
                          )
                      ),
                    ),
                    onPressed: () async=>_getScannedResults(context),
                  ),
                  Expanded(child: SizedBox()),
                  _buildToggle(
                    label: "Allow scan",
                    value: isStreaming,
                    onChanged: (shouldStream) async=> shouldStream ? await _startListeningToScanResults(context):_stopListeningToScanResults(),
                    activeColor: Colors.green
                  )
                ],
              ),
              const Divider( color: Colors.white24,),
              Flexible(
                child: Center(
                  child: accessPoints.isEmpty
                  ? Text("No Results. Make sure wifi is on.", style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),)
                  :ListView.builder(
                    itemCount: accessPoints.length,
                    itemBuilder: (context, i)=>
                    _AccessPointTile(accessPoint: accessPoints[i]),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
class _AccessPointTile extends StatefulWidget {
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({Key? key, required this.accessPoint})
      : super(key: key);

  @override
  State<_AccessPointTile> createState() => _AccessPointTileState();
}

class _AccessPointTileState extends State<_AccessPointTile> {
  // build row that can display info, based on label: value pair.
  bool check = false;
  @override
  Widget build(BuildContext context) {
    final title = widget.accessPoint.ssid.isNotEmpty ? widget.accessPoint.ssid : "**EMPTY**";
    final signalIcon = widget.accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: check?Icon(Icons.check,color: Colors.green,):Icon(signalIcon,color: Colors.white,),
      title: Text(title,style: TextStyle(color: Colors.white),),
      subtitle: Text(widget.accessPoint.capabilities),
      onTap: (){
        setState((){
          check?check = false:check = true;
        });
      },
    );
  }
}
void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}