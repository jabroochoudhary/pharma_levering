import 'package:e_medicine_shop/Admin%20Side/Add%20Item/add_item_view_modal.dart';
import 'package:e_medicine_shop/screens/Cart/cart.dart';
import 'package:e_medicine_shop/screens/detailscreen/item_details_view_model.dart';
import 'package:e_medicine_shop/widgets/app_text.dart';
import 'package:e_medicine_shop/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/my_appbar.dart';

class ItemDetailScreen extends StatefulWidget {
  AddItemModal data;
  String storeName;
  bool isCart;
  ItemDetailScreen(this.data, this.storeName, {this.isCart = false, Key? key})
      : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final _controller = Get.put(ItemDetailsViewModel());
  @override
  void initState() {
    // TODO: implement initState
    _controller.getQty(widget.data);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double cronicPrice = widget.data.price! - (widget.data.price! * 0.05);
    if (widget.data.isCronic!) {
      _controller.totalItem.value =
          widget.data.price! - (widget.data.price! * 0.05);
    } else {
      _controller.totalItem.value = widget.data.price!;
    }

    return Scaffold(
      appBar: MyAppBar().detailsAppBar(
        context: context,
        isBackButton: true,
        isCenterTitle: true,
        onBackButtonPressed: () => Get.back(),
        title: "Item detail",
        titleColor: Colors.white,
      ),
      body: Obx(
        () => Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.80,
                  width: MediaQuery.of(context).size.width * 0.80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage(widget.data.imageUrl!),
                          fit: BoxFit.cover)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.text(
                          widget.data.name.toString().toUpperCase(),
                          color: Colors.green,
                          fontsize: 20,
                          fontweight: FontWeight.w500,
                        ),
                        widget.data.isInStock!
                            ? AppText.text(
                                "in stock",
                                color: Colors.blue,
                                fontsize: 14,
                                fontweight: FontWeight.w500,
                              )
                            : AppText.text(
                                "out of stack",
                                color: Colors.red,
                                fontsize: 14,
                                fontweight: FontWeight.w500,
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AppText.text(
                      widget.data.desc,
                      color: Colors.black,
                      fontsize: 15,
                      fontweight: FontWeight.w400,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.text(
                          "Price/pack",
                          color: Colors.black,
                          fontsize: 15,
                          fontweight: FontWeight.w400,
                        ),
                        widget.data.isCronic!
                            ? Text(
                                "Rs. ${widget.data.price}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              )
                            : SizedBox(),
                        widget.data.isCronic!
                            ? AppText.text(
                                "Rs. $cronicPrice",
                                color: Colors.green,
                                fontsize: 18,
                                fontweight: FontWeight.w500,
                              )
                            : Text(
                                "Rs. ${widget.data.price}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.text(
                          "Quantity",
                          color: Colors.black,
                          fontsize: 15,
                          fontweight: FontWeight.w500,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (!_controller.thisIsCatred.value) {
                                  _controller.qty.value += 1;
                                  if (widget.data.isCronic!) {
                                    _controller.totalItem.value =
                                        _controller.qty.value * cronicPrice;
                                  } else {
                                    _controller.totalItem.value =
                                        _controller.qty.value *
                                            widget.data.price!;
                                  }
                                }
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.blue,
                                size: 25,
                              ),
                            ),
                            Container(
                              // width: 1,
                              // height: 15,
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: AppText.text(
                                _controller.qty.value.toString(),
                                color: Colors.green,
                                fontsize: 18,
                                fontweight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (_controller.qty.value > 1 &&
                                    !_controller.thisIsCatred.value) {
                                  _controller.qty.value -= 1;
                                  if (widget.data.isCronic!) {
                                    _controller.totalItem.value =
                                        _controller.qty.value * cronicPrice;
                                  } else {
                                    _controller.totalItem.value =
                                        _controller.qty.value *
                                            widget.data.price!;
                                  }
                                }
                              },
                              child: const Icon(
                                Icons.remove,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.text(
                          "Total Price",
                          color: Colors.black,
                          fontsize: 15,
                          fontweight: FontWeight.w400,
                        ),
                        AppText.text(
                          "Rs. ${_controller.totalItem.value}",
                          color: Colors.green,
                          fontsize: 18,
                          fontweight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    widget.isCart
                        ? SizedBox()
                        : _controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                ),
                              )
                            : MyButtonwidget(
                                text: _controller.thisIsCatred.value
                                    ? "Carted"
                                    : "Add to cart",
                                color: _controller.thisIsCatred.value
                                    ? Colors.grey
                                    : Colors.green,
                                onPress: () {
                                  if (!_controller.thisIsCatred.value) {
                                    _controller.addToCart(
                                      data: widget.data,
                                      storeName: widget.storeName,
                                    );
                                  }
                                }),
                    const SizedBox(
                      height: 30,
                    ),
                    _controller.thisIsCatred.value
                        ? MyButtonwidget(
                            text: "View cart",
                            color: Colors.green,
                            onPress: () {
                              Get.to(() => Cart());
                            })
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
