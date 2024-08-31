// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchman_app/app/widget/dialogue_box_widget.dart';
import 'package:watchman_app/app/widget/network_image_widget.dart';
import 'package:watchman_app/constant/constant.dart';
import 'package:watchman_app/constant/show_toast_dialogue.dart';
import 'package:watchman_app/themes/app_colors.dart';
import 'package:watchman_app/themes/app_them_data.dart';
import 'package:watchman_app/themes/button_theme.dart';
import 'package:watchman_app/themes/common_ui.dart';
import 'package:watchman_app/themes/screen_size.dart';

import '../../../routes/app_pages.dart';
import '../controllers/profile_screen_controller.dart';

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileScreenController>(
        init: ProfileScreenController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppColors.lightGrey02,
              appBar: UiInterface().customAppBar(backgroundColor: AppColors.yellow04, context, "My Profile".tr, isBack: false),
              body: controller.isLoading.value
                  ? SingleChildScrollView(
                      child: Form(
                        key: controller.formKey.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: controller.profileImage.isEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(60),
                                          child: Image.asset(
                                            Constant.userPlaceHolder,
                                            height: Responsive.width(30, context),
                                            width: Responsive.width(30, context),
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : (Constant.hasValidUrl(controller.profileImage.value))
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: NetworkImageWidget(
                                                imageUrl: controller.profileImage.value,
                                                height: Responsive.width(30, context),
                                                width: Responsive.width(30, context),
                                                fit: BoxFit.fill,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: Image.file(
                                                File(controller.profileImage.value),
                                                height: Responsive.width(30, context),
                                                width: Responsive.width(30, context),
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                  child: Text(
                                controller.watchManModel.value.name.toString(),
                                style: const TextStyle(fontFamily: AppThemData.bold, fontSize: 18, color: AppColors.darkGrey09),
                              )),
                              Center(
                                  child: Text(
                                controller.watchManModel.value.email.toString(),
                                style: const TextStyle(fontFamily: AppThemData.regular, color: AppColors.darkGrey04),
                              )),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: ButtonThem.buildButton(
                                    btnHeight: 45,
                                    btnWidthRatio: "Edit Profile".tr == "تعديل الملف الشخصي" ? .50 : .44,
                                    imageAsset: "assets/icons/ic_edit_line.svg",
                                    context,
                                    title: "Edit Profile".tr,
                                    txtColor: AppColors.white,
                                    bgColor: AppColors.darkGrey10,
                                    onPress: () {
                                      Get.toNamed(Routes.EDIT_PROFILE_SCREEN, arguments: {"watchManModel": controller.watchManModel.value})
                                          ?.then((value) {
                                        controller.getProfileData();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              menuItemWidget(
                                onTap: () {
                                  Get.toNamed(Routes.PARKING_DETAILS_SCREEN);
                                },
                                title: "Parking Details".tr,
                                svgImage: "assets/icons/ic_notepad.svg",
                              ),
                              menuItemWidget(
                                onTap: () {
                                  Get.toNamed(Routes.LANGUAGE_SCREEN)?.then((value) {
                                    if (value == true) {
                                      controller.getLanguage();
                                    }
                                  });
                                },
                                title: "Language",
                                svgImage: "assets/icons/ic_language.svg",
                              ),
                              menuItemWidget(
                                onTap: () async {
                                  final Uri url = Uri.parse(Constant.privacyPolicy.toString());
                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch ${Constant.supportEmail.toString()}'.tr);
                                  }
                                },
                                title: "Privacy Policy",
                                svgImage: "assets/icons/ic_privacy.svg",
                              ),
                              menuItemWidget(
                                onTap: () async {
                                  final Uri url = Uri.parse(Constant.termsAndConditions.toString());
                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch ${Constant.supportEmail.toString()}'.tr);
                                  }
                                },
                                title: "Terms & Conditions",
                                svgImage: "assets/icons/ic_note.svg",
                              ),
                              menuItemWidget(
                                onTap: () async {
                                  controller.launchEmailSupport();
                                },
                                title: "Support",
                                svgImage: "assets/icons/ic_call.svg",
                              ),
                              menuItemWidget(
                                onTap: () {
                                  Get.toNamed(Routes.CONTACT_US_SCREEN);
                                },
                                title: "Contact us",
                                svgImage: "assets/icons/ic_info.svg",
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              menuItemWidget(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DialogBoxWidget(
                                          onPressConfirm: () async {
                                            await FirebaseAuth.instance.signOut();
                                            Get.offAllNamed(Routes.LOGIN_SCREEN);
                                          },
                                          onPressConfirmBtnName: "Log Out".tr,
                                          onPressConfirmColor: AppColors.red04,
                                          onPressCancel: () {
                                            Get.back();
                                          },
                                          imageAssets: "assets/images/ic_log_out.png",
                                          content: "Are you sure you want to log out? You will be securely signed out of your account.".tr,
                                          onPressCancelColor: AppColors.darkGrey01,
                                          subTitle: "Log Out Confirmation".tr,
                                          onPressCancelBtnName: "Cancel".tr);
                                    },
                                  );
                                },
                                title: "Log Out",
                                svgImage: "assets/icons/ic_log_out.svg",
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              menuItemWidget(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DialogBoxWidget(
                                          imageAssets: "assets/images/ic_delete.png",
                                          onPressConfirm: () async {
                                            ShowToastDialog.showLoader("Please Wait".tr);
                                            await controller.deleteUserAccount();
                                            await FirebaseAuth.instance.signOut();
                                            ShowToastDialog.closeLoader();
                                            Get.offAllNamed(Routes.LOGIN_SCREEN);
                                          },
                                          onPressConfirmBtnName: "Delete".tr,
                                          onPressConfirmColor: AppColors.red04,
                                          onPressCancel: () {
                                            Get.back();
                                          },
                                          content:
                                              "Are you sure you want to Delete Account? All Information will be deleted of your account."
                                                  .tr,
                                          onPressCancelColor: AppColors.darkGrey01,
                                          subTitle: "Delete Account".tr,
                                          onPressCancelBtnName: "Cancel".tr);
                                    },
                                  );
                                },
                                title: "Delete Account".tr,
                                svgImage: "assets/icons/ic_delete.svg",
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Constant.loader());
        });
  }
}

Widget menuItemWidget({
  required String svgImage,
  required String title,
  required VoidCallback onTap,
}) {
  return GetBuilder<ProfileScreenController>(builder: (controller) {
    return ListTile(
      tileColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      horizontalTitleGap: 6,
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      leading: SvgPicture.asset(
        svgImage,
        color: title.tr == "Log Out".tr || title.tr == "Delete Account".tr ? AppColors.red04 : AppColors.darkGrey05,
        height: 26,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(title.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppThemData.medium,
                  color: title.tr == "Log Out".tr || title.tr == "Delete Account".tr ? AppColors.red04 : AppColors.darkGrey08,
                )),
          ),
          if (title == "Language")
            Text(controller.selectedLanguage.value.name.toString().tr,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: AppThemData.semiBold,
                  color: AppColors.darkGrey05,
                )),
        ],
      ),
    );
  });
}
