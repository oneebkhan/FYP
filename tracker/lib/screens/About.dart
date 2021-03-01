import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker/screens/RequestMedicine.dart';
import 'package:fluttertoast/fluttertoast.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  var width;
  var height;
  var safePadding;
  var anim;

  double opac;
  @override
  void initState() {
    super.initState();
    opac = 0;
    anim = false;

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac = 1.0;
        anim = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 246, 246, 248),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: safePadding + 20,
            ),
            //
            //
            // The about picture
            AnimatedOpacity(
              opacity: opac,
              duration: Duration(milliseconds: 500),
              child: Center(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Container(
                        height: width / 3.5,
                        width: width / 3.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Container(
                        height: width / 3,
                        child: Lottie.asset(
                          'assets/lottie/medicine.json',
                          animate: anim,
                          repeat: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            //
            //
            // The first lEAD DEVELOPERS section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          'Lead Developers',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width / 16,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AvatarRow(
                          size: width,
                          name: 'Oneeb Ehsan Khan',
                          bottomName: 'Front-end and Back-end',
                          imageURL: '',
                        ),
                        AvatarRow(
                          size: width,
                          name: 'Zaeem Chaudry',
                          bottomName: 'Front-end',
                          imageURL: '',
                        ),
                        AvatarRow(
                          size: width,
                          name: 'Junaid Iqbal',
                          bottomName: 'Front-end',
                          imageURL: '',
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
            //
            //
            // The second DESIGNER CONTAINER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          'Lead Designers',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width / 16,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AvatarRow(
                          size: width,
                          name: 'Oneeb Ehsan Khan',
                          bottomName: 'Mockup and prototyping',
                          imageURL: '',
                        ),
                        AvatarRow(
                          size: width,
                          name: 'Jeff',
                          bottomName: 'Animations',
                          imageURL: '',
                        ),
                        AvatarRow(
                          size: width,
                          name: 'Bezos',
                          bottomName: 'Animations',
                          imageURL: '',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            //
            //
            // The contact developers button
            Center(
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: 'Not Implemented yet :\'(',
                  );
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
                      'Contact Developers',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //
            //
            // The Request medicine button
            Center(
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RequestMedicine(),
                    ),
                  );
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
                      'Request Medicine',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

//
//
// The rows in teh containers
class AvatarRow extends StatelessWidget {
  final double size;
  final String imageURL;
  final String name;
  final String bottomName;

  const AvatarRow({
    @required this.size,
    this.imageURL,
    @required this.name,
    @required this.bottomName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: size / 17,
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: size / 22,
                ),
              ),
              Text(
                bottomName,
                style: TextStyle(
                  fontSize: size / 28,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}