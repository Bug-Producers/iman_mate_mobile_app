import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'location_button.dart';

class Appbarcontent extends StatelessWidget {
  const Appbarcontent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 5.h, 0, 0),
        child: SizedBox(
          height: 50.h,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: () {},
                  child: LocationButton(),
                ),
              ),

              Positioned(
                left: 265.w,
                top: 0,
                bottom: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: () {},
                  child: Icon(Icons.notifications_none),
                ),
              ),

              // Second icon
              Positioned(
                left: 300.w,
                top: 0,
                bottom: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: () {},
                  child: Icon(Icons.wb_sunny_outlined),
                ),
              ),

              // Third icon
              Positioned(
                left: 335.w,
                top: 0,
                bottom: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: () {},
                  child: Icon(Icons.settings_outlined) ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
