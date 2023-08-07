import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_app/sd.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class Afood extends StatefulWidget {
  const Afood({super.key});

  @override
  State<Afood> createState() => _AfoodState();
}

class _AfoodState extends State<Afood> {
  saveData sd = saveData();
  var foodItems = [
        {"name": "Dairy Milk", "img": "assets/DairyMilk.png", "qty": 0},
        {"name": "Mountain Dew", "img": "assets/mountain_dew.png", "qty": 0},
        {"name": "Oreo", "img": "assets/Oreo.png", "qty": 0},
        {
          "name": "Tata Gluco Plus",
          "img": "assets/tata-gluco-plus.png",
          "qty": 0
        },
        {"name": "Treat", "img": "assets/treat.png", "qty": 0},
      ],
      fil,
      ias = true;

  void itemInc(i) {
    setState(() {
      // qty++;
      foodItems[i]['qty'] = int.parse(foodItems[i]['qty'].toString()) + 10;
    });
  }

  void itemDec(i) {
    setState(() {
      //qty--;
      foodItems[i]['qty'] = int.parse(foodItems[i]['qty'].toString()) - 10;
    });
  }

  Future fi() async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await _firestore
          .collection('food')
          //  .where("email", isEqualTo: sd.getID())
          .get();
      setState(() {
        fil = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future afi(name, qty, uqty) async {
    var id;
    if (name == 'Dairy Milk') {
      id = 'dairy_milk';
    } else if (name == 'Mountain Dew') {
      id = 'mountain_dew';
    } else if (name == 'Oreo') {
      id = 'oreo';
    } else if (name == 'Tata Gluco Plus') {
      id = 'tata_gluco_plus';
    } else if (name == 'Treat') {
      id = 'treat';
    }
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore
        .collection('food')
        .where("name", isEqualTo: name)
        .get()
        .then((value) async {
      await _firestore
          .collection('food')
          .doc(id)
          .update({"qty": qty + uqty}).then((value) {
        for (var i = 0; i < foodItems.length; i++) {
          setState(() {
            foodItems[i]['qty'] = 0;
          });
        }
        if (ias) {
          final snackBar = SnackBar(
            content: Text('Items added successfully'),
            action: SnackBarAction(
              label: 'Hide',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          ias = false;
        }
      });
    }).onError((error, stackTrace) {
      final snackBar = SnackBar(
        content: Text('Unable to add items'),
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
    fi();
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Text(
                      'Welcome\n         ' +
                          sd.getName().toString().toUpperCase(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: HexColor('#0143DB')),
                    ),
                  ),
                ),
                (fil != null && fil.length > 0)
                    ? Column(
                        children: [
                          for (var i = 0; i < fil.length; i++)
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all()),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          '${foodItems[i]['img']}',
                                          width: 80,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          '${fil[i]['name']}',
                                          style: TextStyle(
                                              color: HexColor('#0143DB'),
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: fil[i]['qty'] == 0
                                          ? Text(
                                              'Out of stock',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  'Available Qty',
                                                  // style: TextStyle(
                                                  //     color: HexColor('#0143DB')),
                                                ),
                                                Text(
                                                  '${fil[i]['qty']}',
                                                  style: TextStyle(
                                                      color:
                                                          HexColor('#0143DB')),
                                                ),
                                              ],
                                            ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Text(
                            'No Food available',
                            style: TextStyle(
                                color: HexColor('#0143DB'),
                                fontWeight: FontWeight.w600,
                                fontSize: 25),
                          ),
                        ),
                      )
              ],
            ),
          )),
          Container(
            margin: EdgeInsets.only(right: 20, bottom: 30),
            height: 100.h,
            child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    backgroundColor: HexColor('#0143DB'),
                    child: Icon(Icons.add),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              height: 80.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 15, left: 15),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Add items to fridge',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      for (var i = 0; i < foodItems.length; i++)
                                        Container(
                                          margin: EdgeInsets.only(bottom: 20),
                                          height: 70,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all()),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      '${foodItems[i]['img']}',
                                                      width: 80,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      '${foodItems[i]['name']}',
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              '#0143DB'),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.grey,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            child: Container(
                                                              height: 25,
                                                              width: 25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: int.parse(foodItems[i]['qty']
                                                                            .toString()) >
                                                                        0
                                                                    ? HexColor(
                                                                        '#0143DB')
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              if (int.parse(foodItems[
                                                                              i]
                                                                          [
                                                                          'qty']
                                                                      .toString()) >
                                                                  0) {
                                                                setState(() {
                                                                  itemDec(i);
                                                                });
                                                              }
                                                            },
                                                          ),
                                                          Text(
                                                            '${foodItems[i]['qty']}',
                                                            style: TextStyle(
                                                                color: HexColor(
                                                                    '#0143DB')),
                                                          ),
                                                          GestureDetector(
                                                            child: Container(
                                                                height: 25,
                                                                width: 25,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: int.parse(foodItems[i]['qty']
                                                                              .toString()) <
                                                                          100
                                                                      ? HexColor(
                                                                          '#0143DB')
                                                                      : Colors
                                                                          .grey,
                                                                ),
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            onTap: () {
                                                              if (int.parse(foodItems[
                                                                              i]
                                                                          [
                                                                          'qty']
                                                                      .toString()) <
                                                                  100) {
                                                                setState(() {
                                                                  itemInc(i);
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ]),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        child: Text('Add'),
                                        style: ElevatedButton.styleFrom(
                                            primary: HexColor('#0143DB')),
                                        onPressed: () {
                                          for (var i = 0;
                                              i < foodItems.length;
                                              i++) {
                                            if (int.parse(foodItems[i]['qty']
                                                    .toString()) >
                                                0) {
                                              afi(
                                                  foodItems[i]['name'],
                                                  fil[i]['qty'],
                                                  foodItems[i]['qty']);
                                            }
                                          }
                                          Navigator.pop(context);
                                          ias = true;
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      );
                    })),
          )
        ],
      ),
    );
  }
}
