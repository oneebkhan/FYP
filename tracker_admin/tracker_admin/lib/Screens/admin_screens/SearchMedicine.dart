import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/screens/MedicineInfo.dart';
import 'package:tracker_admin/screens/admin_screens/MedicineModelInfo.dart';
import 'package:tracker_admin/screens/admin_screens/AddDistributor.dart';

class SearchMedicine extends StatefulWidget {
  SearchMedicine({Key key}) : super(key: key);

  @override
  _SearchMedicineState createState() => _SearchMedicineState();
}

class _SearchMedicineState extends State<SearchMedicine> {
  double opac;
  double height;
  bool isSearchMedicineed;
  bool isLoading;
  String hello = '';
  bool con;
  List<bool> selection;
  int selectedIndex;
  String searchMedicineTerm;

  @override
  void initState() {
    super.initState();
    opac = 0;
    selection = [false, true];
    selectedIndex = 1;
    searchMedicineTerm = 'Medicine Name';
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Search',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width / 14,
                        ),
                      ),
                      SizedBox(
                        width: width / 5,
                      ),
                      Text(
                        'Search by:',
                        style: TextStyle(
                          fontSize: width / 30,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ToggleButtons(
                          fillColor: Colors.white,
                          highlightColor: Color.fromARGB(255, 170, 200, 240),
                          splashColor: Color.fromARGB(255, 170, 200, 240),
                          borderRadius: BorderRadius.circular(10),
                          focusColor: Colors.white,
                          selectedColor: Color.fromARGB(255, 170, 200, 240),
                          onPressed: (int index) {
                            if (index == 0) {
                              setState(() {
                                selection[0] = true;
                                selection[1] = false;
                                //change to all Pharmacies
                                selectedIndex = 0;
                                searchMedicineTerm = 'Barcode';
                              });
                              Fluttertoast.showToast(msg: 'Search by Barcode');
                            } else if (index == 1) {
                              setState(() {
                                selection[1] = true;
                                selection[0] = false;
                                //change to distributor Pharmacies
                                selectedIndex = 1;
                                searchMedicineTerm = 'Medicine Name';
                              });
                              Fluttertoast.showToast(
                                  msg: 'Search by Medicine Name');
                            }
                          },
                          constraints: BoxConstraints(
                            minHeight: width / 11,
                            minWidth: width / 10,
                          ),
                          children: [
                            Icon(
                              Icons.qr_code_outlined,
                              size: width / 20,
                            ),
                            Icon(
                              Icons.sort_by_alpha_outlined,
                              size: width / 20,
                            ),
                          ],
                          isSelected: selection,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  IndexedStack(
                    index: selectedIndex,
                    children: [
                      _BarcodeResults(
                        height: height,
                        searchTerm: searchMedicineTerm,
                        width: width,
                      ),
                      _NamedResults(
                        height: height,
                        searchMedicineTerm: searchMedicineTerm,
                        width: width,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NamedResults extends StatefulWidget {
  final double height;
  final double width;
  final String searchMedicineTerm;

  _NamedResults({
    this.height,
    this.width,
    this.searchMedicineTerm,
  });

  @override
  __NamedResultsState createState() => __NamedResultsState();
}

class __NamedResultsState extends State<_NamedResults> {
  bool con;
  var snap;
  bool isLoading;
  bool isSearchMedicineed;
  var node;
  String hello = '';
  TextEditingController searchMedicine = TextEditingController();

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
  // get medicine data
  Future queryData(String queryString) async {
    setState(() {
      snap = FirebaseFirestore.instance.collection('MedicineModel').snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    searchMedicine.text = '';
    isSearchMedicineed = false;
    isLoading = false;
    searchMedicine.addListener(() {
      setState(() {
        hello = searchMedicine.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return con == true
        ? Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: widget.height / 3, bottom: 20),
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
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ContainerText(
                    node: node,
                    hint: '${widget.searchMedicineTerm}',
                    controller: searchMedicine,
                    maxLines: 1,
                    width: widget.width / 1.4,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(15),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: widget.width / 7,
                      width: widget.width / 7,
                      child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          checkInternet();
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          if (searchMedicine.text == null ||
                              searchMedicine.text == '') {
                          } else {
                            setState(() {
                              isLoading = true;
                              isSearchMedicineed = true;
                            });
                            queryData(searchMedicine.text.toUpperCase())
                                .whenComplete(() {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              //
              //
              // The container fields
              Container(
                width: widget.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: isSearchMedicineed == false
                      ? Padding(
                          padding: EdgeInsets.only(top: widget.width / 2),
                          child: Center(
                            child: Container(
                              child: Text(
                                'SearchMedicine for a Medicine\nFor the results to appear here',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ),
                        )
                      : StreamBuilder<QuerySnapshot>(
                          stream: snap,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData == false) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length > 6
                                    ? 6
                                    : snapshot.data.docs
                                        .length, //snapshotData.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  QueryDocumentSnapshot item =
                                      snapshot.data.docs[index];
                                  if (item['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains(hello.toLowerCase())) {
                                    return RowInfo(
                                      imageURL: item['imageURL'][0],
                                      location: item['dose'],
                                      width: widget.width,
                                      title: item['name'],
                                      func: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => MedicineModelInfo(
                                              name: item['name'],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          },
                        ),
                ),
              ),
            ],
          );
  }
}

class _BarcodeResults extends StatefulWidget {
  final double height;
  final double width;
  final String searchTerm;

  _BarcodeResults({
    this.height,
    this.width,
    this.searchTerm,
  });

  @override
  __BarcodeResults createState() => __BarcodeResults();
}

class __BarcodeResults extends State<_BarcodeResults> {
  bool con;
  var medicineStream;
  bool isLoading;
  bool isSearched;
  var node;
  String hello = '';
  TextEditingController search = TextEditingController();
  var snap2;
  String imageURL;
  String location;
  String title;
  var medicineModelStream;

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
  // get medicine data
  Future queryData(String queryString) async {
    setState(() {
      medicineStream = FirebaseFirestore.instance
          .collection('Medicine')
          .where('barcode', isEqualTo: queryString)
          .orderBy('name')
          .limit(1)
          .snapshots();
    });
  }

  //
  //
  //get dose and image values
  Future getMedicineModel(String name) async {
    var p = FirebaseFirestore.instance
        .collection('MedicineModel')
        .doc(name)
        .get()
        .then((value) {
      setState(() {
        medicineModelStream = value.data();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    search.text = '';
    isSearched = false;
    isLoading = false;
    search.addListener(() {
      setState(() {
        hello = search.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return con == true
        ? Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: widget.height / 3, bottom: 20),
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
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ContainerText(
                    node: node,
                    hint: '${widget.searchTerm}',
                    controller: search,
                    maxLines: 1,
                    width: widget.width / 1.4,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(15),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: widget.width / 7,
                      width: widget.width / 7,
                      child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          checkInternet();
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          if (search.text == null || search.text == '') {
                          } else {
                            setState(() {
                              isLoading = true;
                              isSearched = true;
                            });
                            queryData(search.text.toUpperCase())
                                .whenComplete(() {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              //
              //
              // The container fields
              Container(
                width: widget.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: isSearched == false
                      ? Padding(
                          padding: EdgeInsets.only(top: widget.width / 2),
                          child: Center(
                            child: Container(
                              child: Text(
                                'Search for a Medicine\nFor the results to appear here',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ),
                        )
                      : StreamBuilder(
                          //barcode
                          stream: medicineStream,
                          builder: (BuildContext context,
                              AsyncSnapshot medicineSnapshot) {
                            if (medicineSnapshot.hasData == false) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: medicineSnapshot.data.docs
                                    .length, //snapshotData.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  QueryDocumentSnapshot medicineSnap =
                                      medicineSnapshot.data.docs[index];

                                  if (medicineSnap['barcode']
                                          .toString()
                                          .toLowerCase()
                                          .allMatches(hello.toLowerCase()) !=
                                      null) {
                                    getMedicineModel(medicineSnap['name']);
                                    if (medicineModelStream == null) {
                                      return CircularProgressIndicator();
                                    }
                                    return RowInfo(
                                      imageURL: medicineModelStream['imageURL']
                                                  [0] ==
                                              null
                                          ? 'https://i0.wp.com/www.cssscript.com/wp-content/uploads/2015/11/ispinner.jpg?fit=400%2C298&ssl=1'
                                          : medicineModelStream['imageURL'][0],
                                      location: medicineModelStream['dose'],
                                      width: widget.width,
                                      title: medicineSnap['name'],
                                      func: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => MedicineInfo(
                                              medBarcode:
                                                  medicineSnap['barcode'],
                                              medName: medicineSnap['name'],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          },
                        ),
                ),
              ),
            ],
          );
  }
}
