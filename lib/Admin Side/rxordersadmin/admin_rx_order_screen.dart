import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/Admin%20Side/rxordersadmin/admin_rx_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:e_medicine_shop/main.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:intl/date_symbol_data_local.dart';

import '../../Network Services/firebase_collection_name.dart';
import '../../screens/profilescreen/profile_screen.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/app_text.dart';
import '../../widgets/my_appbar.dart';

class AdminRxOrdersScreen extends StatelessWidget {
  AdminRxOrdersScreen({Key? key}) : super(key: key);
  final _controller = Get.put(AdminRxOrderViewModel());

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
                .where("storeDoc", isEqualTo: _controller.userid.value)
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
                          int? len = snapshot.data?.docs.length;

                          final res = snapshot.data!.docs[len! - index - 1];
                          DateTime placedAt =
                              DateTime.fromMillisecondsSinceEpoch(
                                  res['placedAt']);
                          String formattedTime =
                              DateFormat('kk:mm:a').format(placedAt);
                          DateFormat dateFormat = DateFormat("dd-MM-yyyy");
                          String date = dateFormat.format(placedAt);

                          // print(placedAt);
                          // DateTime placedAt =
                          //     DateTime.fromMillisecondsSinceEpoch(
                          //         res['placedAt']);

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
                                              Row(
                                                children: [
                                                  AppText.text(
                                                    date,
                                                    color: Colors.black,
                                                    fontsize: 12,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  AppText.text(
                                                    formattedTime,
                                                    color: Colors.black,
                                                    fontsize: 12,
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () =>
                                                    Get.to(() => ProfileScreen(
                                                          isOnlyDetail: true,
                                                          userDocId:
                                                              res['orderuser'],
                                                        )),
                                                child: AppText.text(
                                                    "View customer detail",
                                                    color: Colors.blue),
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
                                                      ? InkWell(
                                                          onTap: () {
                                                            AppNotification()
                                                                .dialogue(
                                                              content:
                                                                  "Are you sure the order is deliverd?",
                                                              title:
                                                                  "Confirmation",
                                                              onYesPressed: () {
                                                                Get.back();
                                                                _controller
                                                                    .deliverOrder(
                                                                        res.id);
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            child: AppText.text(
                                                                "Panding delivery",
                                                                color: Colors
                                                                    .blue),
                                                          ),
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
                                                                      "Are you sure to accept the order?",
                                                                  title:
                                                                      "Confirmation",
                                                                  onYesPressed:
                                                                      () {
                                                                    Get.back();
                                                                    _controller
                                                                        .acceptOrder(
                                                                            res.id);
                                                                  },
                                                                );
                                                              },
                                                              child: _controller
                                                                      .isLoading
                                                                      .value
                                                                  ? const Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                    )
                                                                  : AppText.text(
                                                                      "Accept order",
                                                                      color: Colors
                                                                          .green),
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
