import 'dart:io';

import 'package:auto_securo_admin/services/database_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart';

class LinkVehicle extends StatefulWidget {
  @override
  _LinkVehicleState createState() => _LinkVehicleState();
}

class _LinkVehicleState extends State<LinkVehicle> {
  TextEditingController _numberPlateController;
  TextEditingController _mobileNumberController;
  TextEditingController _vehicleNameController;
  bool _showError = false;
  bool _showConfirmation = false;
  bool _loading = false;
  bool _userExists = false;
  String _photoURL;

  @override
  void initState() {
    _numberPlateController = new TextEditingController();
    _mobileNumberController = new TextEditingController();
    _vehicleNameController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Link Vehicle'),
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Vehicle Number: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      labelText: 'Number Plate',
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.2)),
                    ),
                    controller: _numberPlateController,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Mobile Number: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      labelText: 'Owner Mobile Number',
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.2)),
                    ),
                    controller: _mobileNumberController,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Vehicle Name: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      labelText: 'Enter your vehicle name',
                      hintText: 'For ex. Honda City',
                      hintStyle:
                      TextStyle(color: Colors.black.withOpacity(0.2)),
                    ),
                    controller: _vehicleNameController,
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width:  double.infinity,
                        child: _photoURL == null
                            ? Container(
                                height: MediaQuery.of(context).size.height * 0.3,
                                width:   double.infinity,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: ExactAssetImage(
                                          'images/linkPNG.png'),
                                      fit: BoxFit.cover,
                                    )))
                            : CachedNetworkImage(
                              imageUrl: _photoURL,
                              imageBuilder:
                                  (context, imageProvider) =>
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    width:  MediaQuery.of(context).size.width * 0.5,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget:
                                  (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: SizedBox(),
                          ),
                          Expanded(
                            flex: 1,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 25.0,
                              child: InkWell(
                                onTap: () async {
                                  final pickedFile =
                                  await ImagePicker()
                                      .getImage(
                                      source:
                                      ImageSource
                                          .gallery,
                                      imageQuality: 65);
                                  if (pickedFile != null) {
                                    File image =
                                    File(pickedFile.path);
                                    //have to implement
                                    _photoURL =
                                          await uploadFile(image);
                                    setState(() {});
                                  }
                                },
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Expanded(
                            flex: 1,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 25.0,
                              child: InkWell(
                                onTap: () async {
                                  // for dialog
                                   _showMyDialog();
                                },
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: SizedBox(),
                          ),
                        ],
                      )
                    ],
                  ),
                  Visibility(
                    visible: _showError,
                    child: Text(
                      "No User Found!",
                      style: TextStyle(color: Colors.red.shade400),
                    ),
                  ),
                  Visibility(
                    visible: _showConfirmation,
                    child: Text(
                      "Vehicle Linked!",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        _loading = true;
                      });
                      //Check if user account exists (traverse through collections)
                      _userExists = await DatabaseService().checkUserExists(_mobileNumberController.text);
                      if (!_userExists) {
                        setState(() {
                          _loading = false;
                          _showError = true;
                          _showConfirmation = false;
                        });
                      } else {
                        // Link Vehicle -> Add vehicle in user collection, and in vehicle collection, add user mobile number with tag owner = true

                        bool success = await DatabaseService().linkVehicle(_mobileNumberController.text,_numberPlateController.text,_vehicleNameController.text,_photoURL);

                        setState(() {
                          _loading = false;
                          _showConfirmation = true;
                          _showError = false;
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          color: Colors.red,
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
            )),
      ),
    );
  }

  Future<String> uploadFile(File file) async {
    var user = FirebaseAuth.instance.currentUser;
    var storageRef = FirebaseStorage.instance
        .ref()
        .child("images/${Uuid().v1()}");
    var uploadTask = await storageRef.putFile(file).whenComplete(() async {
      print(storageRef.getDownloadURL());
    });
    return await storageRef.getDownloadURL();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete this picture'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to delete this picture? You can choose another, or this one again'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await deleteFromFirebase(context);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future deleteFromFirebase(var context) async {
    print("inside deleting");
    var user = FirebaseAuth.instance.currentUser;
    var storageRef = FirebaseStorage.instance
        .ref()
        .child("${user.email}/profilepic/profilepic");

    try {
      await storageRef.delete();
      _photoURL = null;
    } catch (e) {
      print(e);
      final snackBar = SnackBar(content: Text('Some error occurred!'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

}
