import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tracker_admin/Widgets/Distributor/BarChartDaily_Distributor.dart';
import 'package:tracker_admin/Widgets/Distributor/BarChartMonthly_Distributor.dart';
import 'package:tracker_admin/Widgets/Distributor/BarChartWeekly_Distributor.dart';
import 'package:tracker_admin/Widgets/PopupCard.dart';
import 'package:tracker_admin/Widgets/PopupCard_Distributor.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/configs/HeroDialogRoute.dart';
import 'package:tracker_admin/models/Daily.dart';
import 'package:tracker_admin/models/Monthly.dart';
import 'package:tracker_admin/models/Weekly.dart';
import 'package:tracker_admin/screens/MedicineInfo_WithoutBarcode.dart';
import 'package:tracker_admin/screens/distributor_screens/Clinics/AddClinic.dart';
import 'package:tracker_admin/screens/distributor_screens/Clinics/SearchClinics.dart';
import 'package:tracker_admin/screens/distributor_screens/Pharmacies/AddPharmacy.dart';
import 'package:tracker_admin/screens/distributor_screens/Clinics/Clinics_Distributor.dart';
import 'package:tracker_admin/screens/distributor_screens/MedicineSearch_Distributor.dart';
import 'package:tracker_admin/screens/StartingPage.dart';
import 'package:tracker_admin/screens/distributor_screens/DistributorHistory.dart';
import 'package:tracker_admin/screens/distributor_screens/Pharmacies/Pharmacies_Distributor.dart';
import 'package:tracker_admin/screens/distributor_screens/Pharmacies/SearchPharmacies.dart';
import 'package:tracker_admin/screens/distributor_screens/Requests.dart';
import 'package:tracker_admin/screens/ViewMedicine.dart';
import 'package:tracker_admin/screens/distributor_screens/SelectMedicineModel.dart';
import 'package:tracker_admin/screens/distributor_screens/ViewTopMedicine.dart';
import 'package:tracker_admin/screens/distributor_screens/pharmacist/SearchPharmacist.dart';
import 'package:tracker_admin/screens/distributor_screens/pharmacist/SelectPharmacy.dart';
import 'package:tracker_admin/screens/distributor_screens/pharmacist/ViewPharmacists.dart';

class Dashboard_Distributor extends StatefulWidget {
  final String distCompName;

  Dashboard_Distributor({Key key, this.distCompName}) : super(key: key);

  @override
  _Dashboard_DistributorState createState() => _Dashboard_DistributorState();
}

class _Dashboard_DistributorState extends State<Dashboard_Distributor> {
  double width;
  double height;
  double density;
  double safePadding;
  int index;
  Color col = Color.fromARGB(255, 148, 210, 146);
  Color floatingButtonColor = Color.fromARGB(255, 110, 200, 110);
  int selectedIndex;
  double opac;
  double opac2;
  int count;
  int pharmacistCount;
  int medCount;
  int pharmCount;
  int clinicCount;
  bool con;
  var subscription;
  var medID;
  var medName;
  Monthly month = Monthly();
  Weekly week = Weekly();
  Daily day = Daily();

