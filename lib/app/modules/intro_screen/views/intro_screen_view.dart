import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:watchman_app/app/models/intro_screen_model.dart';
import 'package:watchman_app/app/routes/app_pages.dart';
import 'package:watchman_app/themes/app_colors.dart';
import 'package:watchman_app/themes/app_them_data.dart';
import 'package:watchman_app/themes/button_theme.dart';
import 'package:watchman_app/utils/preferences.dart';

import '../controllers/intro_screen_controller.dart';

class IntroScreenView extends GetView<IntroScreenController> {
  const IntroScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey02,
      appBar: AppBar(
          backgroundColor: AppColors.lightGrey02,
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 16,
          title: Obx(() => Row(
                children: [
                  if (controller.selectedPageIndex.value != 0)
                    InkWell(
                        onTap: () {
                          controller.selectedPageIndex.value--;
                          controller.pageController.animateToPage(controller.selectedPageIndex.value,
                              curve: Curves.linear, duration: const Duration(milliseconds: 300));
                        },
                        child: SvgPicture.asset("assets/icons/ic_arrow_left.svg")),
                  const Spacer(),
                  if (controller.selectedPageIndex.value != 2)
                    InkWell(
                      onTap: () {
                        Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                        Get.toNamed(Routes.LOGIN_SCREEN);
                      },
                      child: Row(
                        children: [
                          const Text(
                            "Skip",
                            style: TextStyle(fontFamily: AppThemData.medium, color: AppColors.lightGrey10, fontSize: 16),
                          ),
                          SvgPicture.asset("assets/icons/ic_right.svg")
                        ],
                      ),
                    )
                ],
              ))),
      body: PageView.builder(
        onPageChanged: (value) {
          controller.selectedPageIndex.value = value;
        },
        controller: controller.pageController,
        itemCount: controller.introScreenList.length,
        itemBuilder: (context, index) {
          IntroScreenModel introScreenModel = controller.introScreenList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  introScreenModel.title.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: AppThemData.bold, color: AppColors.darkGrey10, fontSize: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  introScreenModel.description.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.lightGrey10, fontSize: 16),
                ),
                const SizedBox(
                  height: 24,
                ),
                ButtonThem.buildButton(
                  btnWidthRatio: .6,
                  btnHeight: 56,
                  txtSize: 16,
                  context,
                  title: "Next",
                  txtColor: AppColors.lightGrey01,
                  bgColor: AppColors.darkGrey10,
                  onPress: () {
                    if (controller.selectedPageIndex.value == 2) {
                      Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                      Get.toNamed(Routes.LOGIN_SCREEN);
                    } else {
                      controller.selectedPageIndex.value++;
                      controller.pageController.animateToPage(controller.selectedPageIndex.value,
                          curve: Curves.linear, duration: const Duration(milliseconds: 300));
                    }
                  },
                ),
                const SizedBox(
                  height: 76,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
