import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/../App%20Services/LocalDataSaver.dart';
import '/../Network%20Services/firebase_collection_name.dart';
import '/../widgets/app_notification.dart';
import 'package:firebase_storage/firebase_storage.dart' as refff;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemViewModal extends GetxController {
  RxBool isInStock = true.obs;
  RxBool isLoading = false.obs;
  RxBool isTablet = false.obs;
  RxBool isCapsule = false.obs;
  RxBool isInjection = false.obs;
  RxBool isSyrup = false.obs;
  RxBool isPowder = false.obs;
  RxBool iscronic = false.obs;

  final itemNameController = TextEditingController().obs;
  final itemDescController = TextEditingController().obs;

  final itemPriceController = TextEditingController().obs;
  final itemFormulaController = TextEditingController().obs;

  File? pickedFile;

  final _firebaseFirestore = FirebaseFirestore.instance;
  // final _firebaseStorage =FirebaseStorage.instance;

  addItemFirebase() async {
    if (pickedFile == null) {
      AppNotification().hint(
          title: "Inavlid", message: "Invalid form. PLease capture item image");
    } else {
      if (isTablet.value ||
          isCapsule.value ||
          isInjection.value ||
          isSyrup.value ||
          isPowder.value) {
        if (itemNameController.value.text.isEmpty ||
            itemDescController.value.text.isEmpty ||
            itemFormulaController.value.text.isEmpty ||
            itemPriceController.value.text.isEmpty) {
          AppNotification().hint(
              title: "Inavlid", message: "Fill all fields with proper data");
        } else {
          isLoading.value = true;
          String imageurl = await uploadImage(pickedFile);
          final userDocID = await LocalDataSaver.getUserId();

          final data = AddItemModal(
            desc: itemDescController.value.text,
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: itemNameController.value.text,
            price: double.parse(itemPriceController.value.text),
            isInStock: isInStock.value,
            storeId: userDocID,
            imageUrl: imageurl,
            isTablet: isTablet.value,
            isCapsule: isCapsule.value,
            isInjection: isInjection.value,
            isPowder: isPowder.value,
            isSyrup: isSyrup.value,
            formula: itemFormulaController.value.text,
            isCronic: iscronic.value,
          );

          try {
            await _firebaseFirestore
                .collection(CollectionName.itemsCollection)
                .doc(data.id)
                .set(data.toJson())
                .then((value) {
              itemNameController.value.clear();
              itemDescController.value.clear();
              itemPriceController.value.clear();
              pickedFile = null;
            });
            isLoading.value = false;
            AppNotification().sucess(
                title: "Sucess", message: "Item details uploaded successfully");
          } catch (e) {
            AppNotification().error(
                title: "Error",
                message: "Something went wrong while uuploading image.");
          }
        }
      } else {
        AppNotification().hint(
            title: "Inavlid", message: "Select at least one type of item.");
      }
    }
  }

  Future<String> uploadImage(File? pickedFile) async {
    String ids = DateTime.now().microsecondsSinceEpoch.toString();
    refff.Reference reff = refff.FirebaseStorage.instance
        .ref()
        .child("images")
        .child("items")
        .child("NoLoveEver" + ids);
    await reff.putFile(pickedFile!);
    return await reff.getDownloadURL();
  }
}

class AddItemModal {
  String? name;
  String? desc;
  String? formula;

  double? price;
  bool? isInStock;
  String? storeId;
  String? id;
  String? imageUrl;
  bool? isTablet;
  bool? isCapsule;
  bool? isInjection;
  bool? isSyrup;
  bool? isPowder;
  bool? isCronic;

  AddItemModal({
    this.name,
    this.desc,
    this.price,
    this.isInStock,
    this.storeId,
    this.imageUrl,
    this.id,
    this.isTablet,
    this.isCapsule,
    this.isInjection,
    this.isPowder,
    this.isSyrup,
    this.formula,
    this.isCronic,
  });

  AddItemModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    isInStock = json['isInStock'];
    storeId = json['storeId'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    isTablet = json['isTablet'];
    isCapsule = json['isCapsule'];
    isInjection = json['isInjection'];
    isSyrup = json['isSyrup'];
    isPowder = json['isPowder'];
    formula = json['formula'];
    isCronic = json['isCronic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['storeId'] = storeId;
    data['desc'] = desc;
    data['isInStock'] = isInStock;
    data['imageUrl'] = imageUrl;
    data['formula'] = formula;

    data['isTablet'] = isTablet;
    data['isCapsule'] = isCapsule;
    data['isInjection'] = isInjection;
    data['isSyrup'] = isSyrup;
    data['isPowder'] = isPowder;
    data['isCronic'] = isCronic;

    return data;
  }
}

class filterModel {
  String? name;
  String? desc;
  double? price;
  String? formula;

  bool? isInStock;
  String? storeId;
  String? id;
  String? imageUrl;
  String? shopName;
  bool? isTablet;
  bool? isCapsule;
  bool? isInjection;
  bool? isSyrup;
  bool? isPowder;
  bool? isCronic;

  filterModel({
    this.name,
    this.desc,
    this.price,
    this.isInStock,
    this.storeId,
    this.imageUrl,
    this.id,
    this.shopName,
    this.isCapsule,
    this.isInjection,
    this.isPowder,
    this.isSyrup,
    this.isTablet,
    this.formula,
    this.isCronic,
  });
}
