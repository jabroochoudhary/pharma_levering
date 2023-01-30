import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/screens/Rx%20Orders/rx_order_status_view_model.dart';
// import 'package:e_medicine_shop/screens/Rx%20Orders%20Satus/rx_order_status_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_medicine_shop/main.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:intl/date_symbol_data_local.dart';
import '../../Network Services/firebase_collection_name.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/app_text.dart';
import '../../widgets/my_appbar.dart';

class RxOrdersStatusScreen extends StatelessWidget {
  RxOrdersStatusScreen({Key? key}) : super(key: key);
  final _controller = Get.put(RxOrderStatusViewModel());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: MyAppBar().detailsAppBar(
            context: context,
            isBackButton: true,
            isCenterTitle: true,
            title: "Rx Orders",
            titleColor: Colors.white,
            onBackButtonPressed: () => Get.back(),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(CollectionName.rxOrderCollection)
                .where("orderuser", isEqualTo: _controller.userid.value)
                // .orderBy("id")
                .snapshots(),
            builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.docs.isNotEmpty
                    ? ListView.builder(
                        // reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final res = snapshot.data!.docs[index];
                          DateTime placedAt =
                              DateTime.fromMillisecondsSinceEpoch(
                                  res['placedAt']);
                          String formattedTime =
                              DateFormat('kk:mm:a').format(placedAt);
                          DateFormat dateFormat = DateFormat("dd-MM-yyyy");
                          String date = dateFormat.format(placedAt);

                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 2,
                            margin: EdgeInsets.all(15),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.defaultDialog(
                                          title: "",
                                          contentPadding: EdgeInsets.all(0),
                                          content: Image(
                                              image: NetworkImage(
                                                  res['preceptionImageUrl'])));
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.30,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              res['preceptionImageUrl']),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppText.text(
                                                res['storeName'],
                                                color: Colors.green,
                                                fontsize: 18,
                                              ),
                                              Row(
                                                children: [
                                                  AppText.text(formattedTime,
                                                      color: Colors.green),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  AppText.text(date,
                                                      color: Colors.green),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              color: Colors.transparent,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 23),
                                              // margin: EdgeInsets.only(bottom: 20),
                                              child: !res['isPending']
                                                  ? Container(
                                                      child: AppText.text(
                                                          "Deliverd",
                                                          color: Colors.green),
                                                    )
                                                  : res['isAccept']
                                                      ? Container(
                                                          child: AppText.text(
                                                              "In Way",
                                                              color:
                                                                  Colors.blue),
                                                        )
                                                      : res['isCancel']
                                                          ? Container(
                                                              child: AppText.text(
                                                                  "Canceld",
                                                                  color: Colors
                                                                      .red),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                AppNotification()
                                                                    .dialogue(
                                                                  content:
                                                                      "Are you sure to cancel the order?",
                                                                  title:
                                                                      "Confirmation",
                                                                  onYesPressed:
                                                                      () {
                                                                    // Get.back();
                                                                    _controller
                                                                        .cancelRxOrder(
                                                                            res.id);
                                                                  },
                                                                );
                                                              },
                                                              child: AppText.text(
                                                                  "Cancel order",
                                                                  color: Colors
                                                                      .red),
                                                            )),
                                        ],
                                      ),
                                    ),
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
                            "No Rx Order status is available.\nYou can place order from your favorite store.",
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
