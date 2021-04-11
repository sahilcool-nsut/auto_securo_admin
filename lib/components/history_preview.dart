import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryPreview extends StatelessWidget {
  HistoryPreview({
    this.startTime,
    @required this.username,
    @required this.vehicleNo,
    @required this.vehicleName,
    @required this.vehicleOwner,
  });
  final String startTime;
  final String username;
  final String vehicleNo;
  final String vehicleName;
  final String vehicleOwner;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(414, 812));
    return Padding(
      padding: EdgeInsets.only(
        left: 10.0.w,
        top: 10.0.h,
        right: 15.0.w,
        bottom: 10.h,
      ),
      child: Row(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, left: 15.w, right: 15.w),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'User: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: username,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Vehicle: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: vehicleName,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Numberplate: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: vehicleNo,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Owner Name: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: vehicleOwner,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Time: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: startTime,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            height: 183.h,
            width: 330.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  offset: Offset(4.0, 4.0),
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                ),
                BoxShadow(
                  color: Colors.grey[100],
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
