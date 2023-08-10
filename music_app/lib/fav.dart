import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/main.dart';
import 'package:sizer/sizer.dart';

class Fav extends StatefulWidget {
  const Fav({super.key});

  @override
  State<Fav> createState() => _FavState();
}

class _FavState extends State<Fav> {
  var songList1, isLoading1 = true;

  Future SongList1() async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot;
      querySnapshot = await _firestore
          .collection('song')
          .where("fav", isEqualTo: "T")
          .get();

      setState(() {
        songList1 = querySnapshot.docs.map((doc) => doc.data()).toList();
        isLoading1 = false;
      });

      // print(lr);
      //     .then((value) {
      //     print(value.docs[0].data());
      //   //  req = value.docs[0].data() as List;
      // });
    } catch (e) {
      print(e.toString());
      // setState(() {
      //   isLoading1 = true;
      // });
    }
  }

  Future updateFav(f, d) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (f == 'T') {
      await _firestore.collection('song').doc(d).update({"fav": f});
      final snackBar = SnackBar(
        content: Text('Added to favourite'),
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      await _firestore.collection('song').doc(d).update({"fav": f});
      final snackBar = SnackBar(
        content: Text('Removed from favourite'),
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
    SongList1();
    return Scaffold(
      body: SingleChildScrollView(
          child: isLoading1
              ? SizedBox(
                  height: 100.h,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Favourite Songs',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      for (var i = 0; i < songList1.length; i++)
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${songList1[i]['songName']}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text('${songList1[i]['singer']}'),
                                  Text('${songList1[i]['movieName']}'),
                                ],
                              ),
                              GestureDetector(
                                child: Icon(
                                  songList1[i]['fav'] == 'F'
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  updateFav(
                                      songList1[i]['fav'] == 'F' ? 'T' : 'F',
                                      songList1[i]['songName'] +
                                          songList1[i]['singer'] +
                                          songList1[i]['movieName']);
                                },
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                )),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: Text(
                'All',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            Text(
              'Favourite',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
