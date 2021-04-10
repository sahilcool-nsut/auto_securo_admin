import 'package:auto_securo_admin/VehicleInfo.dart';
import 'package:auto_securo_admin/components/history_preview.dart';
import 'package:auto_securo_admin/globals.dart';
import 'package:auto_securo_admin/services/database_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool noVehicles = false; //to be checked in initstate
  String societyName; //initialize in initstate
  bool dataLoaded = false;

//filled in init
//  List vehicleList=[new VehicleInfo("Lamborghini", "DL4CAC0001", "Sahil Chawla", DateTime.now().toString()),
//    new VehicleInfo("Jaguar", "888JXJ", "Sahil Chawla", DateTime.now().toString())];
  List<VehicleInfo> vehicleList = [];

  @override
  void initState() {
    societyName = "Chander Nagar, Janakpuri";

    getHistory();

    super.initState();
  }

  Future<void> getHistory() async {
    vehicleList = await DatabaseService().getHistory();
    if (vehicleList.length == 0) {
      setState(() {
        noVehicles = true;
        dataLoaded = true;
      });
    } else {
      setState(() {
        noVehicles = false;
        dataLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: myAppBar,
          body: !dataLoaded
              ? Center(
                  child: Container(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator()))
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                  child: noVehicles
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Montserrat'),
                                  text: 'Society: ',
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: societyName.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("No Vehicle History"),
                                    Container(
                                      child: Center(
                                        child: Image(
                                          image: AssetImage(
                                              "images/no_historyPNG.png"),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat'),
                                    text: 'Society: ',
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: societyName.toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: vehicleList.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                         HistoryPreview(
                                             startTime: vehicleList[index]
                                                 .timeStamp,
                                             username: vehicleList[index]
                                                 .userName,
                                             vehicleNo: vehicleList[index]
                                                 .numberPlate,
                                             vehicleName: vehicleList[index]
                                                 .name,
                                             vehicleOwner:vehicleList[index]
                                                 .ownerName),
//                                        SizedBox(
//                                            height: MediaQuery.of(context)
//                                                    .size
//                                                    .height *
//                                                0.03),
//                                        SizedBox(
//                                            height: MediaQuery.of(context)
//                                                    .size
//                                                    .height *
//                                                0.02),
//                                        Center(
//                                          child: Padding(
//                                            padding: EdgeInsets.symmetric(
//                                                horizontal: 16.0),
//                                            child: Divider(
//                                              height: 2,
//                                              thickness: 2.5,
//                                              color: Colors.black,
//                                            ),
//                                          ),
//                                        ),
//                                        SizedBox(
//                                            height: MediaQuery.of(context)
//                                                    .size
//                                                    .height *
//                                                0.04),
//                                        FittedBox(
//                                          fit: BoxFit.scaleDown,
//                                          child: RichText(
//                                            textAlign: TextAlign.center,
//                                            text: TextSpan(
//                                              text: 'User: ',
//                                              style: TextStyle(
//                                                  color: Colors.black,
//                                                  fontFamily: 'Montserrat',
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize: 17),
//                                              children: <TextSpan>[
//                                                TextSpan(
//                                                    text: vehicleList[index]
//                                                        .userName,
//                                                    style: TextStyle(
//                                                        fontWeight:
//                                                            FontWeight.normal,
//                                                        fontSize: 17)),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                        SizedBox(
//                                            height: MediaQuery.of(context)
//                                                    .size
//                                                    .height *
//                                                0.04),
//                                        FittedBox(
//                                          fit: BoxFit.scaleDown,
//                                          child: RichText(
//                                            textAlign: TextAlign.center,
//                                            text: TextSpan(
//                                              text: 'Vehicle: ',
//                                              style: TextStyle(
//                                                  color: Colors.black,
//                                                  fontFamily: 'Montserrat',
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize: 17),
//                                              children: <TextSpan>[
//                                                TextSpan(
//                                                    text:
//                                                        vehicleList[index].name,
//                                                    style: TextStyle(
//                                                        fontWeight:
//                                                            FontWeight.normal,
//                                                        fontSize: 17)),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                        SizedBox(
//                                            height: MediaQuery.of(context)
//                                                    .size
//                                                    .height *
//                                                0.01),
//                                        FittedBox(
//                                          fit: BoxFit.scaleDown,
//                                          child: RichText(
//                                            textAlign: TextAlign.center,
//                                            text: TextSpan(
//                                              text: 'Vehicle Numberplate: ',
//                                              style: TextStyle(
//                                                  color: Colors.black,
//                                                  fontFamily: 'Montserrat',
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize: 17),
//                                              children: <TextSpan>[
//                                                TextSpan(
//                                                    text: vehicleList[index]
//                                                        .numberPlate,
//                                                    style: TextStyle(
//                                                        fontWeight:
//                                                            FontWeight.normal,
//                                                        fontSize: 17)),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                        SizedBox(
//                                            height: MediaQuery.of(context)
//                                                    .size
//                                                    .height *
//                                                0.01),
//                                        FittedBox(
//                                          fit: BoxFit.scaleDown,
//                                          child: RichText(
//                                            textAlign: TextAlign.center,
//                                            text: TextSpan(
//                                              text: 'Owner Name: ',
//                                              style: TextStyle(
//                                                  color: Colors.black,
//                                                  fontFamily: 'Montserrat',
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize: 17),
//                                              children: <TextSpan>[
//                                                TextSpan(
//                                                    text: vehicleList[index]
//                                                        .ownerName,
//                                                    style: TextStyle(
//                                                        fontWeight:
//                                                            FontWeight.normal,
//                                                        fontSize: 17)),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                        SizedBox(
//                                            height: MediaQuery.of(context)
//                                                    .size
//                                                    .height *
//                                                0.01),
//                                        FittedBox(
//                                          fit: BoxFit.scaleDown,
//                                          child: RichText(
//                                            textAlign: TextAlign.center,
//                                            text: TextSpan(
//                                              text: 'Date and Time: ',
//                                              style: TextStyle(
//                                                  color: Colors.black,
//                                                  fontFamily: 'Montserrat',
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize: 17),
//                                              children: <TextSpan>[
//                                                TextSpan(
//                                                    text: formatDate(
//                                                        DateTime.now(), [
//                                                      dd,
//                                                      '/',
//                                                      mm,
//                                                      '/',
//                                                      yyyy,
//                                                      ', ',
//                                                      HH,
//                                                      ':',
//                                                      nn,
//                                                    ]).toString(),
//                                                    style: TextStyle(
//                                                        fontWeight:
//                                                            FontWeight.normal,
//                                                        fontSize: 17)),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                )),
    );
  }
}
