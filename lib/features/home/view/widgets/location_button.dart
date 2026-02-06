import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationButton extends StatelessWidget {
  const LocationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(5, 5.h, 5.w, 5.h),
      child: Row(
          children: [
            Icon(Icons.location_on_outlined,size: 25.sp),
            SizedBox(width: 6.w),
            Text(
              'Cairo, EG',
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
            SizedBox(width: 2.w),
          ],
        ),
    );
  }
}
