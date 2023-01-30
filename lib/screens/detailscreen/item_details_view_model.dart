import 'package:e_medicine_shop/widgets/app_notification.dart';
import 'package:e_medicine_shop/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Admin Side/Add Item/add_item_view_modal.dart';
import '../../App Services/LocalDataSaver.dart';
import '../../App Services/db_helper.dart';

class ItemDetailsViewModel extends GetxController {
  RxInt qty = 1.obs;
  RxDouble totalItem = (1.0).obs;
  RxBool isLoading = false.obs;
  RxBool thisIsCatred = false.obs;

  getQty(AddItemModal dt) async {
    int qt = await DbHelper.getQtyItemCarted(dt.id.toString());

    if (qt != 0) {
      qty.value = qt;
      totalItem.value = dt.price! * qt;
      thisIsCatred.value = true;
    }
  }

  addToCart({AddItemModal? data, String? storeName}) async {
    String lastTimeStore;
    bool isCart;
    isLoading.value = true;
    try {
      lastTimeStore = (await LocalDataSaver.getCartShopId())!;
      isCart = (await LocalDataSaver.getIsCart())!;
    } catch (e) {
      lastTimeStore = "";
      isCart = false;
    }
    try {
      if (isCart && lastTimeStore != data!.storeId.toString()) {
        AppNotification().dialogue(
          content:
              "Some items is already in cart from other store.\nYou want to delete them and insert new item from this store.",
          onNoPressed: () {
            isLoading.value = false;
          },
          onYesPressed: () async {
            Get.back();
            await DbHelper.deleteTable();
            print(data.isCronic);
            await insertDataToSqlCart(
              qty.value,
              data.isCronic!
                  ? (data.price! - (data.price! * 0.05)).toString()
                  : data.price.toString(),
              data.desc.toString(),
              data.name.toString(),
              data.id.toString(),
              storeName!,
              data.storeId.toString(),
            );
            isLoading.value = false;
            thisIsCatred.value = true;
            AppNotification().sucess(title: "Cart", message: "Item is cated");
          },
        );
      } else {
        await insertDataToSqlCart(
          qty.value,
          data!.isCronic!
              ? (data.price! - (data.price! * 0.05)).toString()
              : data.price.toString(),
          data.desc.toString(),
          data.name.toString(),
          data.id.toString(),
          storeName!,
          data.storeId.toString(),
        );
        isLoading.value = false;
        AppNotification().sucess(title: "Cart", message: "Item is cated");
        thisIsCatred.value = true;
      }
    } catch (e) {
      isLoading.value = false;
      AppNotification().error(title: "Cart", message: e.toString());
    }
  }

  insertDataToSqlCart(int qty, String price, String desc, String name,
      String itemid, String shopename, String shopeDocId) async {
    var total = qty * double.parse(price);
    DbHelper.insertCart(
        CartModel.toMap(itemid, name, desc, qty, price, total.toString()));

    await LocalDataSaver.setIsCart(true);
    await LocalDataSaver.setCartShopName(shopename);
    await LocalDataSaver.setCartShopId(shopeDocId);
  }
}

class CartModel {
  static Map<String, Object> toMap(docid, name, desc, quantity, price, total) {
    return {
      'docid': docid,
      'name': name,
      'desc': desc,
      'quantity': quantity,
      'price': price,
      'total': total,
    };
  }

  static Future<List<cartRead>> fetchCart() async {
    final cartList = await DbHelper.getCart();
    return cartList
        .map((item) => cartRead(
            id: item['id'].toString(),
            docid: item['docid'].toString(),
            name: item['name'].toString(),
            desc: item['desc'].toString(),
            quantity: item['quantity'].toString(),
            price: item['price'].toString(),
            total: item['total'].toString()))
        .toList();
  }
}

class cartRead {
  String id;
  String docid;
  String name;
  String desc;

  String quantity;
  String price;
  String total;

  cartRead({
    required this.id,
    required this.docid,
    required this.name,
    required this.desc,
    required this.quantity,
    required this.price,
    required this.total,
  });
}
