import 'package:e_medicine_shop/screens/editprofilescreen/edit_profile_screen.dart';

import '/screens/confirmation/confirmation_view_model.dart';
import '/widgets/app_text.dart';
import '/widgets/my_appbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../appColors/app_colors.dart';
// import '../../routes/routes.dart';
import '../../widgets/my_button_widget.dart';

import '../detailscreen/item_details_view_model.dart';

class ConfirmationPage extends StatelessWidget {
  bool isCronic;
  ConfirmationPage({this.isCronic = false, Key? key}) : super(key: key);
  final _controller = Get.put(ConfirmationViewModel());
  Widget buildBottomPart(BuildContext context) {
    return SizedBox(
        height: 140,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Order total",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.baseBlackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Order amount",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.baseBlackColor,
                          ),
                        ),
                        Text(
                          "Delivery",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.baseBlackColor,
                          ),
                        ),
                        Text(
                          "Discount",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.baseBlackColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rs. ${!isCronic ? (50 + _controller.totalPrice.value).toString() : (_controller.totalPrice.value - (_controller.totalPrice.value * 0.05) + 50).toString()}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.baseBlackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Rs. ${_controller.totalPrice.value}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.baseBlackColor,
                          ),
                        ),
                        const Text(
                          "Rs. 50",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.baseBlackColor,
                          ),
                        ),
                        Text(
                          "Rs. -${isCronic ? _controller.totalPrice.value - (_controller.totalPrice.value - (_controller.totalPrice.value * 0.05)) : "0.0".toString()}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.baseBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
            SizedBox(
              height: 5,
            ),
            _controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.baseDarkPinkColor,
                    ),
                  )
                : Container(
                    color: AppColors.baseGrey10Color,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 23),
                    margin: EdgeInsets.only(bottom: 20),
                    child: MyButtonwidget(
                      color: AppColors.baseDarkPinkColor,
                      text: "Place Order",
                      onPress: () {
                        _controller.placeOrderFirebase(isCronic);
                      },
                    ),
                  ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: MyAppBar().detailsAppBar(
            context: context,
            isBackButton: true,
            isCenterTitle: true,
            onBackButtonPressed: () => Get.back(),
            title: "Place Order",
            titleColor: Colors.white,
          ),
          backgroundColor: AppColors.baseGrey10Color,
          body: ListView(
            // physics: NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Confirmation",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        "Your address",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    InkWell(
                      onDoubleTap: () {
                        Get.back();
                        Get.to(() => EditProfilescreen(
                              isFromOrder: true,
                            ));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200]),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        padding: EdgeInsets.all(10),
                        child: AppText.text(
                          _controller.addressController.value,
                          color: Colors.black,
                          textAlignment: TextAlign.start,
                          maxlines: 3,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        "Double tap to edit",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                  bottom: 20,
                ),
                child: const Text(
                  "Review Order List",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder(
                  future: CartModel.fetchCart(),
                  builder: (ctx, snapshot) {
                    List<cartRead> cartitems = snapshot.data as List<cartRead>;

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No item in cart yet."),
                      );
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cartitems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(
                                      cartitems[index].name.toString(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(cartitems[index].quantity),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  cartitems[index].total,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: buildBottomPart(context),
        ));
  }
}
