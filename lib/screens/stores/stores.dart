import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/Network%20Services/firebase_collection_name.dart';
import 'package:e_medicine_shop/screens/stores/store_view_model.dart';
import 'package:e_medicine_shop/screens/stores/stores_items_view.dart';
import 'package:e_medicine_shop/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoresScreen extends StatelessWidget {
  final _controller = Get.put(StoreViewModal());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().detailsAppBar(
        context: context,
        isBackButton: true,
        isCenterTitle: true,
        onBackButtonPressed: () => Get.back(),
        title: "Stores around you",
        titleColor: Colors.white,
      ),
      body: Obx(
        () => Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(CollectionName.storeCollection)
                .where("city", isEqualTo: _controller.userCity.value)
                .where("state", isEqualTo: _controller.userState.value)
                .snapshots(),
            builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.docs.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final res = snapshot.data!.docs[index];
                          return Card(
                            color: const Color.fromARGB(255, 73, 155, 100),
                            elevation: 6,
                            child: InkWell(
                              onTap: () {
                                Get.to(() => StoresItemsView(
                                    res.id, "${res['storeName']}"));
                              },
                              child: Container(
                                  height: 70,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 3),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${res['storeName']}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${res['city']}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: const [
                                          Text(
                                            "Tab to explore store ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Please make sure your internet connection is stable.\n OR \n No store in your area.",
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
        ),
      ),
    );
    // throw UnimplementedError();
  }
}
