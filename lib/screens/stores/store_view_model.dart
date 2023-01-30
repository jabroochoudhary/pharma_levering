import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/App%20Services/LocalDataSaver.dart';
import 'package:e_medicine_shop/Network%20Services/firebase_collection_name.dart';
import 'package:e_medicine_shop/screens/login/login_view_model.dart';
import 'package:get/get.dart';

class StoreViewModal extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getUserDta();
    super.onInit();
  }

  RxString userState = "".obs;
  RxString userCity = "".obs;
  RxBool isSortByName = true.obs;
  RxBool iSortByFormula = false.obs;


  getUserDta() async {
    final userDocId = await LocalDataSaver.getUserId();
    await FirebaseFirestore.instance
        .collection(CollectionName.userCollection)
        .doc(userDocId)
        .get()
        .then((value) {
      final data =
          SignUpModelUser.fromJson(value.data() as Map<String, dynamic>);
      userCity.value = data.city.toString();
      userState.value = data.state.toString();
    });
  }

////// searching methods
  RxString searchText = "".obs;
}
