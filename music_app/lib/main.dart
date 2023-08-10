import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_app/fav.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _songName = TextEditingController();
  TextEditingController _singer = TextEditingController();
  TextEditingController _movieName = TextEditingController();

  var songList, isLoading = true;

  Future addSong(sname, singer, mname, fav) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore.collection('song').doc(sname + singer + mname).set({
      "songName": sname,
      "singer": singer,
      "movieName": mname,
      "fav": fav,
      "Date": DateTime.now().toString()
    }).then((value) {
      setState(() {
        _songName.text = '';
        _singer.text = '';
        _movieName.text = '';
      });
      final snackBar = SnackBar(
        content: Text('Song added successfully'),
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).onError((error, stackTrace) {
      final snackBar = SnackBar(
        content: Text('Unable to add song'),
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future SongList() async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot;
      querySnapshot = await _firestore
          .collection('song')
          //.where("email", isEqualTo: sd.getID())
          .get();

      setState(() {
        songList = querySnapshot.docs.map((doc) => doc.data()).toList();
        isLoading = false;
      });

      // print(lr);
      //     .then((value) {
      //     print(value.docs[0].data());
      //   //  req = value.docs[0].data() as List;
      // });
    } catch (e) {
      print(e.toString());
      // setState(() {
      //   isLoading = true;
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
    SongList();
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        body: SingleChildScrollView(
            child: isLoading
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
                            'Songs',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        for (var i = 0; i < songList.length; i++)
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 80,
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
                                      '${songList[i]['songName']}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text('${songList[i]['singer']}'),
                                    Text('${songList[i]['movieName']}'),
                                  ],
                                ),
                                GestureDetector(
                                  child: Icon(
                                    songList[i]['fav'] == 'F'
                                        ? Icons.favorite_border
                                        : Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onTap: () {
                                    updateFav(
                                        songList[i]['fav'] == 'F' ? 'T' : 'F',
                                        songList[i]['songName'] +
                                            songList[i]['singer'] +
                                            songList[i]['movieName']);
                                  },
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  )),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextField(
                              controller: _songName,
                              decoration:
                                  InputDecoration(hintText: 'Song Name'),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            TextField(
                              controller: _singer,
                              decoration: InputDecoration(hintText: 'Singer'),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            TextField(
                              controller: _movieName,
                              decoration:
                                  InputDecoration(hintText: 'Movie Name'),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  addSong(_songName.text, _singer.text,
                                      _movieName.text, 'F');
                                  Navigator.pop(context);
                                },
                                child: Text('Add'))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
        bottomNavigationBar: Container(
          height: 60,
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'All',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                child: Text(
                  'Favourite',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Fav()),
                  );
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
