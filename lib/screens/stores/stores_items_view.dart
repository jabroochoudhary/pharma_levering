import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Admin Side/Add Item/add_item_view_modal.dart';
import '../../Network Services/firebase_collection_name.dart';
import '../detailscreen/item_detail_screen.dart';
import '../homepage/item_card_component.dart';

class StoresItemsView extends StatelessWidget {
  String storeId;
  String storeName;
  StoresItemsView(this.storeId, this.storeName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().detailsAppBar(
        context: context,
        isBackButton: true,
        isCenterTitle: true,
        onBackButtonPressed: () => Get.back(),
        title: storeName,
        titleColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(CollectionName.itemsCollection)
              .where("storeId", isEqualTo: storeId)
              .snapshots(),
          builder: (context, secondsnapshot) {
            if (secondsnapshot.hasData) {
              final items = secondsnapshot.data!.docs;
              return items.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      primary: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int indexitem) {
                        return ItemCardComponent().card(
                          itemUrl: items[indexitem]['imageUrl'],
                          itemName: items[indexitem]['name'],
                          itemdesc: items[indexitem]['desc'],
                          itemPrice: items[1]['price'].toString(),
                          onPressed: () {
                            final data = AddItemModal.fromJson(items[indexitem]
                                .data() as Map<String, dynamic>);

                            Get.to(() => ItemDetailScreen(
                                  data,
                                  storeName,
                                ));
                          },
                        );
                      })
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
    );
  }
}
