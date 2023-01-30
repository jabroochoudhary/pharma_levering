import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/Admin%20Side/DashBoard/dashboard.dart';
import 'package:e_medicine_shop/App%20Services/LocalDataSaver.dart';
import 'package:e_medicine_shop/Network%20Services/firebase_collection_name.dart';
import 'package:e_medicine_shop/screens/homepage/home_page.dart';
import 'package:e_medicine_shop/widgets/app_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class loginViewModel extends GetxController {
  RxBool isLoading = false.obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final nameController = TextEditingController().obs;
  final mobileController = TextEditingController().obs;
  final storeNameController = TextEditingController().obs;

  // final cPasswordController = TextEditingController().obs;
  final addressController = TextEditingController().obs;

  final _firebaseFirestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  RxBool isBussines = false.obs;
  RxString countryValue = "".obs;
  RxString stateValue = "".obs;
  RxString cityValue = "".obs;

  Future<bool> singupStore() async {
    bool issucess = false;
    if (countryValue.value == "🇵🇰    Pakistan") {
      if (emailController.value.text.isEmpty ||
          nameController.value.text.isEmpty ||
          passwordController.value.text.isEmpty ||
          mobileController.value.text.isEmpty ||
          addressController.value.text.isEmpty ||
          storeNameController.value.text.isEmpty ||
          countryValue.value.length < 2 ||
          stateValue.value.length < 2 ||
          cityValue.value.length < 2 ||
          !(emailController.value.text.contains("@"))) {
        AppNotification().hint(
            title: "Information",
            message: "Please fill all fields with proper data.");
      } else {
        // print("All is coreect");
        isLoading.value = true;
        final data = SignUpModelStore(
          address: addressController.value.text,
          email: emailController.value.text,
          city: cityValue.value,
          storeName: storeNameController.value.text,
          state: stateValue.value,
          country: countryValue.value,
          password: passwordController.value.text,
          phonenumber: mobileController.value.text,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          fulltname: nameController.value.text,
          deviceToken: await FirebaseMessaging.instance.getToken(),
        );
        issucess =
            await createFirebaseAccount(CollectionName.storeCollection, data);
        if (issucess) {
          Get.back();
          AppNotification()
              .sucess(title: "Sucess", message: "Account created sucessfully.");
        }
      }
    } else {
      AppNotification()
          .hint(title: "Information", message: "Country must be pakistan.");
    }
    return issucess;
  }

