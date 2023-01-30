import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/Network%20Services/firebase_collection_name.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../notifications/fcm_send_notification.dart';

class SingleDetailsViewModel extends GetxController {
  RxBool isLoading = false.obs;
  cancelOrder(String masterDocId) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection(CollectionName.masterOrderCollectinName)
        .doc(masterDocId)
        .update({
      "iscancel": true,
    });
    String storeDoc = "";
    String token = "";

    await FirebaseFirestore.instance
        .collection(CollectionName.masterOrderCollectinName)
        .doc(masterDocId)
        .get()
        .then((value) {
      storeDoc = value['storeid'];
    });
    await FirebaseFirestore.instance
        .collection(CollectionName.storeCollection)
        .doc(storeDoc)
        .get()
        .then((value) {
      token = value['devicetoken'];
    });
    await FcmNotifications().sendPushMessage(
        body:
            "The order is canceld that was placed sometime before. Tap to view details.",
        title: "Cancel Order",
        thisDeviceToken: token);

    isLoading.value = false;
    Get.back();
    Get.back();
  }
}
