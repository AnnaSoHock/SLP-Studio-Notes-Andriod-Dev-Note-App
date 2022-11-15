import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'note_card.dart';

import 'main.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);//constructor
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {  //home screen actions
  @override
  Widget build(BuildContext context) {  //entire UI
    return Scaffold(    //default UI
      body: Center(
        child: ListView(  //ListView child of Center
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text('One-line with leading widget'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote()));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: FlutterLogo(size: 72.0),
                title: Text('Three-line ListTile'),
                subtitle: Text(
                    'A sufficiently long subtitle warrants three lines.'
                ),
                trailing: Icon(Icons.more_vert),
                isThreeLine: true,
              ),
            ),

            ElevatedButton(
              child: Text("Logout"),
              onPressed: () {
                //Sign out when user presses log out btn
                FirebaseAuth.instance.signOut().then((value) {
                  //Go back to the main screen when logout is pressed
                  print("Signed Out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                });
              },
            )
          ],
        ),
      ),
    );
  }
}