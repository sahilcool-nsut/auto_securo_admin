import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_securo_admin/VehicleInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:auto_securo_admin/globals.dart' as globals;
import 'package:http/http.dart' as http;

class DatabaseService {
  // collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference vehiclesCollection =
      FirebaseFirestore.instance.collection('vehicles');
  CollectionReference historyCollection =
      FirebaseFirestore.instance.collection('allHistory');

  Future<List<VehicleInfo>> getHistory() async {
    List<VehicleInfo> tempList = [];
    try {
      print("inside gethistory");

      var data = await historyCollection.orderBy("timeStamp",descending: true).get().then((value) async {
        for (var element in value.docs) {
          print("inside doc");
          var vehicleInfo = await vehiclesCollection
              .doc(element["numberPlate"])
              .get()
              .then((value) {
            print(element["numberPlate"]);
            tempList.add(VehicleInfo(
                element["userName"],
                value["vehicleName"],
                element["numberPlate"],
                value["ownerName"],
                element["timeStamp"]));
          });
        }
//        value.docs.forEach((element) async {
//
//        });
      });
      print("FFF");
      print(tempList);
      return tempList;
    } catch (e) {
      print("error in gethistory");
      print(e);
      return [];
    }
  }

  Future sendNotification(String userName, String vehicleName,
      String numberPlate, String targetPhone, String timeStamp) async {
    print("inside notification sending");

    historyCollection.add({
      'userName': userName,
      'numberPlate': numberPlate,
      'timeStamp': timeStamp,
    });

    usersCollection.doc(targetPhone).collection("notifications").add({
      'userName': userName,
      'numberPlate': numberPlate,
      'timeStamp': timeStamp,
    });

    await vehiclesCollection
        .doc(numberPlate)
        .collection('users')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        var phone = element["phoneNumber"];
        print(phone);
        var token = await usersCollection.doc(phone).get().then((userData) {
          return userData["deviceToken"];
        });
        print(token);
        var body={
          "notification" : {
            "body": "Your $vehicleName, numbered $numberPlate has left the society, with driver $userName at $timeStamp",
            "title": "Vehicle movement!",
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
          },
          "priority":"high",
          "data": {
            "body": "Your $vehicleName, numbered $numberPlate has left the society, with driver $userName at $timeStamp",
            "title": "Vehicle movement!",
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "id": "1",
            "status": "done"
          },
//          "data":null,
          //"data":{},
          "to": token
        };
        var response = await http.post(
            Uri.parse(
                "https://fcm.googleapis.com/fcm/send"),
            headers: {
              'Content-Type': 'application/json',
              "Authorization":"key=AAAAHL46w3c:APA91bGn-_CzmOw40H7__zsVllGoJX3UBQJ5IILeQzfKnYBjGNMOskc2G6zyrKx8zfzO1iLG9AmzIllSKnT06zMJ7c-56By3Ggp4k975DFOThJUdGupzvGJmwhB50b2yOCxLQiua3HwB"
            },
            body: json.encode(body));
        print(response.body);
        print(response.statusCode);
      }
    });

//    POST https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send HTTP/1.1
//
//    Content-Type: application/json
//  Authorization: Bearer ya29.ElqKBGN2Ri_Uz...HnS_uNreA
//
//    http.
//    {
//    "message":{
//    "token":"token_1",
//    "data":{},
//    "notification":{
//    "title":"FCM Message"
//    "body":"This is an FCM notification message!",
//    }
//    }
//    }
  }

  Future<bool> checkUserExists(String phoneNumber) async {
    var doc = await usersCollection.doc(phoneNumber).get();
    if (doc.exists) {
      return true;
    }
    return false;
  }

  Future<bool> linkVehicle(String phoneNumber, String numberPlate,
      String vehicleName, String vehiclePhoto) async {
    await usersCollection.doc(phoneNumber).collection("vehicles").add({
      'numberPlate': numberPlate,
      'owner': true,
    });
    var data = await usersCollection.doc(phoneNumber).get();

    await vehiclesCollection.doc(numberPlate).set({
      'numberPlate': numberPlate,
      'ownerName': data.data()["fullName"],
      'ownerPhone': phoneNumber,
      'vehicleName': vehicleName,
      'vehiclePhoto': vehiclePhoto,
    });
    await vehiclesCollection.doc(numberPlate).collection('users').add({
      'owner': true,
      'phoneNumber': phoneNumber,
    });
  }
}
