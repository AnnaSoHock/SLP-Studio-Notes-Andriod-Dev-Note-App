import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'note_card.dart';
import 'dart:async';
import 'main.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);//constructor
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<Object?> getCurrUser() async{
  final currUser = FirebaseAuth.instance.currentUser?.uid;
  return currUser;
}

//Get current users note book data
Future<Object?> getNoteBookData() async {
    // final currUser = FirebaseAuth.instance.currentUser?.uid;
  // final ref = FirebaseDatabase.instance.ref();
  // final snapshot = await ref.child('users/$currUser/notes').get();
  //
  // if (snapshot.exists) {
  //   print("Current user's note book data");
  //   print(snapshot.value);
  //   return snapshot;
  //
  // } else {
  //   print('No data available.');
  // }
  // final s = FirebaseFirestore.instance.collection('users/$currUser/notes');
  // return s;
  //print(s);

}
class Notes{
  var title;
  var date;
  var content;
  var color;
  Notes(this.title, this.date, this.color, this.content);
}
void createNotes(){
  String datetime = DateTime.now().toString();
  var notesProfile = {
    'note_title' : "Untitled",
    'creation_date' : datetime,
    'note_content' : " ",
    'color_id' :6,
  };

  final currUser = FirebaseAuth.instance.currentUser?.uid;
  //Create user profile in firestore database
  // CollectionReference userNotes = FirebaseFirestore.instance.collection('users_notes');
  // userNotes.doc(currUser)
  //     .set(notesProfile)
  //     .then((value) => print("User notes added in fire store data base"))
  //     .catchError((error) => print("Failed to add user notes: $error"));
  FirebaseFirestore.instance.collection('users_notes').add({
    'note_title' : "Untitled",
    'creation_date' : datetime,
    'note_content' : " ",
    'color_id' :6,
  }).then((value) {
    print(value.id);
  }).catchError((onError)=>
    print("Falied to add new note due to $onError")
  );

}
class _HomeScreenState extends State<HomeScreen> {  //home screen actions
  // TextEditingController noteTitleController = TextEditingController();
  // TextEditingController creationDateController = TextEditingController();
  // TextEditingController noteContentController = TextEditingController();

  final currUser = FirebaseAuth.instance.currentUser?.uid;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Your recent Notes", style: GoogleFonts.roboto(color:Colors.black,fontWeight: FontWeight.bold, fontSize: 22,),),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:  FirebaseFirestore.instance.collection('users_notes').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snapshot.hasData)
                {
                  print("Succesfully got notes data");
                  print(snapshot.data!.docs.toList());
                  return GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    children: snapshot.data!.docs.map((note)=> noteCard(() => {}, note))
                        .toList(),
                  );
                  return Text("Notes", style: GoogleFonts.nunito(color: Colors.black ),);
                }
                return Text("There are no Notes", style: GoogleFonts.nunito(color: Colors.black ),);
              },

            ),
          ),



          //
          // FutureBuilder(
          //     future: getNoteBookData(),
          //     builder: (context, AsyncSnapshot snapshot) {
          //         if(snapshot.connectionState == ConnectionState.waiting){
          //           return Center(
          //             child: CircularProgressIndicator(),
          //           );
          //         }
          //         if(snapshot.hasData)
          //         {
          //           //final notesData = snapshot.data as String;
          //           print("Sucessfully obtained user data");
          //           return Text("SSS", style: GoogleFonts.nunito(color: Colors.black ),);
          //           // return GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //           //     crossAxisCount: 2),
          //           //   children: [
          //           //
          //           //   ],
          //           // );
          //         }
          //         return Text("There are no Notes", style: GoogleFonts.nunito(color: Colors.black ),);
          //     },
          // ),

          ElevatedButton(
            child: Text("Create New Notes"),
            onPressed: () {
              createNotes();
            },
          ),




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
    );
  }
}