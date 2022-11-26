import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'note_card.dart';
import 'dart:async';
import 'main.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);//constructor
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//Get current users note book data
Future<Object?> getNoteBookData() async {
  final currUser = FirebaseAuth.instance.currentUser?.uid;
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('users/$currUser/notebook').get();

  if (snapshot.exists) {
    print("Current user's data");
    print(snapshot.value);

    return currUser;
  } else {
    print('No data available.');
  }
}
class _HomeScreenState extends State<HomeScreen> {  //home screen actions
  @override
  Widget build(BuildContext context) {  //entire UI
    return Scaffold(//default UI
     //backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("StudioNotes"),
        centerTitle: true,
        //backgroundColor: AppStyle.mainColor,
      ),
      body: Center(
        child: ListView(  //ListView child of Center
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Your recent Notes", style: GoogleFonts.roboto(color:Colors.black,fontWeight: FontWeight.bold, fontSize: 22,),),
                )
              ],
            ),

            // StreamBuilder<QuerySnapshot>(
            //   stream: FirebaseFirestore.instance.collection("Notes").snapshots(),
            //   builder: (context, AsyncSnapshot snapshot){
            //     if(snapshot.connectionState == ConnectionState.waiting){
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //     if(snapshot.hasData)
            //     {
            //       return GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2));
            //     }
            //     return Text("There are no Notes", style: GoogleFonts.nunito(color: Colors.black ),);
            //   },
            //
            // ),
            FutureBuilder(
                future: getNoteBookData(),
                builder: (context, AsyncSnapshot snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(snapshot.hasData)
                    {
                      final data = snapshot.data as String;
                      print("Sucessfully obtained user data");
                      return Text("$data", style: GoogleFonts.nunito(color: Colors.black ),);
                    }
                    return Text("There are no Notes", style: GoogleFonts.nunito(color: Colors.black ),);
                },
            ),



    //
            // Card(
            //   child: ListTile(
            //     title: Text('Create new Note'),
            //     onTap: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote()));
            //     },
            //   ),
            // ),
            // Card(
            //   child: ListTile(
            //     leading: FlutterLogo(size: 72.0),
            //     title: Text('Three-line ListTile'),
            //     subtitle: Text(
            //         'A sufficiently long subtitle warrants three lines.'
            //     ),
            //     trailing: Icon(Icons.more_vert),
            //     isThreeLine: true,
            //   ),
            // ),

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