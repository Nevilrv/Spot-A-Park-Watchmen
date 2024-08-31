import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchman_app/app/models/language_model.dart';
import 'package:watchman_app/app/models/watchman_model.dart';
import 'package:watchman_app/constant/constant.dart';
import 'package:watchman_app/constant/show_toast_dialogue.dart';
import 'package:watchman_app/utils/fire_store_utils.dart';

class ProfileScreenController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> countryCode = TextEditingController().obs;
  RxBool isLoading = false.obs;

  RxList<String> genderList = ["Male", "Female", "Others"].obs;
  RxString selectedGender = "Male".obs;
  RxString profileImage = "".obs;
  final ImagePicker imagePicker = ImagePicker();

  Rx<WatchManModel> watchManModel = WatchManModel().obs;
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getLanguage();
    getProfileData();
    getLanguage();
    super.onInit();
  }

  getProfileData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        watchManModel.value = value;
        fullNameController.value.text = watchManModel.value.name!;
        emailController.value.text = watchManModel.value.email!;
        countryCode.value.text = watchManModel.value.countryCode!;
        phoneNumberController.value.text = watchManModel.value.phoneNumber!;
        profileImage.value = watchManModel.value.image!;
      }
      isLoading.value = true;
    });
  }

  void launchEmailSupport() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries.map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
    }

    if (Constant.supportEmail.isNotEmpty) {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: Constant.supportEmail,
        query: encodeQueryParameters(<String, String>{
          'subject': 'Help & Support',
        }),
      );
      launchUrl(emailLaunchUri);
    } else {
      ShowToastDialog.showToast("Contact Not Available");
    }
  }

  getLanguage() {
    selectedLanguage.value = Constant.getLanguage();
  }

  Future<void> deleteUserAccount() async {
    try {
      await FireStoreUtils.deleteUser().then((value) async {
        if (value == true) {
          await FirebaseAuth.instance.currentUser!.delete();
        }
      });
    } catch (e) {
      log(e.toString());
      // Handle general exception
    }
  }
}
