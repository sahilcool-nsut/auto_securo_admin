import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

String phoneNumber;
User user;
AuthCredential phoneAuthCredential;
AppBar myAppBar = AppBar(
  title: Text("Auto Securo"),
);

List<CameraDescription> cameras = [];
