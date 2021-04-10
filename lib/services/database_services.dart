import 'package:flutter/material.dart';
import 'package:auto_securo_admin/VehicleInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:auto_securo_admin/globals.dart' as globals;

class DatabaseService {

  // collection reference
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');
  final CollectionReference vehiclesCollection =
  FirebaseFirestore.instance.collection('vehicles');
  CollectionReference historyCollection = FirebaseFirestore.instance.collection('allHistory');

  Future<List<VehicleInfo>> getHistory()async {

    List<VehicleInfo> tempList=[];
    try
    {
      print("inside gethistory");

      var data = await historyCollection.get().then((value) async {
        for(var element in value.docs)
          {
            print("inside doc");
            var vehicleInfo = await vehiclesCollection.doc(element["numberPlate"]).get().then((value){
              print(element["numberPlate"]);
              tempList.add(
                  VehicleInfo(element["userName"],value["vehicleName"],element["numberPlate"], value["ownerName"],element["timeStamp"])
              );
            });
          }
//        value.docs.forEach((element) async {
//
//        });
      });
      print("FFF");
      print(tempList);
      return tempList;
    }
    catch(e)
    {
      print("error in gethistory");
      print(e);
      return [];
    }
  }

  Future sendNotification(String userName, String vehicleName, String numberPlate, String targetPhone,String timeStamp) async
  {
    print("inside notification sending");

    historyCollection.add({
      'userName': userName,
      'numberPlate':numberPlate,
      'timeStamp':timeStamp,
    });

    usersCollection.doc(targetPhone).collection("notifications").add({
      'userName':userName,
      'numberPlate':numberPlate,
      'timeStamp':timeStamp,
    });

  }

}