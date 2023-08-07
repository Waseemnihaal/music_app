import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_app/home.dart';
import 'package:employee_app/register.dart';
import 'package:employee_app/sd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();

  TextEditingController _pass = TextEditingController();
  bool _obscure = true, rc = false;
  int type = 0;

  Future _login(uid, pass, type) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore
          .collection('user')
          .where("email", isEqualTo: uid)
          .where("password", isEqualTo: pass)
          .where("type", isEqualTo: type)
          .get()
          .then((value) {
        Map map = value.docs[0].data();
        saveData sd = saveData();
        sd.setID(map['email'], map['type'], map['name']);
        print(map);
        Navigator.of(context).pushReplacement(PageTransition(
            child: Home(),
            type: PageTransitionType.fade,
            childCurrent: widget,
            duration: Duration(milliseconds: 600),
            alignment: Alignment.topLeft));
      });
    } catch (e) {
      // print(e.toString());
      final snackBar = SnackBar(
        content: Text('Invalid credentials'),
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'LOGIN',
                  style: TextStyle(
                      color: HexColor('#0143DB'),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Image.asset('assets/logo.jpeg'),
                SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            hintText: 'Email ID',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: HexColor('#0143DB'), width: 2)),
                          ),
                          validator: (value) {
                            if (value == '') {
                              return 'Email ID is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          controller: _pass,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscure = !_obscure;
                                });
                              },
                              child: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Color.fromARGB(255, 134, 124, 124),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: HexColor('#0143DB'), width: 2)),
                          ),
                          validator: (value) {
                            if (value == '') {
                              return 'Password is required';
                            } else if (value!.length < 8) {
                              return 'Password should be atleast >8';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 45.w,
                              child: RadioListTile(
                                value: 1,
                                groupValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    type = value!;
                                  });
                                },
                                title: Text('Admin'),
                              ),
                            ),
                            SizedBox(
                              width: 45.w,
                              child: RadioListTile(
                                value: 2,
                                groupValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    type = value!;
                                  });
                                },
                                title: Text('Employee'),
                              ),
                            )
                          ],
                        ),
                        rc
                            ? Column(
                                children: [
                                  Divider(
                                    color: Colors.red,
                                    thickness: 1.2,
                                  ),
                                  Text(
                                    'Required',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            child: Text('Login'),
                            style: ElevatedButton.styleFrom(
                              primary: HexColor('#0143DB'),
                            ),
                            onPressed: () {
                              if (type == 0) {
                                setState(() {
                                  rc = true;
                                });
                              } else {
                                setState(() {
                                  rc = false;
                                });
                              }
                              if (_formKey.currentState!.validate() &&
                                  type != 0) {
                                _login(_email.text, _pass.text,
                                    type == 1 ? 'Admin' : 'Employee');
                                // FirebaseAuth.instance
                                //     .signInWithEmailAndPassword(
                                //         email: _email.text,
                                //         password: _pass.text)
                                //     .then((value) {
                                //   Navigator.of(context).pushReplacement(
                                //       PageTransition(
                                //           child: type == 1 ? Admin() : Emp(),
                                //           type: PageTransitionType.fade,
                                //           childCurrent: widget,
                                //           duration: Duration(milliseconds: 600),
                                //           alignment: Alignment.topLeft));
                                // }).onError((error, stackTrace) {
                                //   final snackBar = SnackBar(
                                //     content: Text(error
                                //         .toString()
                                //         .replaceAll(RegExp('\\[.*?\\]'), '')),
                                //     action: SnackBarAction(
                                //       label: 'Hide',
                                //       onPressed: () {},
                                //     ),
                                //   );
                                //   ScaffoldMessenger.of(context)
                                //       .showSnackBar(snackBar);
                                // });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account? '),
                            GestureDetector(
                              child: Text(
                                'SignUp',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor('#0143DB')),
                              ),
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    PageTransition(
                                        child: Reg(),
                                        type: PageTransitionType.fade,
                                        childCurrent: widget,
                                        duration: Duration(milliseconds: 600),
                                        alignment: Alignment.topLeft));
                              },
                            )
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
