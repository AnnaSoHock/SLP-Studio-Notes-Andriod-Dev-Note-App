import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_projects/app_style.dart';
import 'sign_up_screen.dart';
import 'home_screen.dart';


void main() async{
  //Initialize firebase first before app starts
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white70,
        appBarTheme: AppBarTheme(color: Colors.brown.shade100, titleTextStyle: TextStyle(color: Colors.grey.shade700, fontSize: 20,
        fontWeight: FontWeight.w500,)),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.brown.shade100,
          cursorColor: Colors.brown.shade100,
        ),
        brightness: Brightness.light,
        highlightColor: Colors.white,
        elevatedButtonTheme:
        ElevatedButtonThemeData(style:ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey),
            borderRadius: BorderRadius.circular(100.0))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.brown.shade100),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade700) )
        ),

      ),
      home: const MyHomePage(title: 'Studio Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.grey.shade50,//default UI
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child:  Padding(
          padding: EdgeInsets.all(16),
          child:   Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  //alignment
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Image.asset('assets/images/StudioNotesLogo.png'),
                ),

                Container(  //maximum space you can use
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child:  TextFormField(
                        controller: usernameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        )
                    )),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child:  TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      )
                  ),
                ),

                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width /3,
                  margin: EdgeInsets.only(top: 5),
                  child:  ElevatedButton(
                      onPressed: (){
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: usernameController.text, password: passwordController.text)
                            .then((value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomeScreen())
                          ).catchError((error) {
                            print("Failed to login");
                            print(error.toString());
                          });
                        });
                      },
                      child: Text("Login")
                  ),
                ),

                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width /3,
                  margin: EdgeInsets.only(top: 5),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUpScreen())
                        );
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
