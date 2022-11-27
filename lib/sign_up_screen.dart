import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/home_screen.dart';
import 'main.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);//constructor
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {  //home screen actions
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {  //entire UI
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20,
          fontWeight: FontWeight.w500,),
        backgroundColor: Colors.brown.shade100,
        elevation: 0,
        title: const Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // const SizedBox(
                //   height: 20,
                // ),
                Container(  //maximum space you can use
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child:  TextFormField(
                        controller: usernameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Enter Username',
                        )
                    )),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child:  TextFormField(
                      controller: emailController,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                      )
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child:  TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                      )
                  ),
                ),

                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width /3,
                  margin: EdgeInsets.only(top: 5),
                  child: ElevatedButton(
                      onPressed: () {
                        //sign up user and save to Firebase Auth service
                        FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                            .then((authResult) {
                              print("Created new account UID" + authResult.user!.uid.toString());

                              //create user profile in real-time database
                              var userProfile = {
                                'uid' : authResult.user!.uid,
                                'email' : emailController.text,
                                'username' : usernameController.text,
                              };

                              String datetime = DateTime.now().toString();
                              var notesProfile = {
                                'note_title' : "Untitled",
                                'creation_date' : datetime,
                                'note_content' : " ",
                                'color_id' :6,
                              };

                              //Create user profile in real-time db
                              FirebaseDatabase.instance.ref().child("users/" + authResult.user!.uid)
                              .set(userProfile)
                              .then((value) {
                                print("Successfully created the profile info");
                              }).catchError((onError){
                                print("Failed to create the profile info : " + onError.toString());
                              });

                              //Create notes profile in real-time db
                              FirebaseDatabase.instance.ref().child("users/" + authResult.user!.uid + "/notes")
                                  .set(notesProfile)
                                  .then((value) {
                                print("Successfully created the notes profile info");
                              }).catchError((onError){
                                print("Failed to create the notes profile info : " + onError.toString());
                              });


                          //Push info to next screen to allow user to sign up
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomeScreen())
                          ).catchError((error) {
                            print("Failed to sign up");
                            print(error.toString());
                          });
                        });

                      },
                      child: Text("Signup")
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}