import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_app/main.dart';
import 'package:employee_app/sd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:email_validator/email_validator.dart';
import 'home.dart';

class Reg extends StatefulWidget {
  const Reg({super.key});

  @override
  State<Reg> createState() => _RegState();
}

class _RegState extends State<Reg> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();

  TextEditingController _pass = TextEditingController();
  TextEditingController _conpass = TextEditingController();

  bool _obscure = true, rc = false;
  int type = 0;

  Future cloudFirestore(uid, name, email, pass, type) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore.collection('user').doc(uid).set({
      "name": name,
      "email": email,
      "password": pass,
      "type": type
    }).then((value) {
      saveData sd = saveData();
      sd.setID(email, type, name);
      final snackBar = SnackBar(
        content: Text('Account created successfully'),
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                'REGISTER',
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
                        controller: _name,
                        decoration: InputDecoration(
                          hintText: 'Name',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: HexColor('#0143DB'), width: 2)),
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'Name is required';
                          } else if (value!.length < 2) {
                            return 'Name should atleast be >2 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                          } else if (!EmailValidator.validate(value!)) {
                            return 'Email ID is not valid';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
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
                            return 'Password should atleast be >8';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _conpass,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
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
                            return 'Confirm Password is required';
                          } else if (_pass.text != value) {
                            return 'Confirm Password should be same as password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
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
                      // SizedBox(
                      //   height: 10,
                      // ),
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
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _email.text,
                                      password: _conpass.text)
                                  .then((value) {
                                Navigator.of(context).pushReplacement(
                                    PageTransition(
                                        child: Home(),
                                        type: PageTransitionType.fade,
                                        childCurrent: widget,
                                        duration: Duration(milliseconds: 600),
                                        alignment: Alignment.topLeft));
                                cloudFirestore(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    _name.text,
                                    _email.text,
                                    _conpass.text,
                                    type == 1 ? 'Admin' : 'Employee');
                              }).onError((error, stackTrace) {
                                final snackBar = SnackBar(
                                  content: Text(error
                                      .toString()
                                      .replaceAll(RegExp('\\[.*?\\]'), '')),
                                  action: SnackBarAction(
                                    label: 'Hide',
                                    onPressed: () {},
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
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
                          Text('Already have an account? '),
                          GestureDetector(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor('#0143DB')),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: MyApp(),
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
  }
}
