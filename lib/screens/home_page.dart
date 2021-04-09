import 'package:auto_securo_admin/globals.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool noVehicles = true;     //to be checked in initstate
  String societyName;            //initialize in initstate
  bool dataLoaded = true;

  //All these lists filled in initstate
  List vehicleNames=["Lamborghini","Jaguar"];
  List vehicleNumberplates=["DL4CAC0001","888JXJ"];
  List ownerNames=["Sahil Chawla","Sahil Chawla"];

  @override
  void initState() {
    societyName = "Chander Nagar, Janakpuri";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:myAppBar,
        body:!dataLoaded? Center(child: Container(height:30,width:30,child: CircularProgressIndicator())):Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 36.0),
          child: noVehicles?SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:30),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black,fontFamily: 'Montserrat'),
                    text: 'Society: ',
                    children: <TextSpan>[
                      TextSpan(text: societyName.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height:30),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("No Vehicle History"),
                      Container(
                        child: Center(
                          child: Image(
                            image: AssetImage("images/no_historyPNG.png"),
                            height: MediaQuery.of(context).size.height * 0.4,
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
              :
          Container(),
        )
      ),
    );
  }
}
