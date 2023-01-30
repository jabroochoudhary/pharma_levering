import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import '/../Admin%20Side/Add%20Item/add_item_view_modal.dart';
import '/../App%20Services/LocalDataSaver.dart';
import '/../Network%20Services/firebase_collection_name.dart';
import '/../widgets/app_notification.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditViewModal extends GetxController {
  final _firbaaseFirestore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  RxString storeDocId = "".obs;

  @override
  void onInit() async {
    storeDocId.value = (await LocalDataSaver.getUserId())!;
    super.onInit();
  }

  deleteItem(String docid, String imgurl) async {
    await _firebaseStorage.refFromURL(imgurl).delete();
    await _firbaaseFirestore
        .collection(CollectionName.itemsCollection)
        .doc(docid)
        .delete()
        .then((value) => (value) {
              AppNotification()
                  .sucess(title: "Success", message: "Item is deleted");
            });
  }

  RxBool isInStock = true.obs;
  RxBool isLoading = false.obs;
  final itemNameController = TextEditingController().obs;
  final itemDescController = TextEditingController().obs;
  final itemFormulaController = TextEditingController().obs;

  RxString imageUrl = "".obs;
  RxString docId = "".obs;
  RxString storedoc = "".obs;
  final itemPriceController = TextEditingController().obs;
  File? pickedFile;
  RxBool isTablet = false.obs;
  RxBool isCapsule = false.obs;
  RxBool isInjection = false.obs;
  RxBool isSyrup = false.obs;
  RxBool isPowder = false.obs;
  RxBool isCronic = false.obs;

  updateItemFirebase() async {
    final imageNewURl;

    if (itemNameController.value.text.isEmpty ||
        itemDescController.value.text.isEmpty ||
        itemFormulaController.value.text.isEmpty ||
        itemPriceController.value.text.isEmpty) {
      AppNotification()
          .hint(title: "Inavlid", message: "Fill all fields with proper data");
    } else {
      isLoading.value = true;
      if (pickedFile == null) {
        imageNewURl = imageUrl.value.toString();
      } else {
        imageNewURl = await replaceImage(pickedFile);
      }
      final userDocID = await LocalDataSaver.getUserId();

      final data = AddItemModal(
        desc: itemDescController.value.text,
        id: docId.value,
        name: itemNameController.value.text,
        price: double.parse(itemPriceController.value.text),
        isInStock: isInStock.value,
        storeId: userDocID,
        imageUrl: imageNewURl,
        isTablet: isTablet.value,
        isCapsule: isCapsule.value,
        isInjection: isInjection.value,
        isPowder: isPowder.value,
        isSyrup: isSyrup.value,
        formula: itemFormulaController.value.text,
        isCronic: isCronic.value,
      );

      try {
        await _firbaaseFirestore
            .collection(CollectionName.itemsCollection)
            .doc(data.id)
            .update(data.toJson())
            .then((value) {
          itemNameController.value.clear();
          itemDescController.value.clear();
          itemPriceController.value.clear();
          itemFormulaController.value.clear();
          pickedFile = null;
        });
        isLoading.value = false;
        Get.back();
        AppNotification().sucess(
            title: "Sucess", message: "Item details uploaded successfully");
      } catch (e) {
        AppNotification().error(
            title: "Error",
            message: "Something went wrong while uuploading image.");
      }
    }
  }

  void loadData(String id) async {
    print(id);
    await _firbaaseFirestore
        .collection(CollectionName.itemsCollection)
        .doc(id)
        .get()
        .then((value) {
      final data = AddItemModal.fromJson(value.data() as Map<String, dynamic>);
      itemNameController.value.text = data.name.toString();
      itemDescController.value.text = data.desc.toString();
      itemFormulaController.value.text = data.formula.toString();
      isCapsule.value = data.isCapsule as bool;
      isTablet.value = data.isTablet as bool;
      isInjection.value = data.isInjection as bool;
      isSyrup.value = data.isSyrup as bool;
      isPowder.value = data.isPowder as bool;
      isCronic.value = data.isCronic as bool;

      itemPriceController.value.text = data.price.toString();
      isInStock.value = data.isInStock!;
      imageUrl.value = data.imageUrl.toString();
      print("Image url $imageUrl");
      docId.value = data.id.toString();
      storeDocId.value = data.storeId.toString();
    });
  }

  Future<String> replaceImage(File? pickedFile) async {
    await _firebaseStorage.refFromURL(imageUrl.value).delete();

    String ids = DateTime.now().microsecondsSinceEpoch.toString();
    final reff = _firebaseStorage
        .ref()
        .child("images")
        .child("items")
        .child("NoLoveEver" + ids);
    await reff.putFile(pickedFile!);
    return await reff.getDownloadURL();
  }
}
