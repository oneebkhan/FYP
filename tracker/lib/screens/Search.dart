import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tracker/Widgets/RowInfo.dart';
import 'package:tracker/screens/MedicineInfo.dart';
import 'package:tracker/screens/RequestMedicine.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  double opac;
  TextEditingController search = TextEditingController();
  var snapshotData;
  double height;
  bool isSearched;
  bool isLoading;
  var snap;
  String hello = '';
  bool con;
  List<bool> selection;
  int selectedIndex;
  String searchTerm;

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
      snap = FirebaseFirestore.instance.collection('Medicine').snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    selection = [false, true];
    selectedIndex = 1;
    isSearched = false;
    isLoading = false;
    snapshotData = null;
    searchTerm = 'Medicine Name';
    checkInternet();
    search.addListener(() {
      setState(() {
        hello = search.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
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
                                });
                                Fluttertoast.showToast(
                                    msg: 'Search by Barcode');
                              } else if (index == 1) {
                                setState(() {
                                  selection[1] = true;
                                  selection[0] = false;
                                  //change to distributor Pharmacies
                                  selectedIndex = 1;
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
                    con == true
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
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ContainerText(
                                node: node,
                                hint: '$searchTerm',
                                controller: search,
                                maxLines: 1,
                                width: width / 1.4,
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(15),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  height: width / 7,
                                  width: width / 7,
                                  child: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () {
                                      checkInternet();
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      if (search.text == null ||
                                          search.text == '') {
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
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        child: isSearched == false
                            ? Padding(
                                padding: EdgeInsets.only(top: width / 2),
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
                            : StreamBuilder<QuerySnapshot>(
                                stream: snap,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData == false) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.docs.length > 6
                                          ? 6
                                          : snapshot.data.docs
                                              .length, //snapshotData.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        QueryDocumentSnapshot item =
                                            snapshot.data.docs[index];
                                        if (item['name']
                                                .toString()
                                                .toLowerCase()
                                                .contains(
                                                    hello.toLowerCase()) ||
                                            item['barcode']
                                                .toString()
                                                .toLowerCase()
                                                .contains(
                                                    hello.toLowerCase())) {
                                          return RowInfo(
                                            imageURL: item['imageURL'][0],
                                            location: item['dose'],
                                            width: width,
                                            title: item['name'],
                                            func: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => MedicineInfo(
                                                    medBarcode: item['barcode'],
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
