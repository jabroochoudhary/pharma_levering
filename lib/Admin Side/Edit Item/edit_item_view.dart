import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/Admin%20Side/Edit%20Item/edit_view_model.dart';
import 'package:e_medicine_shop/Admin%20Side/Edit%20Item/item_update_view.dart';
import 'package:e_medicine_shop/App%20Services/LocalDataSaver.dart';
import 'package:e_medicine_shop/Network%20Services/firebase_collection_name.dart';
import 'package:e_medicine_shop/main.dart';
import 'package:e_medicine_shop/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Add Item/add_item_view_modal.dart';

class EditItemView extends StatelessWidget {
  EditItemView({Key? key}) : super(key: key);
  final _controller = Get.put(EditViewModal());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar().detailsAppBar(
            context: context,
            title: "Items List",
            isBackButton: true,
            isCenterTitle: true,
            onBackButtonPressed: () => Get.back(),
            titleColor: Colors.white),
        body: Obx(
          () => StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(CollectionName.itemsCollection)
                  .where('storeId', isEqualTo: _controller.storeDocId.value)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.docs.isNotEmpty
                      ? ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final res = snapshot.data!.docs[index];
                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (v) {
                                _controller.deleteItem(res.id, res['imageUrl']);
                                // displayMessage("Item Deleted");
                              },
                              background: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              child: Card(
                                color: const Color.fromARGB(255, 73, 155, 100),
                                elevation: 6,
                                child: ExpansionTile(
                                  title: Text(
                                    "${res['name']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: IconButton(
                                    onPressed: () {
                                      Get.to(() => ItemUpdateView(res.id));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.orange,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              color: Colors.orange,
                                              child: Text(
                                                "${res['price']}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Please make sure your internet connection is stable.\n OR \n No item exsist",
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
        ));
  }
}
