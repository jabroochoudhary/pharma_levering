import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/Network%20Services/firebase_collection_name.dart';
import 'package:get/get.dart';

import '../../notifications/fcm_send_notification.dart';

class AdminOrderDetailViewModel extends GetxController {
  RxBool isLoading = false.obs;

  acceptOrder(String morder) async {
    // Get.back();
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection(CollectionName.masterOrderCollectinName)
        .doc(morder)
        .update({
      'isaccept': true,
    });
    String storeDoc = "";
    String token = "";

    await FirebaseFirestore.instance
        .collection(CollectionName.masterOrderCollectinName)
        .doc(morder)
        .get()
        .then((value) {
      storeDoc = value['orderid'];
    });
    await FirebaseFirestore.instance
        .collection(CollectionName.userCollection)
        .doc(storeDoc)
        .get()
        .then((value) {
      token = value['devicetoken'];
    });
    await FcmNotifications().sendPushMessage(
        body: "The order is accepted. Order in way. Tap to view details.",
        title: "Deliver Order",
        thisDeviceToken: token);
    isLoading.value = false;
    Get.back();
  }

  deliverOrder(String mOrder) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection(CollectionName.masterOrderCollectinName)
        .doc(mOrder)
        .update({
      'ispanding': false,
    });
    String storeDoc = "";
    String token = "";

    await FirebaseFirestore.instance
        .collection(CollectionName.masterOrderCollectinName)
        .doc(mOrder)
        .get()
        .then((value) {
      storeDoc = value['orderid'];
    });
    await FirebaseFirestore.instance
        .collection(CollectionName.userCollection)
        .doc(storeDoc)
        .get()
        .then((value) {
      token = value['devicetoken'];
    });
    await FcmNotifications().sendPushMessage(
        body: "The order is deliverd. Tap to view details.",
        title: "Deliver Order",
        thisDeviceToken: token);
    isLoading.value = false;
    Get.back();
  }
}
