import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/Admin%20Side/pandingordersadmin/panding_orders_admin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_medicine_shop/main.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:intl/date_symbol_data_local.dart';
import '../../Network Services/firebase_collection_name.dart';
import '../../widgets/app_text.dart';
import '../../widgets/my_appbar.dart';
import '../ordersadmindetail/admin_order_detail_screen.dart';

class PandingOrdersAdminScreen extends StatelessWidget {
  bool isCompleteOrder;
  PandingOrdersAdminScreen({this.isCompleteOrder = false, Key? key})
      : super(key: key);
  final _controller = Get.put(PandingOrdersAdminViewModel());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: MyAppBar().detailsAppBar(
            context: context,
            isBackButton: true,
            isCenterTitle: true,
            title: isCompleteOrder ? "Completed orders" : "Pending orders",
            titleColor: Colors.white,
            onBackButtonPressed: () => Get.back(),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(CollectionName.masterOrderCollectinName)
                .where("storeid", isEqualTo: _controller.userid.value)
                .where("ispanding", isEqualTo: isCompleteOrder ? false : true)
                .where("iscancel", isEqualTo: false)
                .snapshots(),
            builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.docs.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          int? len = snapshot.data?.docs.length;

                          final res = snapshot.data!.docs[len! - index - 1];
                          DateTime placedAt = res['placedAt'].toDate();

                          return InkWell(
                            onTap: () => Get.to(
                              () => AdminOrderDetailsScreen(
                                  total: res['ordertotal'],
                                  isCancel: res['iscancel'],
                                  isAccept: res["isaccept"],
                                  masterOrderId: res.id,
                                  shopName: res["orderusername"],
                                  customerDocId: res['orderid'],
                                  isDeliverd: res["ispanding"]),
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 2,
                              margin: EdgeInsets.all(15),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                height: 170,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText.text(
                                      res["orderusername"],
                                      color: Colors.white,
                                      fontsize: 25,
                                      fontweight: FontWeight.w600,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText.text("Order ID",
                                            color: Colors.white),
                                        AppText.text(res.id.toString(),
                                            color: Colors.white),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText.text("Total Bill",
                                            color: Colors.white),
                                        AppText.text("Rs. ${res['ordertotal']}",
                                            color: Colors.white),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText.text("Order Date Time",
                                            color: Colors.white),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText.text(
                                                DateFormat.yMMMMd()
                                                    .format(placedAt),
                                                color: Colors.white),
                                            AppText.text(
                                                DateFormat.jms()
                                                    .format(placedAt),
                                                color: Colors.white),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText.text("", color: Colors.white),
                                        AppText.text(
                                            isCompleteOrder
                                                ? "Deliverd"
                                                : res["isaccept"]
                                                    ? "Delivery panding"
                                                    : "Tap to accept order",
                                            color: Colors.blue),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            isCompleteOrder
                                ? "No order is completed.\nModify your store items to get orders."
                                : "No order is pending.\nModify your store items to get orders.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
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
        ));
  }
}
