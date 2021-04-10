import 'package:flutter/material.dart';
class VehicleInfo {
  String userName;
  String name;
  String numberPlate;
  String ownerName;
  String timeStamp;
  VehicleInfo(userName,name,numberPlate,ownerName,timeStamp)
  {
    this.userName = userName;
    this.name = name;
    this.numberPlate = numberPlate;
    this.ownerName = ownerName;
    this.timeStamp = timeStamp;
  }
}