  //
  //
  // the function to get sales numbers of the monthly graph
  Future getSalesNumberMonthly() {
    try {
      FirebaseFirestore.instance
          .collection('Sales')
          .orderBy('timestamp', descending: true)
          .where('timestamp',
              isGreaterThanOrEqualTo:
                  Timestamp.fromDate(DateTime(DateTime.now().year)))
          .where('under', isEqualTo: FirebaseAuth.instance.currentUser.email)
          .snapshots()
          .listen((event) {
        event.docs.forEach((element) {
          DateTime date = (element.data()['timestamp'] as Timestamp).toDate();
          //switch case for performance
          //adds 1 to the month if there was a transaction in that month
          switch (date.month) {
            case 1:
              {
                month.january++;
              }
              break;
            case 2:
              {
                month.febuary++;
              }
              break;
            case 3:
              {
                month.march++;
              }
              break;
            case 4:
              {
                month.april++;
              }
              break;
            case 5:
              {
                month.may++;
              }
              break;
            case 6:
              {
                month.june++;
              }
              break;
            case 7:
              {
                month.july++;
              }
              break;
            case 8:
              {
                month.august++;
              }
              break;
            case 9:
              {
                month.september++;
              }
              break;
            case 10:
              {
                month.october++;
              }
              break;
            case 11:
              {
                month.november++;
              }
              break;
            case 12:
              {
                month.december++;
              }
              break;
            default:
              {
                print("Invalid choice");
              }
              break;
          }
        });
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  //
  //
  // the function to get sales numbers of the weekly graph
  Future getSalesNumberWeekly() {
    try {
      FirebaseFirestore.instance
          .collection('Sales')
          .orderBy('timestamp', descending: true)
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                  DateTime(DateTime.now().year, DateTime.now().month)))
          .where('under', isEqualTo: FirebaseAuth.instance.currentUser.email)
          .snapshots()
          .listen((event) {
        event.docs.forEach((element) {
          DateTime date = (element.data()['timestamp'] as Timestamp).toDate();
          //adds 1 to the week if there was a transaction in that week
          if (date.day >= 1 && date.day <= 7) {
            week.first++;
          } else if (date.day >= 8 && date.day <= 14) {
            week.second++;
          } else if (date.day >= 15 && date.day <= 21) {
            week.third++;
          } else if (date.day >= 22 && date.day <= 31) {
            week.fourth++;
          }
        });
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  //
  //
  // the function to get sales numbers of the daily graph
  Future getSalesNumberDaily() {
    try {
      FirebaseFirestore.instance
          .collection('Sales')
          .orderBy('timestamp', descending: true)
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday - 1))))
          .where('under', isEqualTo: FirebaseAuth.instance.currentUser.email)
          .snapshots()
          .listen((event) {
        event.docs.forEach((element) {
          DateTime date = (element.data()['timestamp'] as Timestamp).toDate();
          //switch case for better performance
          //adds 1 to the day if there was a transaction in that day
          switch (date.weekday) {
            case 1:
              {
                day.monday++;
              }
              break;
            case 2:
              {
                day.tuesday++;
              }
              break;
            case 3:
              {
                day.wednesday++;
              }
              break;
            case 4:
              {
                day.thursday++;
              }
              break;
            case 5:
              {
                day.friday++;
              }
              break;
            case 6:
              {
                day.saturday++;
              }
              break;
            case 7:
              {
                day.sunday++;
              }
              break;
            default:
              {
                print("Invalid choice");
              }
              break;
          }
        });
      });
    } on Exception catch (e) {
      print(e);
    }
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
  // Sign out and go to starting page
  signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: 'Distributor Signed Out');
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => StartingPage(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // FUNCTION TO GET THE REQUESTS STREAM
  getMedRequests() async {
    try {
      FirebaseFirestore.instance
          .collection('RequestsMedicine')
          .snapshots()
          .listen((event) {
        setState(() {
          count = event.docs.length;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // FUNCTION TO GET THE PHARMACIST COUNT
  getPharmacists() async {
    try {
      FirebaseFirestore.instance
          .collection('Pharmacist')
          .snapshots()
          .listen((event) {
        setState(() {
          pharmacistCount = event.docs.length;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // FUNCTION TO GET THE PHARMACY COUNT
  getPharmacy() async {
    try {
      FirebaseFirestore.instance
          .collection('Pharmacy')
          .snapshots()
          .listen((event) {
        setState(() {
          pharmCount = event.docs.length;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // FUNCTION TO GET THE CLINIC COUNT
  getClinic() async {
    try {
      FirebaseFirestore.instance
          .collection('Clinic')
          .snapshots()
          .listen((event) {
        setState(() {
          clinicCount = event.docs.length;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // FUNCTION TO GET THE MEDICINE COUNT
  getMedicine() async {
    try {
      FirebaseFirestore.instance
          .collection('Medicine')
          .snapshots()
          .listen((event) {
        setState(() {
          medCount = event.docs.length;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  @override
  void initState() {
    super.initState();
    medID = '';
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkInternet();
    });
    checkInternet();
    opac = 1;
    opac2 = 0;
    index = 0;
    selectedIndex = 0;
    getMedicine();
    getClinic();
    getPharmacy();
    getPharmacists();
    getMedRequests();
    getSalesNumberMonthly();
    getSalesNumberWeekly();
    getSalesNumberDaily();
  }

  void dispose() {
    super.dispose();
  }

//
//
// The main widget and the bottom navigation bar
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    density = width * height;
    safePadding = MediaQuery.of(context).padding.top;
    return Container(
      height: height,
      width: width,
      child: WillPopScope(
        onWillPop: () {
          return showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Close Dashboard?'),
              content: Text(
                  'Closing the dashboard means you will be logged out of your account'),
              actions: [
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.pop(context);
                    signOut();
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
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              bottom: 20,
              left: width / 5.8,
              right: width / 5.8,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10,
                ),
                child: GNav(
                  mainAxisAlignment: MainAxisAlignment.center,
                  haptic: true,
                  rippleColor: col,
                  hoverColor: col,
                  gap: 8,
                  activeColor: floatingButtonColor,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[100],
                  tabs: [
                    GButton(
                      icon: LineIcons.userShield,
                      text: 'Dashboard',
                      onPressed: () {},
                    ),
                    GButton(
                      icon: LineIcons.stethoscope,
                      text: 'Statistics',
                      onPressed: () {},
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      selectedIndex = index;
                      if (index == 0) {
                        opac = 1;
                        opac2 = 0;
                      } else {
                        opac = 0;
                        opac2 = 1;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 246, 246, 248),
          body: Container(
            height: height,
            width: width,
            child: IndexedStack(
              index: selectedIndex,
              children: <Widget>[
                AnimatedOpacity(
                  opacity: opac,
                  duration: Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: DistributorDashboard(
                        width: width,
                        height: height,
                        clinicCount: clinicCount,
                        count: count,
                        medCount: medCount,
                        pharmCount: pharmCount,
                        pharmacistCount: pharmacistCount,
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: opac2,
                  duration: Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: DistributorStatistics(
                        width: width,
                        height: height,
                        count: count,
                        distCompName: widget.distCompName,
                        //monthly start
                        january: month.january,
                        febuary: month.febuary,
                        march: month.march,
                        april: month.april,
                        may: month.may,
                        june: month.june,
                        july: month.july,
                        august: month.august,
                        september: month.september,
                        october: month.october,
                        november: month.november,
                        december: month.december,
                        //monthly end

                        //weekly start
                        first: week.first,
                        second: week.second,
                        third: week.third,
                        fourth: week.fourth,
                        //weekly end

                        //daily start
                        monday: day.monday,
                        tuesday: day.tuesday,
                        wednesday: day.wednesday,
                        thursday: day.thursday,
                        friday: day.friday,
                        saturday: day.saturday,
                        sunday: day.sunday,
                        //daily end
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
//
//
// The Dhasboard part of the admin console
class DistributorDashboard extends StatefulWidget {
  final double width;
  final double height;
  final int count;
  final int pharmacistCount;
  final int pharmCount;
  final int clinicCount;
  final int medCount;

  DistributorDashboard({
    Key key,
    @required this.width,
    @required this.height,
    this.count,
    this.pharmacistCount,
    this.pharmCount,
    this.clinicCount,
    this.medCount,
  }) : super(key: key);

  @override
  _DistributorDashboardState createState() => _DistributorDashboardState();
}

class _DistributorDashboardState extends State<DistributorDashboard> {
  Color col = Color.fromARGB(255, 148, 210, 146);
  bool con = true;
  var subscription;

  //
  //
  //check  the internet connectivity
  checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult.toString());
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

  @override
  void initState() {
    super.initState();
    checkInternet();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkInternet();
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: (widget.width / 15),
          ),
          //
          //
          // The top title and the notification row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'DASHBOARD',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.width / 17,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                width: widget.width / 7,
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      height: widget.width / 9,
                      width: widget.width / 9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Requests(),
                            ),
                          );
                        },
                        padding: const EdgeInsets.all(0),
                        child: Icon(
                          Icons.notifications_none,
                        ),
                      ),
                    ),
                  ),
                  widget.count == 0
                      ? Container()
                      : Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            height: widget.width / 18,
                            width: widget.width / 18,
                            decoration: BoxDecoration(
                              color: Colors.red[400],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                widget.count.toString() == 'null'
                                    ? '!'
                                    : widget.count.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          //
          //
          // The first Medicine Container
          Center(
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medicine',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.width / 16,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Authenticated Medicine:',
                          style: TextStyle(
                            fontSize: widget.width / 30,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Container(
                          width: widget.width / 15,
                          height: widget.width / 20,
                          decoration: BoxDecoration(
                            color: col,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              widget.medCount.toString() == 'null'
                                  ? '!'
                                  : widget.medCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.width / 30,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //
                    //
                    // The buttons
                    Wrap(
                      spacing: 15,
                      children: [
                        //
                        //
                        // The first ADD DISTRIBUTOR button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SelectMedicineModel(),
                                ),
                              );
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Image(
                                  width: widget.width / 4.9,
                                  height: widget.width / 4.6,
                                  image: AssetImage(
                                    'assets/icons/Distributor_dashboard_medicine/addMedicine.png',
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: col,
                              ),
                            ),
                          ),
                        ),
                        //
                        //
                        // The second SEARCH MEDICINE Button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewMedicine(
                                  pageName: 'View Medicine',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                width: widget.width / 4.9,
                                height: widget.width / 4.6,
                                image: AssetImage(
                                  'assets/icons/Distributor_dashboard_medicine/viewMedicine.png',
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MedicineSearch_Distributor(),
                              ),
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                width: widget.width / 4.9,
                                height: widget.width / 4.6,
                                image: AssetImage(
                                  'assets/icons/Distributor_dashboard_medicine/searchMedicine.png',
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          //
          //
          // The second PHARMACIES AND CLINICS container
          Center(
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pharmacies and Clinics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.width / 16,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pharmacies:',
                          style: TextStyle(
                            fontSize: widget.width / 30,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Container(
                          width: widget.width / 15,
                          height: widget.width / 20,
                          decoration: BoxDecoration(
                            color: col,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              widget.pharmCount.toString() == 'null'
                                  ? '!'
                                  : widget.pharmCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.width / 30,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Clinics:',
                          style: TextStyle(
                            fontSize: widget.width / 30,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Container(
                          width: widget.width / 15,
                          height: widget.width / 20,
                          decoration: BoxDecoration(
                            color: col,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              widget.clinicCount.toString() == 'null'
                                  ? '!'
                                  : widget.clinicCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.width / 30,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //
                    //
                    // The buttons
                    Wrap(
                      spacing: 15,
                      children: [
                        //
                        //
                        // The first VIEW CLINICS button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Clinics_Distributors(),
                                ),
                              );
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Image(
                                  width: widget.width / 4.9,
                                  height: widget.width / 4.6,
                                  image: AssetImage(
                                      'assets/icons/Distributor_dashboard_pharmacy/viewClinics.png'),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: col,
                              ),
                            ),
                          ),
                        ),
                        //
                        //
                        // The second ADD CLINICS Button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddClinic(),
                              ),
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                width: widget.width / 4.9,
                                height: widget.width / 4.6,
                                image: AssetImage(
                                    'assets/icons/Distributor_dashboard_pharmacy/addClinic.png'),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
                        //
                        //
                        // The third View Pharmacies
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Pharmacies_Distributor(),
                              ),
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                width: widget.width / 4.9,
                                height: widget.width / 4.6,
                                image: AssetImage(
                                    'assets/icons/Distributor_dashboard_pharmacy/viewPharmacy.png'),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddPharmacy(),
                              ),
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                width: widget.width / 4.9,
                                height: widget.width / 4.6,
                                image: AssetImage(
                                    'assets/icons/Distributor_dashboard_pharmacy/addPharmacy.png'),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SearchPharmacies(),
                              ),
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                width: widget.width / 4.9,
                                height: widget.width / 4.6,
                                image: AssetImage(
                                    'assets/icons/Distributor_dashboard_pharmacy/searchPharmacy.png'),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SearchClinics(),
                              ),
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                width: widget.width / 4.9,
                                height: widget.width / 4.6,
                                image: AssetImage(
                                    'assets/icons/Distributor_dashboard_pharmacy/searchClinic.png'),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          //
          //
          // The first Medicine Container
          Center(
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pharmacist',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.width / 16,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Number of Pharmacists:',
                          style: TextStyle(
                            fontSize: widget.width / 30,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Container(
                          width: widget.width / 15,
                          height: widget.width / 20,
                          decoration: BoxDecoration(
                            color: col,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              widget.pharmacistCount.toString() == 'null'
                                  ? '!'
                                  : widget.pharmacistCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.width / 30,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //
                    //
                    // The buttons
                    Wrap(
                      spacing: 15,
                      children: [
                        //
                        //
                        // The first ADD DISTRIBUTOR button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SelectPharmacy(),
                                ),
                              );
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Image(
                                  width: widget.width / 4.9,
                                  height: widget.width / 4.6,
                                  image: AssetImage(
                                    'assets/icons/Distributor_dashboard_pharmacist/addPharmacist.png',
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: col,
                              ),
                            ),
                          ),
                        ),
                        //
                        //
                        // The second SEARCH MEDICINE Button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewPharmacists(
                                  pageName: 'View Pharmacists',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                width: widget.width / 4.9,
                                height: widget.width / 4.6,
                                image: AssetImage(
                                  'assets/icons/Distributor_dashboard_pharmacist/viewPharmacist.png',
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SearchPharmacist(),
                              ),
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                width: widget.width / 4.9,
                                height: widget.width / 4.6,
                                image: AssetImage(
                                  'assets/icons/Distributor_dashboard_pharmacist/searchPharmacist.png',
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
        ],
      ),
    );
  }
}

//
//
// The STATISTICS PAGE
class DistributorStatistics extends StatefulWidget {
  final double width;
  final double height;
  final int count;
  final String distCompName;
  //The Monthly variables
  int january;
  int febuary;
  int march;
  int april;
  int may;
  int june;
  int july;
  int august;
  int september;
  int october;
  int november;
  int december;
  //Monthly variables end

  //The weekly variables
  int first;
  int second;
  int third;
  int fourth;
  //Weekly variables end

  //The daily variables
  int monday;
  int tuesday;
  int wednesday;
  int thursday;
  int friday;
  int saturday;
  int sunday;
  //the daily variables end

  DistributorStatistics({
    Key key,
    @required this.width,
    @required this.height,
    this.count,
    this.distCompName,
    //month start
    this.march,
    this.april,
    this.august,
    this.december,
    this.febuary,
    this.january,
    this.july,
    this.june,
    this.may,
    this.november,
    this.october,
    this.september,
    //month end

    //week start
    this.first,
    this.second,
    this.third,
    this.fourth,
    //week end

    //day start
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    //day end
  }) : super(key: key);

  @override
  _DistributorStatisticsState createState() => _DistributorStatisticsState();
}

class _DistributorStatisticsState extends State<DistributorStatistics> {
  Color col = Color.fromARGB(255, 148, 210, 146);
  var distributorStream;
  bool con = true;
  var subscription;
  var basicMedStream;
  var historyStream;
  var med;

  //
  //
  //check  the internet connectivity
  checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult.toString());
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

  getTopMedicineName() async {
    try {
      setState(() {
        basicMedStream = FirebaseFirestore.instance
            .collection('MedicineModel')
            .orderBy('totalSales', descending: true)
            .limit(5)
            .snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  getHistory() async {
    try {
      setState(() {
        historyStream = FirebaseFirestore.instance
            .collection('History')
            .where('category', whereIn: ['distributor', 'pharmacist'])
            .where('byCompany', isEqualTo: widget.distCompName)
            .orderBy('timestamp', descending: true)
            .limit(5)
            .snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getTopMedicineName();
    getHistory();
    checkInternet();
    getTopMedicineName();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkInternet();
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: (widget.width / 15),
          ),

          //
          //
          // The top title and the notification icon
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'STATISTICS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.width / 17,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                width: widget.width / 7,
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      height: widget.width / 9,
                      width: widget.width / 9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Requests(),
                            ),
                          );
                        },
                        padding: const EdgeInsets.all(0),
                        child: Icon(
                          Icons.notifications_none,
                        ),
                      ),
                    ),
                  ),
                  widget.count == 0 || widget.count == null
                      ? Container()
                      : Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            height: widget.width / 18,
                            width: widget.width / 18,
                            decoration: BoxDecoration(
                              color: Colors.red[400],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                widget.count.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          //
          //
          // The first MEDICINE DISTRIBUTION AND GRAPHS
          Center(
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Medcine Distribution',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widget.width / 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: widget.height < 800 ? 200 : widget.height / 4,
                      child: con == true
                          ? Center(
                              child: Text('No Internet'),
                            )
                          : ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: widget.width / 1.7,
                                  decoration: BoxDecoration(
                                    color: col,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      bottom: 10,
                                      top: 15,
                                    ),
                                    child: BarChartMonthly_Distributor(
                                      width: widget.width,
                                      jan: widget.january,
                                      feb: widget.febuary,
                                      mar: widget.march,
                                      apr: widget.april,
                                      may: widget.may,
                                      jun: widget.june,
                                      jul: widget.july,
                                      aug: widget.august,
                                      sep: widget.september,
                                      oct: widget.october,
                                      nov: widget.november,
                                      dec: widget.december,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: widget.width / 2.5,
                                  decoration: BoxDecoration(
                                    color: col,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      bottom: 10,
                                      top: 15,
                                    ),
                                    child: BarChartWeekly_Distributor(
                                      width: widget.width,
                                      first: widget.first,
                                      second: widget.second,
                                      third: widget.third,
                                      fourth: widget.fourth,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: widget.width / 2.5,
                                  decoration: BoxDecoration(
                                    color: col,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      bottom: 10,
                                      top: 15,
                                    ),
                                    child: BarChartDaily_Distributor(
                                      width: widget.width,
                                      mon: widget.monday,
                                      tues: widget.tuesday,
                                      wed: widget.wednesday,
                                      thurs: widget.thursday,
                                      fri: widget.friday,
                                      sat: widget.saturday,
                                      sun: widget.sunday,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),

          //
          //
          // The History pane
          Center(
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: con == true ? Colors.grey[200] : Colors.white,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'History',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.width / 16,
                          ),
                        ),
                        Container(
                          width: 65,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 148, 210, 146),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(0),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DistributorHistory(),
                                ),
                              );
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: widget.height / 40,
                    ),
                    con == true
                        ? Center(
                            child: Container(
                              width: widget.width / 6,
                              height: widget.width / 6,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: historyStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData == false) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  QueryDocumentSnapshot item =
                                      snapshot.data.docs[index];
                                  return Hero(
                                    tag: item['timestamp'].toString(),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.white,
                                      child: RowInfo(
                                        imageURL: item['image'] == ''
                                            ? 'https://www.spicefactors.com/wp-content/uploads/default-user-image.png'
                                            : item['image'],
                                        location: DateFormat.yMMMd()
                                            .add_jm()
                                            .format(item['timestamp'].toDate()),
                                        width: widget.width,
                                        title: item['name'],
                                        func: () {
                                          Navigator.of(context).push(
                                              HeroDialogRoute(
                                                  builder: (context) {
                                            return PopupCard_Distributor(
                                              tag: item['timestamp'].toString(),
                                              by: item['by'].toString(),
                                              dateTime: DateFormat.yMMMd()
                                                  .add_jm()
                                                  .format(item['timestamp']
                                                      .toDate())
                                                  .toString(),
                                              image: item['image'],
                                              name: item['name'],
                                            );
                                          }));
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          //
          //
          // The second TOP DISTRIBUTORS
          Center(
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: con == true ? Colors.grey[200] : Colors.white,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Medicine',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.width / 16,
                          ),
                        ),
                        Container(
                          width: 65,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 148, 210, 146),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(0),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewTopMedicine(
                                      pageName: 'View Top Medicine'),
                                ),
                              );
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: widget.height / 40,
                    ),
                    con == true
                        ? Center(
                            child: Container(
                              width: widget.width / 6,
                              height: widget.width / 6,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: basicMedStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData == false) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  QueryDocumentSnapshot item =
                                      snapshot.data.docs[index];
                                  return RowInfo(
                                    imageURL: item['imageURL'][0] == ''
                                        ? 'https://www.spicefactors.com/wp-content/uploads/default-user-image.png'
                                        : item['imageURL'][0],
                                    location: 'Sales: ' +
                                        item['totalSales'].toString(),
                                    width: widget.width,
                                    title: item['name'],
                                    func: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              MedicineInfo_WithoutBarcode(
                                            name: item['name'],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
