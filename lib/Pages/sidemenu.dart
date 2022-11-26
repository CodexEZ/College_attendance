import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: SidebarXController(selectedIndex: 5,extended: true),
      showToggleButton: false,
      extendedTheme: SidebarXTheme(
        itemDecoration: BoxDecoration(

          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
        ),
        iconTheme: IconThemeData(
          size: 42
        ),
        selectedItemDecoration: BoxDecoration(

          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
        ),
        selectedIconTheme: IconThemeData(
          size:42,
          color: Color(0xFF9969ECFF)
        )

      ),
      items: [
        SidebarXItem(
            icon: FontAwesomeIcons.signOut,

          onTap: (){
              FirebaseAuth.instance.signOut();
          }
        ),
        SidebarXItem(icon: FontAwesomeIcons.person)
      ],
    );
  }
}
