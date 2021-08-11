import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String jsonData;
  Map<String, dynamic> json;

  // List<UserProfile> json;
  Future<String> loadJson() async {
    return Future.delayed(Duration(seconds: 0)).then((value) async {
      jsonData = await DefaultAssetBundle.of(context)
          .loadString("assets/user_profile.json");
      json = jsonDecode(jsonData)[0];
      return jsonData;
    });
  }

  bool _initialized = false;
  bool _error = false;

  TextEditingController emailController,
      passwordController,
      passwordController2;

  String get _email => emailController.text;
  String get _password => passwordController.text;
  String get _password2 => passwordController2.text;

  // Define an async function to initialize FlutterFire
  void initialize() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordController2 = TextEditingController();
    // loadJson();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container(
        color: Colors.red,
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: 'kdineshdk18@gmail.com', password: '12341234')
                    .then((value) => print('signing in as ' + value.user.email))
                    .catchError((error) {
                  print('Error' + error);
                });
              }),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .catchError((e) => print('e + $e'));
              }),
          IconButton(
              icon: Icon(Icons.restore),
              onPressed: () {
                FirebaseAuth.instance.sendPasswordResetEmail(
                    email: FirebaseAuth.instance.currentUser.email);
              }),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('Create a new account'),
                                    TextField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder()),
                                      controller: emailController,
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder()),
                                      controller: passwordController,
                                      obscureText: true,
                                      // obscuringCharacter: '',
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder()),
                                      controller: passwordController2,
                                      obscureText: true,
                                      // obscuringCharacter: '',
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (_email.isNotEmpty &&
                                            _password.isNotEmpty &&
                                            _password2.isNotEmpty &&
                                            _password == _password2) {
                                          try {
                                            FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                                    email: _email,
                                                    password: _password);
                                            Navigator.of(context).pop();
                                          } catch (e) {
                                            print('error: $e');
                                          }
                                        }
                                      },
                                      icon: Container(
                                        child: Center(child: Text('Sign Up')),
                                        color: Colors.green,
                                        width: 60,
                                        height: 30,
                                      ),
                                      iconSize: 60,
                                    )
                                  ],
                                ),
                              )),
                        ),
                      );
                    });
              })
        ],
      ),
      body: Center(child: _initialized && !_error ? getPage() : cip),
    );
  }

  Widget get cip => CircularProgressIndicator();
  Widget getPage() => StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState.toString().contains('waiting')) {
          return cip;
        } else
          return FutureBuilder<String>(
            builder: (context, _snapshot) {
              if (_snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final UserProfile user =
                    UserProfile.fromJson(jsonDecode(_snapshot.data)[0]);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Logged in as ' +
                        FirebaseAuth.instance.currentUser.email),
                    Text(user.profile.role),
                  ],
                );
              } else {
                return Text('Kindly login to your account');
              }
            },
            future: loadJson(),
          );
      });
}
