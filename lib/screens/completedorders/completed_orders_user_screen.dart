import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/Network%20Services/firebase_collection_name.dart';
import 'package:e_medicine_shop/main.dart';
import 'package:e_medicine_shop/screens/singleorderdetails/single_order_detail_screen.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:intl/date_symbol_data_local.dart';
import 'package:e_medicine_shop/screens/pendingorders/pending_order_view_model.dart';
import 'package:e_medicine_shop/widgets/app_text.dart';
import 'package:e_medicine_shop/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletedOrdersUserScreen extends StatelessWidget {
  CompletedOrdersUserScreen({Key? key}) : super(key: key);
  final _controller = Get.put(PendingOrderViewModel());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: MyAppBar().detailsAppBar(
            context: context,
            isBackButton: true,
            isCenterTitle: true,
            title: "Completed orders",
            titleColor: Colors.white,
            onBackButtonPressed: () => Get.back(),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(CollectionName.masterOrderCollectinName)
                .where("orderid", isEqualTo: _controller.userid.value)
                .where("ispanding", isEqualTo: false)
                .snapshots(),
            builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.docs.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final res = snapshot.data!.docs[index];
                          DateTime placedAt = res['placedAt'].toDate();

                          return InkWell(
                            onTap: (() {
                              Get.to(() => SignleOrderDetailsScreen(
                                  total: res['ordertotal'],
                                  isCancel: res['iscancel'],
                                  isAccept: res["isaccept"],
                                  masterOrderId: res.id,
                                  shopName: res["storename"],
                                  isDeliverd: res["ispanding"]));
                            }),
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
                                      res["storename"],
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
                                        AppText.text("Deliverd",
                                            color: Colors.blue),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "No order is completed.\nYou can place order from your favorite store.",
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
        ));
  }
}
