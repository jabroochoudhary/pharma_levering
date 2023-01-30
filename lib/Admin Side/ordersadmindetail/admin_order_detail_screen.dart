import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/Admin%20Side/ordersadmindetail/admin_order_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Network Services/firebase_collection_name.dart';
import '../../screens/profilescreen/profile_screen.dart';
import '../../widgets/app_config.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/app_text.dart';
import '../../widgets/my_appbar.dart';
import '../../widgets/my_button_widget.dart';

class AdminOrderDetailsScreen extends StatelessWidget {
  String masterOrderId;
  String shopName;
  bool isDeliverd;
  double total;
  bool isCancel;
  bool isAccept;
  String customerDocId;
  AdminOrderDetailsScreen(
      {required this.total,
      required this.masterOrderId,
      required this.shopName,
      required this.isDeliverd,
      required this.isCancel,
      required this.isAccept,
      required this.customerDocId,
      Key? key})
      : super(key: key);
  final _controller = Get.put(AdminOrderDetailViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().detailsAppBar(
        context: context,
        isBackButton: true,
        isCenterTitle: true,
        title: shopName,
        titleColor: Colors.white,
        onBackButtonPressed: () => Get.back(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(CollectionName.detailMasterOrderCollectinName)
            .where("masterorderid", isEqualTo: masterOrderId)
            .snapshots(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.docs.isNotEmpty
                ? ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final res = snapshot.data!.docs[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                        margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: index == 0 ? 10 : 2,
                            bottom: index + 1 == (snapshot.data?.docs.length)
                                ? 200
                                : 2),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          width: MediaQuery.of(context).size.width,
                          // height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppText.text(
                                res['name'],
                                color: Colors.green,
                                fontsize: 18,
                                fontweight: FontWeight.w500,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText.text(
                                    "Price",
                                    color: Colors.green,
                                    fontsize: 14,
                                  ),
                                  AppText.text(
                                    "Rs. ${res['price']}",
                                    color: Colors.black,
                                    fontsize: 14,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText.text(
                                    "Quantity",
                                    color: Colors.green,
                                    fontsize: 14,
                                  ),
                                  AppText.text(
                                    res['qty'],
                                    color: Colors.black,
                                    fontsize: 14,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText.text(
                                    "Total",
                                    color: Colors.green,
                                    fontsize: 14,
                                  ),
                                  AppText.text(
                                    "Rs. ${res['total']}",
                                    color: Colors.black,
                                    fontsize: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "No order is pending.\nYou can place order from your favorite store.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 149, 155, 165)),
                      ),
                    ),
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: AppConfig(context).width,
        height: 200,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              tileColor: Colors.transparent,
              title: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Order total",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Order amount",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Delivery",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Padding(
                padding: EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Rs. $total",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Rs. " + (total - 50).toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Text(
                      "Rs. 50",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 23),
                    // margin: EdgeInsets.only(bottom: 20),
                    child: !isDeliverd
                        ? Container(
                            child:
                                AppText.text("Deliverd", color: Colors.green),
                          )
                        : isAccept
                            ? MyButtonwidget(
                                color: Colors.green,
                                text: "Deliver Order",
                                onPress: () {
                                  AppNotification().dialogue(
                                    content:
                                        "Are you sure is order is deliverd?",
                                    title: "Confirmation",
                                    onYesPressed: () {
                                      Get.back();

                                      _controller.deliverOrder(masterOrderId);
                                    },
                                  );
                                },
                              )
                            : isCancel
                                ? Container(
                                    child: AppText.text("Canceld by $shopName",
                                        color: Colors.red),
                                  )
                                : MyButtonwidget(
                                    color: Colors.green,
                                    text: "Accept Order",
                                    onPress: () {
                                      AppNotification().dialogue(
                                        content:
                                            "Are you sure to accept the order?",
                                        title: "Confirmation",
                                        onYesPressed: () {
                                          // Get.back();

                                          _controller
                                              .acceptOrder(masterOrderId);
                                        },
                                      );
                                    },
                                  ),
                  ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 23),
              child: MyButtonwidget(
                color: Colors.green,
                text: "View customer profile",
                onPress: () => Get.to(() => ProfileScreen(
                      isOnlyDetail: true,
                      userDocId: customerDocId,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
