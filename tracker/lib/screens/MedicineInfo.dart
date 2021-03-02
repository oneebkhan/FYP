import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MedicineInfo extends StatefulWidget {
  final String medicineName;
  final List<String> imageUrls;
  final String description;
  final int price;
  final String quant;
  final bool authentic;
  final String barcode;
  final List<String> sideEffects;
  final List<String> distributors;
  final List<String> pharmacies;
  final String manufacturer;
  final List<String> use;
  final String dose;

  MedicineInfo({
    Key key,
    this.medicineName,
    this.imageUrls,
    this.description,
    this.price,
    this.quant,
    this.authentic,
    this.barcode,
    this.sideEffects,
    this.distributors,
    this.pharmacies,
    this.manufacturer,
    this.use,
    this.dose,
  }) : super(key: key);

  @override
  _MedicineInfoState createState() => _MedicineInfoState();
}

class _MedicineInfoState extends State<MedicineInfo> {
  double width;
  double height;
  double safePadding;

  double opac;
  //opacity of the image;
  double opac2;
  //The index of the pages
  int index;

  @override
  void initState() {
    super.initState();
    opac = 0;
    opac2 = 0;
    index = 0;

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        opac = 1.0;
      });
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        opac2 = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    var page = PageController(initialPage: 0);
    var page2 = PageController(initialPage: 0);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
        children: [
          Stack(
            children: [
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: opac,
                child: PageView(
                  controller: page2,
                  children: [
                    Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.dstATop),
                          fit: BoxFit.fitWidth,
                          image: CachedNetworkImageProvider(
                            'https://i-cf5.gskstatic.com/content/dam/cf-consumer-healthcare/panadol/en_ie/ireland-products/panadol-tablets/MGK5158-GSK-Panadol-Tablets-455x455.png?auto=format',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.dstATop),
                          fit: BoxFit.fitWidth,
                          image: CachedNetworkImageProvider(
                            'https://pentagonenterprises.com/wp-content/uploads/2020/11/panadol-600x600.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                          Text(
                            'Panadol',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width / 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          //
                          //
                          // The Green tick for medicine authentication
                          Container(
                            child: Icon(
                              Icons.check_circle,
                              size: width / 13,
                              color: Color.fromARGB(255, 130, 255, 159),
                            ),
                          ),
                        ],
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
                              'Price:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rs. 100/500mg Leaf',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 22,
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
                              'Doses:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '500/1000 mg',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      IconButton(
                        iconSize: width / 10,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
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
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: width / 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'A simple pain relief medicine meant to be taken with water. Can cure headaches or body aches with relative ease. Meant to be taken after a meal, the usual dosage being 2 tablets of 500mg for an average adult.',
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
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 50, 50, 50),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
