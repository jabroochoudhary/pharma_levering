import 'package:e_medicine_shop/App%20Services/LocalDataSaver.dart';
import 'package:get/get.dart';

class PandingOrdersAdminViewModel extends GetxController {
  RxString userid = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    initvar();
    super.onInit();
  }

  void initvar() async {
    userid.value = (await LocalDataSaver.getUserId())!;
    print(userid.value);
  }
}
