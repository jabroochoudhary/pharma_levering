import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/App%20Services/LocalDataSaver.dart';
import 'package:e_medicine_shop/Network%20Services/firebase_collection_name.dart';
import 'package:get/get.dart';

import '../../notifications/fcm_send_notification.dart';

class RxOrderStatusViewModel extends GetxController {
  RxString userid = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    initVar();
    super.onInit();
  }

  initVar() async {
    userid.value = (await LocalDataSaver.getUserId())!;
    // print(userid.value);
  }

  cancelRxOrder(String docId) async {
    await FirebaseFirestore.instance
        .collection(CollectionName.rxOrderCollection)
        .doc(docId)
        .update({
      'isCancel': true,
    });

    String token = "";
    String storeDoc = "";
    ////  Sending Notification
    await FirebaseFirestore.instance
        .collection(CollectionName.rxOrderCollection)
        .doc(docId)
        .get()
        .then((value) {
      storeDoc = value['storeDoc'];
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

    Get.back();
  }
}
