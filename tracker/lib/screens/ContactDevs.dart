import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tracker/screens/RequestMedicine.dart';

// ignore: must_be_immutable
class ContactDevs extends StatefulWidget {
  @override
  _ContactDevsState createState() => _ContactDevsState();
}

class _ContactDevsState extends State<ContactDevs> {
  double width;
  double height;
  double safePadding;
  bool _isLoading = false;
  int docNum = 1;
  TextEditingController nameOfUser = TextEditingController();
  TextEditingController emailOfUser = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController description = TextEditingController();
  bool con;

  //
  //
  // Get length of documents to make a unique ID for the firestore doca
  // ignore: missing_return
  // FIX THE DISPOSE BUG HERE !!!!!!!!!!!!!!!!!!!!!!!!
  // ignore: missing_return
  Future<double> _getLengthOfContactDevs() async {
    // ignore: await_only_futures
    await FirebaseFirestore.instance
        .collection("ContactDevelopers")
        .snapshots()
        .listen((doc) {
      doc.docs.forEach((element) {
        if (doc.docs.length == 0) {
          setState(() {
            docNum = 1;
          });
        }
        if (docNum <= element['number']) {
          setState(() {
            docNum = element['number'] + 1;
          });
        }
      });
    });
  }

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
  // pressing the submit button will submit all the fields and update firestore
  Future<void> _onPressed() async {
    try {
      // ignore: await_only_futures
      var firestore = await FirebaseFirestore.instance;
      firestore
          .collection("ContactDevelopers")
          .doc('#' + docNum.toString() + ' (${emailOfUser.text})')
          .set({
        "nameOfUser": nameOfUser.text,
        "emailOfUser": emailOfUser.text,
        "subject": subject.text,
        "description": description.text,
        "number": docNum,
      }).then((_) {
        print("success!");
      });
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // Validate the Email Address
  String validateEmail(String value) {
    if (value.isEmpty) {
      Fluttertoast.showToast(msg: 'Enter Email');
      return "enter email";
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      Fluttertoast.showToast(msg: 'Invalid Email Address');
      return "the email address is not valid";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    con = false;
    checkInternet();
    _getLengthOfContactDevs();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    final node = FocusScope.of(context);

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: GestureDetector(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Center(
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Developers',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ContainerText(
                                hint: 'User Name',
                                node: node,
                                controller: nameOfUser,
                                maxLines: 1,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'User Email',
                                node: node,
                                controller: emailOfUser,
                                maxLines: 1,
                                maxLength: 30,
                                inputType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Subject',
                                node: node,
                                controller: subject,
                                maxLines: 2,
                                maxLength: 50,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Description',
                                node: node,
                                height: width / 2,
                                maxLines: 8,
                                controller: description,
                                maxLength: 250,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        if (validateEmail(emailOfUser.text) == null) {
                          checkInternet();
                          if (con == true) {
                            Fluttertoast.showToast(
                                msg: 'No Internet Connection');
                          } else {
                            _onPressed();
                            setState(() {
                              _isLoading = true;
                            });
                            Future.delayed(Duration(milliseconds: 2000), () {
                              Navigator.pop(context);
                            });
                          }
                        }
                      },
                      child: Container(
                        width: width / 1.1,
                        height: width / 8,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 149, 192, 255),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
