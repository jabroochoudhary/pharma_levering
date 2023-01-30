import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/App%20Services/LocalDataSaver.dart';
import 'package:e_medicine_shop/Network%20Services/firebase_collection_name.dart';
import 'package:get/get.dart';

class ProfileScreenViewModel extends GetxController {
  user(String userDocId) {
    if (userDocId.length > 5) {
      getDataUsingDocId(userDocId);
    } else {
      getData();
    }
  }

  RxString username = "".obs;
  RxString useremail = "".obs;
  RxString usermobile = "".obs;
  RxString userAddress = "".obs;
  RxString country = "".obs;
  RxString state = "".obs;
  RxString city = "".obs;

  RxString docId = "".obs;
  RxBool isLoading = true.obs;
  final _firebase = FirebaseFirestore.instance;

  getData() async {
    await _firebase
        .collection(CollectionName.userCollection)
        .doc(await LocalDataSaver.getUserId())
        .get()
        .then((value) {
      username.value = value['fullname'];
      useremail.value = value['email'];
      userAddress.value = value['address'];
      country.value = value['country'];
      state.value = value['state'];
      city.value = value['city'];
      usermobile.value = value['phonenumber'];
      docId.value = value.id;
    });
    isLoading.value = false;
  }

  void getDataUsingDocId(String userDocId) async {
    await _firebase
        .collection(CollectionName.userCollection)
        .doc(userDocId)
        .get()
        .then((value) {
      username.value = value['fullname'];
      useremail.value = value['email'];
      userAddress.value = value['address'];
      country.value = value['country'];
      state.value = value['state'];
      city.value = value['city'];
      usermobile.value = value['phonenumber'];
      docId.value = value.id;
    });
    isLoading.value = false;
  }
}
