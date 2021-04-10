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
              child: FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '$startTime',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0.sp),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              'USER: $username',
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0.sp,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Numberplate: $vehicleNo',
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0.sp,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Flexible(
                              child: Text(
                                'Vehicle: $vehicleName',
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0.sp,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Owner Name: $vehicleOwner',
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
