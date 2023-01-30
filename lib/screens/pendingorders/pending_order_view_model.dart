import 'package:e_medicine_shop/App%20Services/LocalDataSaver.dart';
import 'package:get/get.dart';

class PendingOrderViewModel extends GetxController {
  RxString userid = "".obs;

  @override
  void onInit() {
    loadVar();
    super.onInit();
  }

  void loadVar() async {
    userid.value = (await LocalDataSaver.getUserId())!;
  }
}
