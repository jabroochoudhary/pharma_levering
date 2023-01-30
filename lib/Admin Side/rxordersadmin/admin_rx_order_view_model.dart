import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/Network%20Services/firebase_collection_name.dart';
import 'package:get/get.dart';

import '../../App Services/LocalDataSaver.dart';
import '../../notifications/fcm_send_notification.dart';

class AdminRxOrderViewModel extends GetxController {
  RxString userid = "".obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    initvar();
    super.onInit();
  }

  void initvar() async {
    userid.value = (await LocalDataSaver.getUserId())!;
    print(userid.value);
  }

  void acceptOrder(String id) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection(CollectionName.rxOrderCollection)
        .doc(id)
        .update({
      "isAccept": true,
    });
    String storeDoc = "";
    String token = "";

    await FirebaseFirestore.instance
        .collection(CollectionName.masterOrderCollectinName)
        .doc(id)
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
        body:
            "The order is accepted that was placed sometime before. Tap to view details.",
        title: "Accept Order",
        thisDeviceToken: token);

    isLoading.value = false;
  }

  void deliverOrder(String id) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection(CollectionName.rxOrderCollection)
        .doc(id)
        .update({
      "isPending": false,
    });

    String storeDoc = "";
    String token = "";

    await FirebaseFirestore.instance
        .collection(CollectionName.masterOrderCollectinName)
        .doc(id)
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
  }
}
