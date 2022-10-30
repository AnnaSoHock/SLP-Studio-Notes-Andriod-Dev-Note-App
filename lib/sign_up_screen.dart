import 'package:firebase_auth/firebase_auth.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text("Sign Up",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
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
                            .then((value) {
                              print("Created new account");
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