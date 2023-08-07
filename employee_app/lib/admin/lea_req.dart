import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import '../sd.dart';

class Aleave extends StatefulWidget {
  const Aleave({super.key});

  @override
  State<Aleave> createState() => _AleaveState();
}

class _AleaveState extends State<Aleave> {
  int ltype = 0;
  saveData sd = saveData();
  var lr, dd = 'All', ddl = ['All', 'Accepted', 'Rejected', 'Pending'];
  bool isLoading = true;
  Future lrs() async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot;
      if (dd == 'All') {
        querySnapshot = await _firestore
            .collection('leave')
            //  .where("email", isEqualTo: sd.getID())
            .get();
      } else {
        querySnapshot = await _firestore
            .collection('leave')
            .where("status", isEqualTo: dd)
            .get();
        //  print(querySnapshot);
      }
      setState(() {
        lr = querySnapshot.docs.map((doc) => doc.data()).toList();
        isLoading = false;
      });

      // print(lr);
      //     .then((value) {
      //     print(value.docs[0].data());
      //   //  req = value.docs[0].data() as List;
      // });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Future adreq(doc, st) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore
        .collection('leave')
        .doc(doc)
        .update({"status": st}).then((value) {
      if (st != 'Pending') {
        final snackBar = SnackBar(
          content: st == 'Accepted'
              ? Text('Accepted sucessfully')
              : Text('Rejected sucessfully'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              adreq(doc, 'Pending');
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).onError((error, stackTrace) {
      final snackBar = SnackBar(
        content: Text('$st has not done'),
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
    lrs();
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Welcome\n         ' + sd.getName().toString().toUpperCase(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: HexColor('#0143DB')),
                ),
                SizedBox(
                  width: 100,
                  child: DropdownButton(
                    isExpanded: true,
                    value: dd,
                    onChanged: (value) {
                      setState(() {
                        dd = value!;
                      });
                    },
                    items: ddl.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(child: Text(value)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : (lr != null && lr.length > 0)
                    ? Column(
                        children: [
                          Container(
                            height: 50,
                            color: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                    child: Text(
                                      'Name',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                    child: Text(
                                      'Leave on',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  )
                                ],
                              ),
                            ),
                          ),
                          for (var i = 0; i < lr.length; i++)
                            ExpansionTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: 20.w,
                                      child: Text('${lr[i]['name']}')),
                                  SizedBox(
                                      width: 20.w,
                                      child: Text('${lr[i]['Date']}')),
                                  SizedBox(
                                      width: 20.w,
                                      child: Text(
                                        '${lr[i]['status']}',
                                        style: TextStyle(
                                            color: lr[i]['status'] == 'Pending'
                                                ? HexColor('#0143DB')
                                                : (lr[i]['status'] == 'Accepted'
                                                    ? Colors.green
                                                    : Colors.red)),
                                      )),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 20.w,
                                          child: Text('Applied on:')),
                                      SizedBox(
                                          width: 60.w,
                                          child:
                                              Text('${lr[i]['appliedDate']}'))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 20.w,
                                          child: Text('Leave Type:')),
                                      SizedBox(
                                          width: 60.w,
                                          child: Text('${lr[i]['LeaveType']}'))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 20.w, child: Text('Reason:')),
                                      SizedBox(
                                          width: 60.w,
                                          child: Text('${lr[i]['reason']}'))
                                    ],
                                  ),
                                ),
                                if (lr[i]['status'] == 'Pending')
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            adreq(
                                                lr[i]['email'] + lr[i]['Date'],
                                                'Rejected');
                                          },
                                          child: Text('Reject'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            adreq(
                                                lr[i]['email'] + lr[i]['Date'],
                                                'Accepted');
                                          },
                                          child: Text('Accept'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green),
                                        )
                                      ],
                                    ),
                                  ),
                                if (lr[i]['status'] != 'Pending')
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${lr[i]['status']}',
                                        style: TextStyle(
                                            color: lr[i]['status'] == 'Accepted'
                                                ? Colors.green
                                                : Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      )),
                              ],
                            ),
                        ],
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Text(
                            'No Leave request available',
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
    );
  }
}
