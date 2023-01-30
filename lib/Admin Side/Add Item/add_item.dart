import 'dart:io';

import 'package:e_medicine_shop/Admin%20Side/Add%20Item/add_item_view_modal.dart';
import 'package:e_medicine_shop/appColors/app_colors.dart';
import 'package:e_medicine_shop/widgets/app_text.dart';
import 'package:e_medicine_shop/widgets/my_appbar.dart';
import 'package:e_medicine_shop/widgets/my_textfromfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddNewItem extends StatefulWidget {
  AddNewItem({Key? key}) : super(key: key);

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  final _controller = Get.put(AddItemViewModal());

  File? pickedImage;
  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
        _controller.pickedFile = pickedImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().detailsAppBar(
          context: context,
          title: "Add Item",
          isBackButton: true,
          onBackButtonPressed: () => Get.back(),
          isCenterTitle: true,
          titleColor: Colors.white),
      body: Obx(
        () => ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            MyTextFromField(
              hintText: "Item name",
              obscureText: false,
              controller: _controller.itemNameController.value,
            ),
            MyTextFromField(
              hintText: "Item Description",
              obscureText: false,
              controller: _controller.itemDescController.value,
            ),
            MyTextFromField(
              hintText: "Formula",
              obscureText: false,
              controller: _controller.itemFormulaController.value,
            ),
            MyTextFromField(
              hintText: "Item price/pack",
              obscureText: false,
              controller: _controller.itemPriceController.value,
              isNumber: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _controller.isTablet.value,
                        activeColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        onChanged: (value) {
                          _controller.isTablet.value = value!;
                        },
                      ),
                      AppText.text("Tablets", color: AppColors.baseBlackColor),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _controller.isCapsule.value,
                        activeColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        onChanged: (value) {
                          _controller.isCapsule.value = value!;
                        },
                      ),
                      AppText.text("Capsule", color: AppColors.baseBlackColor),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _controller.isInjection.value,
                        activeColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        onChanged: (value) {
                          _controller.isInjection.value = value!;
                        },
                      ),
                      AppText.text("Injection",
                          color: AppColors.baseBlackColor),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _controller.isSyrup.value,
                        activeColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        onChanged: (value) {
                          _controller.isSyrup.value = value!;
                        },
                      ),
                      AppText.text("Syrup", color: AppColors.baseBlackColor),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _controller.isPowder.value,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        activeColor: Colors.green,
                        onChanged: (value) {
                          _controller.isPowder.value = value!;
                        },
                      ),
                      AppText.text("Powder", color: AppColors.baseBlackColor),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.text(
                    "Is cronic diseas item?",
                    color: Color.fromARGB(255, 45, 96, 47),
                    fontsize: 18,
                    fontweight: FontWeight.w500,
                  ),
                  Switch(
                    value: _controller.iscronic.value,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      _controller.iscronic.value = value;
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.text(
                    "Is item in stock?",
                    color: Color.fromARGB(255, 0, 90, 163),
                    fontsize: 18,
                    fontweight: FontWeight.w500,
                  ),
                  Switch(
                    value: _controller.isInStock.value,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      _controller.isInStock.value = value;
                    },
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                imagePickerOption();
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.10),
                width: MediaQuery.of(context).size.width * 0.50,
                height: MediaQuery.of(context).size.width * 0.60,
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: pickedImage != null
                      ? Image.file(
                          pickedImage!,
                          // width: 170,
                          // height: 170,
                          fit: BoxFit.contain,
                        )
                      : const Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        _controller.addItemFirebase();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                      child: Container(
                          height: 60,
                          child: Center(
                            child: AppText.text(
                              "Add Item",
                              color: Colors.white,
                              fontsize: 18,
                              fontweight: FontWeight.w500,
                            ),
                          )),
                    ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
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
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
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
}
