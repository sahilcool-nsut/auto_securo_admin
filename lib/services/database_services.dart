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

      var data = await historyCollection
          .orderBy("timeStamp", descending: true)
          .get()
          .then((value) async {
        for (var element in value.docs) {
          print("inside doc");
          if (element["userName"].contains("CUSTOM")) {
            if (element["userName"].contains("VEHICLE EXISTS")) {
              var vehicleInfo = await vehiclesCollection
                  .doc(element["numberPlate"])
                  .get()
                  .then((value) {
                print(element["numberPlate"]);
                tempList.add(VehicleInfo(
                    'CUSTOM',
                    value["vehicleName"],
                    element["numberPlate"],
                    value["ownerName"],
                    element["timeStamp"]));
              });
            } else {
              tempList.add(VehicleInfo("CUSTOM", "CUSTOM",
                  element["numberPlate"], "CUSTOM", element["timeStamp"]));
            }
          } else {
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
        }
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

    if (userName == 'custom') {
      print("inside custom type");
      bool exists = await checkVehicleExists(numberPlate);
      if (exists) {
        print("car exists");
        await historyCollection.add({
          'userName': "CUSTOM but VEHICLE EXISTS",
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
            await usersCollection.doc(phone).collection("notifications").add({
              'userName': userName,
              'numberPlate': numberPlate,
              'timeStamp': timeStamp,
            });
            var body = {
              "notification": {
                "body":
                    "⚠Your vehicle, numbered $numberPlate has left the society, with an unknown driver at $timeStamp",
                "title": "Vehicle movement!",
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
              },
              "priority": "high",
              "data": {
                "body":
                    "⚠CAUTION⚠Your vehicle, numbered $numberPlate has left the society, with an unknown driver at $timeStamp",
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
                Uri.parse("https://fcm.googleapis.com/fcm/send"),
                headers: {
                  'Content-Type': 'application/json',
                  "Authorization":
                      "key=AAAAHL46w3c:APA91bGn-_CzmOw40H7__zsVllGoJX3UBQJ5IILeQzfKnYBjGNMOskc2G6zyrKx8zfzO1iLG9AmzIllSKnT06zMJ7c-56By3Ggp4k975DFOThJUdGupzvGJmwhB50b2yOCxLQiua3HwB"
                },
                body: json.encode(body));
            print(response.body);
            print(response.statusCode);
          }
        });
      } else {
        print("car doesnt exist");
        await historyCollection.add({
          'userName': "CUSTOM",
          'numberPlate': numberPlate,
          'timeStamp': timeStamp,
        });
      }
    } else {
      await historyCollection.add({
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
          await usersCollection.doc(phone).collection("notifications").add({
            'userName': userName,
            'numberPlate': numberPlate,
            'timeStamp': timeStamp,
          });
          print(token);
          var body = {
            "notification": {
              "body":
                  "Your $vehicleName, numbered $numberPlate has left the society, with driver $userName at $timeStamp",
              "title": "Vehicle movement!",
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
            },
            "priority": "high",
            "data": {
              "body":
                  "Your $vehicleName, numbered $numberPlate has left the society, with driver $userName at $timeStamp",
              "title": "Vehicle movement!",
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": "1",
              "status": "done"
            },
//          "data":null,
            //"data":{},
            "to": token
          };
          var response =
              await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
                  headers: {
                    'Content-Type': 'application/json',
                    "Authorization":
                        "key=AAAAHL46w3c:APA91bGn-_CzmOw40H7__zsVllGoJX3UBQJ5IILeQzfKnYBjGNMOskc2G6zyrKx8zfzO1iLG9AmzIllSKnT06zMJ7c-56By3Ggp4k975DFOThJUdGupzvGJmwhB50b2yOCxLQiua3HwB"
                  },
                  body: json.encode(body));
          print(response.body);
          print(response.statusCode);
        }
      });
    }
  }

  Future<bool> checkVehicleExists(String numberPlate) async {
    print(numberPlate.length);
    for (int i = 0; i < numberPlate.length; i++) {
      print(numberPlate[i]);
    }
    print("inside vehicle exist check");
    var doc = await vehiclesCollection.doc(numberPlate).get();
    if (doc.exists) {
      return true;
    }
    return false;
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
