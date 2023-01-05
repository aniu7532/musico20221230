import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/imports/import_from_computer/import_from_computer_model.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/strings.dart';
import 'package:musico/utils/toast_util.dart';

///ImportFromComputer
class ImportFromComputerPage extends BasePage {
  ImportFromComputerPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<ImportFromComputerPage> createState() => _ImportFromComputerPageState();
}

class _ImportFromComputerPageState extends BasePageState<ImportFromComputerPage>
    with BasePageMixin<ImportFromComputerPage, ImportFromComputerModel> {
  @override
  ImportFromComputerModel initModel() {
    return ImportFromComputerModel(requestParam: widget.requestParams);
  }

  late String _networkInterface;
  var _index = 0;
  @override
  void initState() {
    super.initState();
    NetworkInterface.list().then((value) {
      setState(() {
        _networkInterface = '';
        for (final element in value) {
          _networkInterface += '### name: ${element.name}\n';
          var i = 0;
          for (final address in element.addresses) {
            _networkInterface += '${i++}) ${address.address}\n ';
          }
        }
      });
    });
  }

  @override
  List<Widget> getActions() {
    return [
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          MyToast.showToast('Finish');
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Text(
              'Finish',
              style: FSUtils.weight500_16_46B012,
            ),
          ),
        ),
      )
    ];
  }

  @override
  Widget buildContentWidget() {
    return Stack(
      children: [
        Positioned(
          child: PageView.builder(
            itemCount: model.list.length,
            onPageChanged: (i) {
              setState(() {
                _index = i;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              final bean = model.list[index];
              return Container(
                child: Column(
                  children: [
                    bean.icon.image(fit: BoxFit.fill, height: 45.h),
                    SizedBox(
                      height: 18.h,
                    ),
                    SizedBox(
                      width: 240.w,
                      child: Text(
                        bean.title.noWideSpace,
                        style: FSUtils.normal_16_FFFFFF,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    bean.pathIcon?.image(fit: BoxFit.fill, height: 250.h) ??
                        const SizedBox.shrink(),
                    SizedBox(
                      height: 26.h,
                    ),
                    const Text(
                      'IP Address',
                      style: FSUtils.weight500_16_FFFFFF,
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      _networkInterface,
                      style: FSUtils.weight500_19_46B012,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: DotsIndicator(
            dotsCount: model.list.length,
            mainAxisAlignment: MainAxisAlignment.center,
            decorator: const DotsDecorator(
                activeColor: ColorName.secondaryColor, size: Size.square(4.0)),
            position: _index.toDouble(),
          ),
        ),
      ],
    );
  }
}
