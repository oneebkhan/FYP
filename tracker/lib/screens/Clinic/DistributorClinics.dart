import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker/Widgets/InfoContainer.dart';
import 'package:tracker/screens/Clinic/ViewClinic.dart';
import 'dart:math' as math;

class DistributorClinics extends StatefulWidget {
  @override
  _DistributorClinicsState createState() => _DistributorClinicsState();
}

class _DistributorClinicsState extends State<DistributorClinics> {
  double width;
  double height;
  double opac;
  // Variable that stores the distributors
  var distributorStream;
  // variable to store urls in the
  List<String> imageURL;
  // connectivity of the application
  bool con;

  //
  //
  //Check internet connection
  checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Not Connected to the Internet!');
      setState(() {
        con = true;
      });
    } else
      setState(() {
        con = false;
      });
  }

  //
  //
  //
  convertToStringList(elements) {
    for (int i; i < elements.length; i++) {
      setState(() {
        imageURL.add(elements[i].toString());
      });
    }
  }

  //
  //
  // The function to get distributors
  getDistributors() async {
    try {
      setState(() {
        distributorStream = FirebaseFirestore.instance
            .collection('Distributor')
            .where('clinicsAdded', isNotEqualTo: null)
            .orderBy('name')
            .snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    imageURL = [];
    getDistributors();
    checkInternet();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 248),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: width / 20,
                ),
                Text(
                  'Clinics',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width / 14,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //
                //
                // The container fields
                AnimatedOpacity(
                  opacity: opac,
                  duration: Duration(milliseconds: 500),
                  child: con == true
                      ? Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: height / 3, bottom: 20),
                                child: Text('No Internet Connection...'),
                              ),
                              TextButton(
                                onPressed: () {
                                  checkInternet();
                                },
                                child: Text('Reload'),
                              ),
                            ],
                          ),
                        )
                      : StreamBuilder<QuerySnapshot>(
                          stream: distributorStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData == false) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                QueryDocumentSnapshot item =
                                    snapshot.data.docs[index];
                                return InfoContainer(
                                  //
                                  //
                                  // function to make the colors change in each container
                                  color: Color((math.Random().nextDouble() *
                                              0xFFFFFF)
                                          .toInt())
                                      .withOpacity(1.0),
                                  description:
                                      '${item['clinicsAdded'].length} Clinics',
                                  func: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ViewClinic(
                                          pageName: item['name'],
                                          clinics: item['clinicsAdded'],
                                        ),
                                      ),
                                    );
                                  },
                                  imageUrls: item['clinicImages'],
                                  title: item['name'],
                                  width: width,
                                  height: height,
                                  countOfImages: item['clinicImages'].length,
                                );
                              },
                            );
                          }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
