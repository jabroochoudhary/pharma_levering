import 'package:e_medicine_shop/Admin%20Side/Add%20Item/add_item.dart';
import 'package:e_medicine_shop/Admin%20Side/Edit%20Item/edit_item_view.dart';
import 'package:e_medicine_shop/Admin%20Side/pandingordersadmin/panding_orders_admin_screen.dart';
import 'package:e_medicine_shop/Admin%20Side/rxordersadmin/admin_rx_order_screen.dart';
import 'package:e_medicine_shop/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../App Services/LocalDataSaver.dart';
import '../screens/login/login.dart';
import 'alltimeorders/all_time_orders_admin.dart';

class AdminDrawer {
  drawer() {
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 2,
      child: ListView(children: [
        Container(
          height: 200,
          color: Color.fromARGB(255, 20, 101, 22),
          padding: EdgeInsets.all(20),
          child: Image(image: AssetImage("images/appicon.png")),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () => Get.to(() => AddNewItem()),
          child: Container(
            margin: const EdgeInsets.only(top: 15, bottom: 10, left: 15),
            child: Row(
              children: [
                const Icon(
                  Icons.add,
                  size: 25,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.text(
                  "Add new item",
                  color: Colors.green,
                  fontsize: 18,
                  fontweight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () => Get.to(() => EditItemView()),
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
            child: Row(
              children: [
                const Icon(
                  Icons.edit,
                  size: 25,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.text(
                  "Edit items",
                  color: Colors.green,
                  fontsize: 18,
                  fontweight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () => Get.to(() => PandingOrdersAdminScreen()),
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
            child: Row(
              children: [
                const Icon(
                  Icons.pending_actions,
                  size: 25,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.text(
                  "Active orders",
                  color: Colors.green,
                  fontsize: 18,
                  fontweight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () => Get.to(() => PandingOrdersAdminScreen(
                isCompleteOrder: true,
              )),
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
            child: Row(
              children: [
                const Icon(
                  Icons.check_box_sharp,
                  size: 25,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.text(
                  "Completed orders",
                  color: Colors.green,
                  fontsize: 18,
                  fontweight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: (() {
            Get.to(() => AllTimeAdminOrders());
          }),
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
            child: Row(
              children: [
                const Icon(
                  Icons.layers,
                  size: 25,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.text(
                  "All time orders",
                  color: Colors.green,
                  fontsize: 18,
                  fontweight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: (() {
            Get.to(() => AdminRxOrdersScreen());
          }),
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
            child: Row(
              children: [
                const Icon(
                  Icons.content_paste_go_rounded,
                  size: 25,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.text(
                  "Rx orders",
                  color: Colors.green,
                  fontsize: 18,
                  fontweight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          color: Colors.grey,
          height: 2,
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            LocalDataSaver.setEmail("");
            LocalDataSaver.setName("");
            LocalDataSaver.setUserId("");

            Get.offAll(() => LoginScreen());
          },
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
            child: Row(
              children: [
                const Icon(
                  Icons.logout,
                  size: 25,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.text(
                  "Log out",
                  color: Colors.green,
                  fontsize: 18,
                  fontweight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