////create user
  ///
  ///
  Future<bool> singupUser() async {
    bool issucess = false;
    if (countryValue.value == "🇵🇰    Pakistan") {
      if (emailController.value.text.isEmpty ||
          nameController.value.text.isEmpty ||
          passwordController.value.text.isEmpty ||
          mobileController.value.text.isEmpty ||
          addressController.value.text.isEmpty ||
          countryValue.value.length < 2 ||
          stateValue.value.length < 2 ||
          cityValue.value.length < 2 ||
          !(emailController.value.text.contains("@"))) {
        AppNotification().hint(
            title: "Information",
            message: "Please fill all fields with proper data.");
      } else {
        // print("All is coreect");
        isLoading.value = true;
        final data = SignUpModelStore(
          address: addressController.value.text,
          email: emailController.value.text,
          city: cityValue.value,
          storeName: storeNameController.value.text,
          state: stateValue.value,
          country: countryValue.value,
          password: passwordController.value.text,
          phonenumber: mobileController.value.text,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          fulltname: nameController.value.text,
          deviceToken: await FirebaseMessaging.instance.getToken(),
        );
        issucess =
            await createFirebaseAccount(CollectionName.userCollection, data);
        if (issucess) {
          emailController.value.clear();
          passwordController.value.clear();
          Get.back();
          AppNotification()
              .sucess(title: "Sucess", message: "Account created sucessfully.");
        }
      }
    } else {
      AppNotification()
          .hint(title: "Information", message: "Country must be pakistan.");
    }
    return issucess;
  }

  login() async {
    isLoading.value = true;
    SignUpModelUser dataUser;
    SignUpModelStore dataStore;

    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: emailController.value.text,
          password: passwordController.value.text);
      if (user.user!.uid.isNotEmpty && (!isBussines.value)) {
        await _firebaseFirestore
            .collection(CollectionName.userCollection)
            .doc(user.user!.uid)
            .get()
            .then((value) async {
          dataUser =
              SignUpModelUser.fromJson(value.data() as Map<String, dynamic>);
          if (dataUser.email != emailController.value.text ||
              dataUser.password != passwordController.value.text) {
            throw Exception("Email or password is incorrect");
          }
          await LocalDataSaver.setEmail(dataUser.email.toString());
          await LocalDataSaver.setUserId(dataUser.id.toString());
          await LocalDataSaver.setName(dataUser.fulltname.toString());
          await LocalDataSaver.setIsShope(false);
        });
        /////
        ///     Seting up token
        String token = (await FirebaseMessaging.instance.getToken())!;
        await _firebaseFirestore
            .collection(CollectionName.userCollection)
            .doc(user.user!.uid)
            .update({'devicetoken': token}).then((value) async {
          await LocalDataSaver.setDeviceToken(token);
        });

        if (user.user!.uid.toString().length > 5) {
          isLoading.value = false;
          Get.to(() => HomePage());
          AppNotification()
              .sucess(title: "Sucess", message: "Account Login sucessfully.");
        }
      } else if (user.user!.uid.isNotEmpty && isBussines.value) {
        await _firebaseFirestore
            .collection(CollectionName.storeCollection)
            .doc(user.user!.uid)
            .get()
            .then((value) async {
          dataStore =
              SignUpModelStore.fromJson(value.data() as Map<String, dynamic>);
          if (dataStore.email != emailController.value.text ||
              dataStore.password != passwordController.value.text) {
            throw Exception("Email or password is icorrect");
          }
          await LocalDataSaver.setEmail(dataStore.email.toString());
          await LocalDataSaver.setUserId(dataStore.id.toString());
          await LocalDataSaver.setName(dataStore.fulltname.toString());
          await LocalDataSaver.setIsShope(true);
          // print(await LocalDataSaver.getUserId());
        });
        String token = (await FirebaseMessaging.instance.getToken())!;
        await _firebaseFirestore
            .collection(CollectionName.storeCollection)
            .doc(user.user!.uid)
            .update({'devicetoken': token}).then((value) async {
          await LocalDataSaver.setDeviceToken(token);
        });
        if (user.user!.uid.toString().length > 5) {
          isLoading.value = false;
          Get.to(() => DashBoardAdmin());
          AppNotification()
              .sucess(title: "Sucess", message: "Account Login sucessfully.");
        }
      }
    } catch (e) {
      isLoading.value = false;
      // print(e.toString());
      AppNotification()
          .error(title: "Error", message: " Email or password is incorrect.");
    }
  }

  Future<bool> createFirebaseAccount(
      String colName, SignUpModelStore data) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
          email: data.email.toString(), password: data.password.toString());
      data.id = user.user!.uid.toString();
      await _firebaseFirestore
          .collection(colName)
          .doc(data.id)
          .set(data.toJson());

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      AppNotification().error(
          title: "Error",
          message: "Network problem while connecting with internet.");
      return false;
    }
  }
}

class SignUpModelStore {
  String? fulltname;
  String? country;
  String? state;
  String? city;
  String? storeName;
  String? email;
  String? password;
  String? deviceToken;
  String? phonenumber;
  String? address;

  String? id;

  SignUpModelStore(
      {this.fulltname,
      this.email,
      this.password,
      this.deviceToken,
      this.phonenumber,
      this.address,
      this.storeName,
      this.id,
      this.country,
      this.state,
      this.city
      // this.image,
      // this.age
      });

  SignUpModelStore.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fulltname = json['fullname'];
    country = json['country'];
    email = json['email'];
    password = json['pass'];
    storeName = json['storeName'];

    deviceToken = json['devicetoken'];
    phonenumber = json['phonenumber'];
    address = json['address'];
    state = json['state'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['fullname'] = fulltname;
    data['country'] = country;
    data['email'] = email;
    data['pass'] = password;
    data['state'] = state;
    data['storeName'] = storeName;

    data['devicetoken'] = this.deviceToken;
    data['phonenumber'] = phonenumber;
    data['address'] = address;
    data['city'] = city;
    return data;
  }
}

class SignUpModelUser {
  String? fulltname;
  String? country;
  String? state;
  String? city;
  String? email;
  String? password;
  String? deviceToken;
  String? phonenumber;
  String? address;
  String? id;

  SignUpModelUser(
      {this.fulltname,
      this.email,
      this.password,
      // this.personalphonenumber,
      this.phonenumber,
      this.address,
      this.id,
      this.country,
      this.deviceToken,
      this.state,
      this.city
      // this.image,
      // this.age
      });

  SignUpModelUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fulltname = json['fullname'];
    country = json['country'];
    email = json['email'];
    password = json['pass'];

    deviceToken = json['devicetoken'];
    phonenumber = json['phonenumber'];
    address = json['address'];
    state = json['state'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['fullname'] = fulltname;
    data['country'] = country;
    data['email'] = email;
    data['pass'] = password;
    data['state'] = state;

    data['deviceoken'] = this.deviceToken;
    data['phonenumber'] = phonenumber;
    data['address'] = address;
    data['city'] = city;
    return data;
  }
}
