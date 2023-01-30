import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/screens/profilescreen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../App Services/LocalDataSaver.dart';
import '../../Network Services/firebase_collection_name.dart';
import '../../widgets/app_notification.dart';

class EditProfileViewModel extends GetxController {
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  final username = TextEditingController().obs;
  final useremail = TextEditingController().obs;
  final usermobile = TextEditingController().obs;
  final userAddress = TextEditingController().obs;
  RxString country = "".obs;
  RxString state = "".obs;
  RxString city = "".obs;
  RxString docId = "".obs;
  final isLoading = true.obs;
  final _firebase = FirebaseFirestore.instance;

  getData() async {
    await _firebase
        .collection(CollectionName.userCollection)
        .doc(await LocalDataSaver.getUserId())
        .get()
        .then((value) {
      username.value.text = value['fullname'];
      useremail.value.text = value['email'];
      userAddress.value.text = value['address'];
      country.value = value['country'];
      state.value = value['state'];
      city.value = value['city'];
      usermobile.value.text = value['phonenumber'];
      docId.value = value.id;
    });
    isLoading.value = false;
  }

  updateAccount() async {
    if (country.value == "🇵🇰    Pakistan") {
      if (useremail.value.text.isEmpty ||
          username.value.text.isEmpty ||
          usermobile.value.text.isEmpty ||
          userAddress.value.text.isEmpty ||
          country.value.length < 2 ||
          state.value.length < 2 ||
          city.value.length < 2) {
        AppNotification().hint(
            title: "Information",
            message: "Please fill all fields with proper data.");
      } else {
        isLoading.value = true;
        await _firebase
            .collection(CollectionName.userCollection)
            .doc(docId.value)
            .update({
          "fullname": username.value.text,
          "address": userAddress.value.text,
          "phonenumber": usermobile.value.text,
          "country": country.value,
          "city": city.value,
          "state": state.value
        }).then((value) {
          isLoading.value = false;
          Get.off(ProfileScreen());
          AppNotification()
              .sucess(title: "Sucess", message: "Account created sucessfully.");
        });
      }
    } else {
      AppNotification()
          .hint(title: "Information", message: "Country must be pakistan.");
    }
  }
}
