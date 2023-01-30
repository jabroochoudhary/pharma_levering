import 'package:e_medicine_shop/App%20Services/LocalDataSaver.dart';
import 'package:e_medicine_shop/App%20Services/db_helper.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../detailscreen/item_details_view_model.dart';

class CartViewModel extends GetxController {
  RxInt totalItemsInCart = 0.obs;
  RxBool isCart = false.obs;
  RxString shopName = "".obs;
  RxDouble subtotalCart = .0.obs;
  RxBool isCronicDisease = false.obs;
//  RxList<cartRead>  cartitems = cartRead().obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    initializedVar();
    super.onInit();
  }

  void initializedVar() async {
    totalItemsInCart.value = await DbHelper.countItemsInCart();
    subtotalCart.value = await DbHelper.calculateSubtotal();
    try {
      isCart.value = (await LocalDataSaver.getIsCart())!;
    } catch (e) {}
    try {
      shopName.value = (await LocalDataSaver.getCartShopName())!;
    } catch (e) {}
  }

  readCart() => CartModel.fetchCart();

  void incrimentItemPrice(
      String id, String quantity, String price, String total) async {
    double iprice = double.parse(price);
    double itotal = double.parse(total);
    int iqun = int.parse(quantity);
    iqun++;
    itotal = iprice * iqun;

    await DbHelper.incrimentItemPrice(id, iqun, itotal.toString());

    totalItemsInCart.value = await DbHelper.countItemsInCart();
    subtotalCart.value = await DbHelper.calculateSubtotal();
  }

  void decrementItemPrice(
    String id,
    String quantity,
    String price,
    String total,
  ) async {
    double iprice = double.parse(price);
    double itotal = double.parse(total);
    int iqun = int.parse(quantity);
    if (iqun == 1) {
      await DbHelper.deleteRow(id);
    } else {
      iqun--;
      itotal = iqun * iprice;

      await DbHelper.decrementItemPrice(id, iqun, itotal.toString());
    }
    totalItemsInCart.value = await DbHelper.countItemsInCart();
    subtotalCart.value = await DbHelper.calculateSubtotal();
  }
}
