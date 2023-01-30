import 'dart:io';
import 'package:e_medicine_shop/screens/Cart/cart.dart';
import 'package:e_medicine_shop/screens/order/rx_store_list.dart';
import 'package:e_medicine_shop/widgets/app_notification.dart';
import 'package:e_medicine_shop/widgets/my_textfromfield_widget.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import '/screens/homepage/home_page.dart';
import 'package:get/get.dart';
import '../../appColors/app_colors.dart';
import '../../widgets/my_button_widget.dart';
import 'package:image_picker/image_picker.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.green,
    elevation: 0.0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
    title: Column(
      children: const [
        Text(
          "Send Prescription to Pharmacy!",
          style: TextStyle(color: AppColors.baseWhiteColor, fontSize: 12),
        ),
        Text(
          "Select your faviourite Stores and chose items",
          style: TextStyle(
            color: AppColors.baseWhiteColor,
            fontSize: 10,
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        onPressed: () => Get.to(() => Cart()),
        icon: Icon(Icons.shopping_cart),
      ),
    ],
  );
}

class _OrderScreenState extends State<OrderScreen> {
  Widget buildTopPart() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: imagePickerOption, // Image tapped
          child: ClipRect(
            child: pickedImage != null
                ? Image.file(
                    pickedImage!,
                    // width: 170,
                    // height: 170,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'images/slimg.png',
                    fit: BoxFit.cover, // Fixes border issues
                  ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(15.0),
                child: MyButtonwidget(
                  text: "Next",
                  color: AppColors.baseDarkGreenColor,
                  onPress: () {
                    if (pickedImage != null) {
                      Get.to(() => RxStoreList(
                          pickedImage,
                          mesgController.text.isNotEmpty
                              ? mesgController.text
                              : "No message with this preception."));
                    } else {
                      AppNotification().hint(
                          title: "Invalid",
                          message: "Please upload image to proceed.");
                    }
                  }, //here add record  in database
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(15.0),
                child: MyButtonwidget(
                  text: "Cancel",
                  color: AppColors.baseDarkGreenColor,
                  onPress: () {
                    Get.back();
                  }, //here add record  in database
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  File? pickedImage;
  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  final mesgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildAppBar(context),
                  MyTextFromField(
                    hintText: "Message",
                    obscureText: false,
                    lines: 3,
                    controller: mesgController,
                  ),
                  buildTopPart(),

                  //buildBottomPart(context: context),
                ],
              )
            ],
          ),
        ),
      ),
    );
    // throw UnimplementedError();
  }
}
