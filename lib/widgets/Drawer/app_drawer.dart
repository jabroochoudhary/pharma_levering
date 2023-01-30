import 'package:e_medicine_shop/App%20Services/LocalDataSaver.dart';
// import 'package:e_medicine_shop/screens/Rx%20Orders%20Satus/rx_orders_status_screen.dart';
import 'package:e_medicine_shop/screens/canceldorder/cancel_order_screen.dart';
import 'package:e_medicine_shop/screens/login/login.dart';
import 'package:e_medicine_shop/screens/pendingorders/panding_order_user_screen.dart';
import 'package:e_medicine_shop/screens/profilescreen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/Rx Orders/rx_orders_status_screen.dart';
import '../../screens/completedorders/completed_orders_user_screen.dart';
import '../app_config.dart';
import '../app_text.dart';
import 'Components/drawer_tile.dart';

class AppDrawer {
  drawer({required BuildContext context, required Function tilePressed}) {
    return Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              height: AppConfig(context).height / 5,
              color: Color.fromARGB(255, 20, 101, 22),
              child: Image(image: AssetImage("images/appicon.png")),
            ),
            const SizedBox(
              height: 5,
            ),
            DrawerTile().tile(
              context: context,
              icon: Icons.person,
              tileName: "Profile",
              onPressed: () {
                Get.to(() => ProfileScreen());
                tilePressed();
              },
            ),
            DrawerTile().tile(
              context: context,
              icon: Icons.av_timer,
              tileName: "Pending Orders",
              onPressed: () {
                Get.to(() => PendingOrdersUserScreen());
                tilePressed();
              },
            ),
            DrawerTile().tile(
              context: context,
              icon: Icons.check_box_sharp,
              tileName: "Completed Orders",
              onPressed: () {
                Get.to(() => CompletedOrdersUserScreen());
                tilePressed();
              },
            ),
            DrawerTile().tile(
              context: context,
              icon: Icons.cancel,
              tileName: "Cancelled Orders",
              onPressed: () {
                Get.to(() => CancelOrderScreen());
                tilePressed();
              },
            ),
            DrawerTile().tile(
              context: context,
              icon: Icons.content_paste_go_rounded,
              tileName: "Image Order Status",
              onPressed: () {
                Get.to(() => RxOrdersStatusScreen());
                tilePressed();
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Divider(
              endIndent: 10,
              indent: 10,
              thickness: 1,
              color: Colors.black.withOpacity(0.2),
            ),
            DrawerTile().tile(
                context: context,
                icon: Icons.logout_outlined,
                tileName: "Log Out",
                onPressed: (() {
                  LocalDataSaver.setEmail("");
                  LocalDataSaver.setName("");
                  LocalDataSaver.setUserId("");

                  Get.offAll(() => LoginScreen());
                })),
          ],
        ));
  }
}
