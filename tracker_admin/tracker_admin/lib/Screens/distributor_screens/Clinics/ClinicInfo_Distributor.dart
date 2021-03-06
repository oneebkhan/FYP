import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker_admin/screens/distributor_screens/Clinics/EditClinic.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: camel_case_types
class ClinicInfo_Distributor extends StatefulWidget {
  final String name;

  ClinicInfo_Distributor({
    Key key,
    this.name,
  }) : super(key: key);

  @override
  _ClinicInfo_DistributorState createState() => _ClinicInfo_DistributorState();
}

// ignore: camel_case_types
class _ClinicInfo_DistributorState extends State<ClinicInfo_Distributor> {
  double width;
  double height;
  double safePadding;
  //opacity of the normal text
  double opac;
  //opacity of the image;
  double opac2;
  int index;
  int index2;

  var page = PageController();
  var page2 = PageController();
  var info;
  List<Widget> numberOfImagesIndex;
  List clinicsAdded;
  var distributorInfo;

  //
  //
  // makes a list of widgets for the first page view
  // ignore: missing_return
  Future getImages() {
    for (int i = 0; i < info['imageURL'].length; i++) {
      setState(() {
        numberOfImagesIndex.add(
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.dstATop),
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  info['imageURL'][i].toString(),
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  //
  //
  // gets the firebase data of that particular medicine
  getClinicInfo() async {
    try {
      // ignore: unused_local_variable
      StreamSubscription<DocumentSnapshot> stream = await FirebaseFirestore
          .instance
          .collection('Clinic')
          .doc(widget.name)
          .snapshots()
          .listen((event) {
        setState(() {
          info = event.data();
          getImages();
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // Gets the current pharmacies added by the distributor
  getDistributorClinics() async {
    await FirebaseFirestore.instance
        .collection('Distributor')
        .doc(info['addedBy'])
        .get()
        .then((value) {
      setState(() {
        clinicsAdded = value.data()['clinicsAdded'];
      });
    });
  }

  //
  //
  // Gets the distributor info of the distributor that is currently logged in
  getDistributor() async {
    await FirebaseFirestore.instance
        .collection('Distributor')
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      setState(() {
        distributorInfo = value.data();
      });
    });
  }

  //
  //
  //Deletes the clinics doc
  deleteClinicsFromDistributorAndClinicCollection() async {
    setState(() {
      clinicsAdded.remove(info['uid']);
    });
    return FirebaseFirestore.instance
        .collection("Distributor")
        .doc(info['addedBy'])
        .update({
      "clinicsAdded": clinicsAdded,
    }).then((value) {
      FirebaseFirestore.instance
          .collection('Clinic')
          .doc(info['uid'])
          .delete()
          .catchError((error) => print("Failed to delete user: $error"))
          .then((value) {
        Navigator.pop(context);
      });
    });
  }

  //
  //
  // Updates the history document
  updateHistory() async {
    await FirebaseFirestore.instance
        .collection("History")
        .doc(DateTime.now().toString())
        .set({
          "timestamp": DateTime.now(),
          "by": distributorInfo['email'],
          "byCompany": distributorInfo['companyName'],
          "image": distributorInfo['image'],
          "name": info['name'] + ' clinics deleted',
          "category": 'distributor',
        })
        .then((value) => deleteFolderContents(info['name']))
        .then((value) => deleteClinicsFromDistributorAndClinicCollection());
  }

  //
  //
  // Delete the user folder contents in firebase storage
  deleteFolderContents(clinicsName) {
    String path = "Clinics/" + "$clinicsName";
    var ref = FirebaseStorage.instance.ref(path);

    ref.listAll().then((dir) {
      dir.items.forEach((fileRef) {
        this.deleteFile(ref.fullPath, fileRef.name);
      });
      dir.prefixes.forEach((folderRef) {
        this.deleteFolderContents(folderRef.fullPath);
      });
    }).catchError((error) => Fluttertoast.showToast(msg: "$error"));
  }

  deleteFile(pathToFile, fileName) {
    var ref = FirebaseStorage.instance.ref(pathToFile);
    var childRef = ref.child(fileName);
    childRef.delete();
  }

  @override
  void initState() {
    super.initState();
    getDistributor();

    opac = 0;
    opac2 = 0;
    index = 0;
    index2 = 0;
    numberOfImagesIndex = [];
    getClinicInfo();

    Future.delayed(Duration(milliseconds: 1000), () {
      getDistributorClinics();
      setState(() {
        opac2 = 1.0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //
  //
  // These two functions make the page scroll up even when the page has a singlechildscrollview
  _scrollUp() async {
    await page.previousPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  _scrollDown() async {
    await page.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  //
  //
  // The method to call the clinics or clinic
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      Fluttertoast.showToast(msg: 'Could not Launch $command');
    }
  }

  //
  //
  // launch google maps
  static Future<void> openMap(String query) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${query}';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    page = PageController(initialPage: 0);
    page2 = PageController(initialPage: 0);
    return info == null
        ? Container(
            color: Colors.black,
            width: width,
            height: height,
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.black,
            floatingActionButton: SpeedDial(
              backgroundColor: Color.fromARGB(255, 148, 210, 146),
              overlayColor: Colors.black,
              overlayOpacity: 0.4,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(color: Colors.white),
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  label: 'Go to Location',
                  backgroundColor: Color.fromARGB(255, 148, 210, 146),
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                  onTap: () {
                    openMap(info['location']);
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  label: 'Call Clinic',
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: Color.fromARGB(255, 148, 210, 146),
                  onTap: () {
                    customLaunch('tel:' + info['phoneNumber']);
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  label: 'Edit Info',
                  backgroundColor: Color.fromARGB(255, 148, 210, 146),
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditClinic(
                          imageURL: info['imageURL'],
                          location: info['location'],
                          name: info['name'],
                          ratings: info['rating'],
                          timings: info['timings'],
                          uid: info['uid'],
                        ),
                      ),
                    );
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: 'Delete Clinic',
                  backgroundColor: Color.fromARGB(255, 148, 210, 146),
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Delete ' + info['name'] + '?'),
                        content: Text(
                            'This will delete the clinics and its images folder.'),
                        actions: [
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (_) => customAlert());
                              updateHistory();
                              Future.delayed(Duration(milliseconds: 2100), () {
                                Navigator.pop(context);
                                //Navigator.pop(context);
                              });
                            },
                          ),
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    index2 == 0
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_up_outlined,
                    color: Colors.white,
                  ),
                  onTap: () {
                    if (index2 == 1) {
                      page.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      page.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                  backgroundColor: Color.fromARGB(255, 148, 210, 146),
                  label:
                      index2 == 0 ? 'Go to Next Page' : 'Go to Previous Page',
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            body: PageView(
              scrollDirection: Axis.vertical,
              controller: page,
              onPageChanged: (i) {
                setState(() {
                  index2 = i;
                });
              },
              children: [
                Stack(
                  children: [
                    //
                    //
                    // The image behind the info
                    PageView(
                        controller: page2,
                        onPageChanged: (i) {
                          setState(() {
                            index = i;
                          });
                        },
                        children: numberOfImagesIndex == null
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              )
                            : numberOfImagesIndex),
                    //
                    //
                    // The top page info
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: opac2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: width / 1.2,
                                  child: Text(
                                    info['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            //
                            //
                            // indicator of the number of pictures
                            info['imageURL'][0] == null
                                ? Container()
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.black45,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 13,
                                          vertical: 10,
                                        ),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.all(0),
                                          itemCount: info['imageURL'].length,
                                          itemBuilder:
                                              (BuildContext context, int ind) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.5),
                                              child: Container(
                                                margin: EdgeInsets.all(0),
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: index == ind
                                                      ? Color.fromARGB(
                                                          255, 148, 210, 146)
                                                      : Colors.grey[700],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Location: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    info['location'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 27,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phone Number:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    info['phoneNumber'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 27,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: width / 7,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //
                //
                // function to allow for scroll in the single child scroll view
                NotificationListener(
                  onNotification: (notification) {
                    if (notification is OverscrollNotification) {
                      if (notification.overscroll > 0) {
                        _scrollDown();
                      } else {
                        _scrollUp();
                      }
                    }
                  },
                  //
                  //
                  // The bottom page info
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 50, 50, 50),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Clinic Location',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: width / 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'The clinics is located in ' +
                                          info['location'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width / 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 50, 50, 50),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Company Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: width / 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      info['companyName'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width / 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            //
                            //
                            // To be removed if there is no barcode search
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width / 2.26,
                                    height: width / 3.3,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 50, 50, 50),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Timings',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: width / 20,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            info['timings'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width / 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 2.26,
                                    height: width / 3.3,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 254, 192, 70),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: width / 8,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          info['rating'].toString() + '/5',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width / 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: width / 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  //
  //
  //custom alert dialogue
  customAlert() {
    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.pop(context);
      //Navigator.pop(context);
    });
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        width: width,
        height: height / 5,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                height: width / 4,
                child: Lottie.asset(
                  'assets/lottie/deletedSuccessfully.json',
                  frameRate: FrameRate(144),
                  repeat: false,
                ),
              ),
            ),
            SizedBox(
              height: height / 30,
            ),
            Container(
              child: Text(
                'Clinic Deleted Successfully!',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
