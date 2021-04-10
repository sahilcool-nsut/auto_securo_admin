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
            margin: EdgeInsets.only(bottom: 6.0.h),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FittedBox(
                    fit:BoxFit.scaleDown,
                    child: Text(
                      '$startTime',
                      maxLines:3,
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,

                          fontSize: 14.0.sp),
                    ),
                  ),
                  // Text(
                  //   startTime != null ? 'to' : 'By',
                  //   style: TextStyle(
                  //     color: Colors.black87,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  // Text(
                  //   '$endTime',
                  //   style: TextStyle(
                  //     color: Colors.black87,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                ],
              ),
            ),
            height: 55.h,
            width: 55.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 25.0.w,
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, left: 15.w, right: 15.w),
              child: Flexible(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'User: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            children: <TextSpan>[
                              TextSpan(
                                  text: username,
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.normal,
                                      fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Vehicle: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                  vehicleName,
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.normal,
                                      fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Numberplate: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            children: <TextSpan>[
                              TextSpan(
                                  text: vehicleNo,
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.normal,
                                      fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Owner Name: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            children: <TextSpan>[
                              TextSpan(
                                  text: vehicleOwner,
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.normal,
                                      fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            height: 183.h,
            width: 270.w,
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
