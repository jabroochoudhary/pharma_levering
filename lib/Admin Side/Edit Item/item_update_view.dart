import 'dart:io';

import 'package:e_medicine_shop/Admin%20Side/Edit%20Item/edit_view_model.dart';
import 'package:e_medicine_shop/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/app_text.dart';
import '../../widgets/my_textfromfield_widget.dart';

class ItemUpdateView extends StatefulWidget {
  String id;
  ItemUpdateView(this.id, {Key? key}) : super(key: key);

  @override
  State<ItemUpdateView> createState() => _ItemUpdateViewState(id);
}

class _ItemUpdateViewState extends State<ItemUpdateView> {
  String id;
  _ItemUpdateViewState(this.id);
  final _controller = Get.put(EditViewModal());

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
  void initState() {
    _controller.loadData(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().detailsAppBar(
        context: context,
        title: "Update Item",
        isBackButton: true,
        isCenterTitle: true,
        onBackButtonPressed: () => Get.back(),
        titleColor: Colors.white,
      ),
      body: Obx(
        () => ListView(
          children: [
            SizedBox(
              height: 30,
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
                    value: _controller.isCronic.value,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      _controller.isCronic.value = value;
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.text(
                    "Is item in stock?",
                    color: Colors.black,
                    fontsize: 16,
                    fontweight: FontWeight.w400,
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
                  // color: Colors.green[300],
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
                      : _controller.imageUrl.value.length < 2
                          ? SizedBox()
                          : Image.network(
                              _controller.imageUrl.value,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                    ),
                                  );
                                }
                              },
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
                        _controller.updateItemFirebase();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                      child: Container(
                          height: 60,
                          child: Center(
                            child: AppText.text(
                              "Update Item",
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
