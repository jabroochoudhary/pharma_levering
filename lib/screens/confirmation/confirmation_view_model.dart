import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/notifications/fcm_send_notification.dart';
import '/App%20Services/db_helper.dart';
import '/Network%20Services/firebase_collection_name.dart';
import '/App%20Services/LocalDataSaver.dart';
import '/screens/confirmationsuccesspage/confirmation_succes_page.dart';
import '/screens/homepage/home_page.dart';
import '/widgets/app_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../detailscreen/item_details_view_model.dart';

class ConfirmationViewModel extends GetxController {
  RxDouble totalPrice = .0.obs;
  RxBool isLoading = false.obs;
  RxString addressController = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    initVar();
    super.onInit();
  }

  final _firebase = FirebaseFirestore.instance;

  List<cartRead> cartitems = <cartRead>[];
  initVar() async {
    totalPrice.value = await DbHelper.calculateSubtotal();
    await _firebase
        .collection(CollectionName.userCollection)
        .doc(await LocalDataSaver.getUserId())
        .get()
        .then((value) {
      addressController.value = value["address"];
    });
  }

  placeOrderFirebase(bool isCronic) async {
    isLoading.value = true;
    cartitems = await CartModel.fetchCart();
    final mId = DateTime.now().microsecondsSinceEpoch.toString();
    final storeId = await LocalDataSaver.getCartShopId();
    final storeName = await LocalDataSaver.getCartShopName();
    final userName = await LocalDataSaver.getName();
    final userId = await LocalDataSaver.getUserId();

    bool isMasterOrderPlace = false;
    await _firebase
        .collection(CollectionName.masterOrderCollectinName)
        .doc(mId)
        .set({
      "id": mId,
      "storeid": storeId,
      "storename": storeName,
      "orderusername": userName,
      "orderid": userId,
      "isaccept": false,
      "ispanding": true,
      "iscancel": false,
      "ordertotal": !isCronic
          ? (50 + totalPrice.value)
          : (totalPrice.value - (totalPrice.value * 0.05) + 50),
      "delivery": 50.0,
      "discount": isCronic
          ? totalPrice.value - (totalPrice.value - (totalPrice.value * 0.05))
          : 0.0,
      "subtotal": totalPrice.value,
      "placedAt": Timestamp.now().toDate(),
    }).then((value) {
      isMasterOrderPlace = true;
    });
    bool isdetailDone = false;
    if (isMasterOrderPlace) {
      for (int i = 0; i < cartitems.length; i++) {
        final dtId = DateTime.now().microsecondsSinceEpoch.toString();
        await _firebase
            .collection(CollectionName.detailMasterOrderCollectinName)
            .doc(dtId)
            .set({
          "id": dtId,
          "masterorderid": mId,
          "name": cartitems[i].name.toString(),
          "price": cartitems[i].price.toString(),
          "qty": cartitems[i].quantity.toString(),
          "total": cartitems[i].total.toString(),
          "itemid": cartitems[i].docid.toString(),
          "itemDesc": cartitems[i].desc.toString(),
        });
        if (i == cartitems.length - 1) {
          isdetailDone = true;
        }
      }
    }
    String token = "";
    ////  Sending Notification
    await _firebase
        .collection(CollectionName.storeCollection)
        .doc(storeId)
        .get()
        .then((value) {
      token = value['devicetoken'];
    });

   await FcmNotifications()
        .sendPushMessage(body: "You got new order.  Tap to view details.", title: "New Order", thisDeviceToken: token);

    ////
    if (isdetailDone && isMasterOrderPlace) {
      await LocalDataSaver.setIsCart(false);
      await LocalDataSaver.setCartShopId("");
      await LocalDataSaver.setCartShopName("");
      await DbHelper.deleteTable();
      isLoading.value = false;

      Get.offAll(() => HomePage());
      Get.to(() => ConfirmationSuccessPage());
    } else {
      isLoading.value = false;
      AppNotification().error(
          title: "Error",
          message:
              "Something went wrong in placing order\nPLease check your internet connection");
    }
  }
}
