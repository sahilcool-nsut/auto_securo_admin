import 'package:flutter/material.dart';

import 'globals.dart';

class LinkVehicle extends StatefulWidget {
  @override
  _LinkVehicleState createState() => _LinkVehicleState();
}

class _LinkVehicleState extends State<LinkVehicle> {

  TextEditingController _numberPlateController;
  TextEditingController _mobileNumberController;
  bool _showError = false;
  bool _showConfirmation = false;
  bool _loading = false;
  bool _noUserExists = false;


  @override
  void initState() {
    _numberPlateController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar,
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height:50),
                  Text("Link Vehicle",style: TextStyle(fontSize:17,fontWeight: FontWeight.bold),),
                  SizedBox(height:30),
                  Text("Vehicle Number: ",style: TextStyle(fontSize:16,fontWeight: FontWeight.w300),),
                  SizedBox(height:20),
                  TextFormField(

                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      labelText: 'Number Plate',

                      hintStyle: TextStyle(color:Colors.black.withOpacity(0.2)),
                    ),
                    controller: _numberPlateController,
                  ),
                  SizedBox(height:20),
                  Text("Mobile Number: ",style: TextStyle(fontSize:16,fontWeight: FontWeight.w300),),
                  SizedBox(height:20),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      labelText: 'Owner Mobile Number',
                      hintStyle: TextStyle(color:Colors.black.withOpacity(0.2)),
                    ),
                    controller: _mobileNumberController,
                  ),
                  SizedBox(height:30),
                  Visibility(
                    visible: _showError,
                    child: Text("No User Found!",style: TextStyle(color: Colors.red.shade400),),
                  ),
                  Visibility(
                    visible: _showConfirmation,
                    child: Text("Vehicle Linked!",style: TextStyle(color: Colors.green),),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _loading = true;
                      });
                      //Check if user account exists (traverse through collections)
                      if(_noUserExists)
                      {
                        setState(() {
                          _loading = false;
                          _showError = true;
                        });
                      }
                      else
                      {
                        // Link Vehicle -> Add vehicle in user collection, and in vehicle collection, add user mobile number with tag owner = true
                        setState(() {
                          _loading = false;
                          _showConfirmation = true;
                        });

                      }

                    },
                    child: Container(
                      margin: EdgeInsets.all(32),
                      padding: EdgeInsets.all(16),
                      child: _loading
                          ? Center(
                        child: Transform.scale(
                          scale: 0.6,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        ),
                      )
                          : Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 0,
                          ),
                          Text('Link Vehicle',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18)),
                          Icon(
                            Icons.arrow_right_alt,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color:  Colors.red,
                          borderRadius: BorderRadius.circular(7)),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Image(
                        image: AssetImage("images/requestPNG.png"),
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: double.infinity,
                      ),
                    ),
                  ),

                ],
              ),
            )
        ),
      ),
    );
  }
}
