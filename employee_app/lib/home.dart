import 'package:employee_app/admin/food_add.dart';
import 'package:employee_app/admin/lea_req.dart';
import 'package:employee_app/emp/food.dart';
import 'package:employee_app/emp/leave_req.dart';
import 'package:employee_app/main.dart';
import 'package:employee_app/sd.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  saveData sd = saveData();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(children: [
            Container(
              padding:
                  EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
              color: HexColor('#0143DB'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sd.getType() == 'Admin' ? 'Admin' : 'Employee',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(PageTransition(
                          child: MyApp(),
                          type: PageTransitionType.fade,
                          childCurrent: widget,
                          duration: Duration(milliseconds: 600),
                          alignment: Alignment.topLeft));
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(color: HexColor('#0143DB')),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                  )
                ],
              ),
            ),
            TabBar(tabs: [
              Tab(
                child: Text(
                  'Leave request',
                  style: TextStyle(color: HexColor('#0143DB')),
                ),
              ),
              Tab(
                child: Text(
                  'Food',
                  style: TextStyle(color: HexColor('#0143DB')),
                ),
              )
            ]),
            Expanded(
              child: TabBarView(children: [
                sd.getType() == 'Admin' ? Aleave() : Eleave(),
                sd.getType() == 'Admin' ? Afood() : Efood(),
              ]),
            )
          ]),
        ));
  }
}
