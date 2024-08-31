import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:watchman_app/app/models/booking_model.dart';
import 'package:watchman_app/app/models/customer_model.dart';
import 'package:watchman_app/constant/constant.dart';

class BookingSummaryScreenController extends GetxController {
  Rx<TextEditingController> numberPlateController = TextEditingController().obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  Rx<DateTime> startTime = DateTime.now().obs;
  Rx<TextEditingController> startTimeController = TextEditingController().obs;
  ImagePicker picker = ImagePicker();

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArguments();
    super.onInit();
  }

  getArguments() async {
    dynamic argument = Get.arguments;
    if (argument != null) {
      bookingModel.value = argument['bookingModel'];
      customerModel.value = argument['customerModel'];
      isLoading.value = false;
    }
  }

  getLicensePlate() async {
    // pick an image
    final pickedFile = await getImage();

    if (pickedFile == null) {
      return null;
    }
    isLoading.value = true;
    // make request to 3rd party api for better alpr

    Map<String, String> headers = {"Authorization": "Token ${Constant.plateRecognizerApiToken}"};
    var alprRequest = http.MultipartRequest("POST", Uri.parse('https://api.platerecognizer.com/v1/plate-reader/'));
    var alprPic = await http.MultipartFile.fromPath("upload", pickedFile.path);
    alprRequest.files.add(alprPic);
    alprRequest.headers.addAll(headers);
    alprRequest.fields["regions"] = "in";
    var alprRes = await alprRequest.send();
    var alprResponseData = await alprRes.stream.toBytes();
    var alprResponseString = String.fromCharCodes(alprResponseData);
    var alprResults = jsonDecode(alprResponseString)["results"];

    log("::::::::::::>>>>>>:::::$alprResults::::::::::");
    if (alprResults != null && alprResults.length > 0) {
      imageCache.clear();
      numberPlateController.value.text = alprResults[0]["plate"].toUpperCase();
      isLoading.value = false;
    } else {
      imageCache.clear();
      isLoading.value = false;
    }
  }

  Future getImage({String? source}) async {
    ImageSource imageSource = ImageSource.camera;
    final pickedFile = await picker.pickImage(source: imageSource);
    Get.back();
    return pickedFile;
  }
}
