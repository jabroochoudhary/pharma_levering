import 'package:e_medicine_shop/appcolors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_text.dart';

class AppNotification {
  sucess({required String title, required String message}) {
    return Get.snackbar(
      title,
      message,
      backgroundColor: Color.fromARGB(255, 222, 222, 222),
      borderRadius: 20,
      colorText: Get.theme.primaryColor,
      titleText: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.baseLightGreenColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      messageText: Text(message,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.baseLightGreenColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          )),
    );
  }

  error({required String title, required String message}) {
    return Get.snackbar(
      title,
      message,
      backgroundColor: Color.fromARGB(255, 222, 81, 81),
      borderRadius: 20,
      colorText: Get.theme.primaryColor,
      titleText: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.baseWhiteColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      messageText: Text(message,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.baseWhiteColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          )),
    );
  }

  hint({required String title, required String message}) {
    return Get.snackbar(
      title,
      message,
      backgroundColor: Color.fromARGB(255, 119, 119, 119),
      borderRadius: 20,
      colorText: Get.theme.primaryColor,
      titleText: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.baseWhiteColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      messageText: Text(message,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.baseWhiteColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          )),
    );



  }

  dialogue({String title ="Alert",String? content,
  GestureTapCallback? onYesPressed,
  GestureTapCallback? onNoPressed,}){
    return Get.defaultDialog(
      title: title,
      backgroundColor: Colors.white,
      titleStyle:const TextStyle(color: Colors.green),
     
      content: Container(
        padding: EdgeInsets.all(5),
        child: AppText.text(
          content,
          color: Colors.grey,
          fontsize: 12,
          fontweight: FontWeight.w400,
          textAlignment: TextAlign.start,
          maxlines: 3,
        ),
      ),
      onConfirm: onYesPressed,
      onCancel: onNoPressed,
      textCancel: "No",
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.green,
      buttonColor: Colors.green,
      radius: 10,
    );
  }
}
