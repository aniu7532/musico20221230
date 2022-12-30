import 'package:musico/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/utils/size_utils.dart';

const double dividerHeight = 0.5;
const Color dividerColor = Color(0xFFE2E4EA); // #E2E4EA 0xFFBEBEBE

Widget dividerNormal1 = SizedBox(
  height: dividerHeight,
  width: double.infinity,
  child: DecoratedBox(
      decoration: BoxDecoration(
    color: ColorName.progressBgColor.withOpacity(0.4),
  )),
);

const Widget dividerNormal6 = SizedBox(
  height: dividerHeight * 12,
  width: double.infinity,
  child: DecoratedBox(decoration: BoxDecoration(color: dividerColor)),
);

const Widget dividerNormal8 = SizedBox(
  height: dividerHeight * 16,
  width: double.infinity,
  child: DecoratedBox(decoration: BoxDecoration(color: dividerColor)),
);

const Widget dividerNormal20 = SizedBox(
  height: 0.5,
  width: double.infinity,
  child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFE2E4EA))),
);

final Widget dividerGap8 = SizedBox(
  height: 8.h,
);
final Widget dividerGap4 = SizedBox(
  height: 4.h,
);
final Widget dividerGap10 = SizedBox(
  height: 10.h,
);
final Widget dividerGap11 = SizedBox(
  height: 11.h,
);
final Widget dividerGap12 = SizedBox(
  height: 12.h,
);

final Widget dividerList1 = Container(
  color: Colors.white,
  padding: EdgeInsets.symmetric(horizontal: sizeUtil.w20),
  child: dividerNormal1,
);

final Widget dividerListWidth16 = Container(
  color: Colors.white,
  padding: EdgeInsets.symmetric(horizontal: sizeUtil.w16),
  child: dividerNormal1,
);

final Widget dividerListLeft12Right20 = Container(
  color: Colors.white,
  padding: const EdgeInsets.only(left: 12, right: 20),
  child: dividerNormal1,
);

final Widget dividerCustomer = Container(
  color: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: dividerNormal20,
);

final Widget dividerCustomerDetail = Container(
  color: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: dividerNormal1,
);

final Widget dividerCustomerNoIndent = Container(
  color: Colors.white,
  child: dividerNormal20,
);

final Widget dividerListNoIndent = Container(
  color: Colors.white,
  child: dividerNormal1,
);

const Widget dividerBottomDialogWithOutPadding = SizedBox(
  height: 0.5,
  width: double.infinity,
  child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF2F2F2F))),
);

final Widget dividerBottomDialog = Container(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: dividerBottomDialogWithOutPadding,
);
