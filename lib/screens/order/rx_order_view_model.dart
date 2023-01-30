import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/App%20Services/LocalDataSaver.dart';
import 'package:e_medicine_shop/Network%20Services/firebase_collection_name.dart';
import 'package:e_medicine_shop/screens/confirmationsuccesspage/confirmation_succes_page.dart';
import 'package:e_medicine_shop/screens/homepage/home_page.dart';
import 'package:e_medicine_shop/widgets/app_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

class RxOrderViewModel extends GetxController {
  RxBool isLoading = false.obs;

  placeOrder({
    File? image,
    String? storeDoc,
    String? message,
    String? storename,
  }) async {
    // print();
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    isLoading.value = true;
    final orderUser = await LocalDataSaver.getUserId();
    try {
      final imageUrl = await uploadPreception(image);
      await FirebaseFirestore.instance
          .collection(CollectionName.rxOrderCollection)
          .doc(id)
          .set({
        "id": id,
        "preceptionImageUrl": imageUrl,
        "storeDoc": storeDoc,
        "message": message,
        "placedAt": DateTime.now().millisecondsSinceEpoch,
        "storeName": storename,
        "orderuser": orderUser,
        "isPending": true,
        "isAccept": false,
        "isCancel": false,
      }).then((value) {
        isLoading.value = false;
        Get.offAll(() => HomePage());
        Get.to(() => ConfirmationSuccessPage());
        AppNotification().sucess(
          title: "$storename",
          message: "Order is placed. you can check your order status.",
        );
      });
    } catch (e) {
      isLoading.value = false;
      AppNotification().error(
          title: "Order",
          message: "Unable to place order. SOme thing went wrong");
    }
  }

  Future<String> uploadPreception(File? image) async {
    String ids = DateTime.now().microsecondsSinceEpoch.toString();
    final reff = FirebaseStorage.instance
        .ref()
        .child("rxImages")
        .child("preception" + ids);
    await reff.putFile(image!);
    return await reff.getDownloadURL();
  }
}
