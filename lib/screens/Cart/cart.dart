import 'package:e_medicine_shop/screens/Cart/cart_view_model.dart';
import 'package:e_medicine_shop/screens/confirmation/confirmation_page.dart';
// import 'package:e_medicine_shop/screens/payment/payment_screen.dart';
import 'package:e_medicine_shop/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../appColors/app_colors.dart';
import '../detailscreen/item_details_view_model.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _controller = Get.put(CartViewModel());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: MyAppBar().detailsAppBar(
          context: context,
          title: "Cart Items",
          isBackButton: true,
          isCenterTitle: true,
          onBackButtonPressed: () => Get.back(),
          titleColor: Colors.white,
        ),
        body: Container(
          child: _controller.totalItemsInCart.value > 0
              ? ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _controller.shopName.value.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // height: 400,
                      child: FutureBuilder(
                          future: _controller.readCart(),
                          builder: (ctx, snapshot) {
                            List<cartRead> cartitems =
                                snapshot.data as List<cartRead>;

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
                                return Card(
                                  child: Container(
                                    height: 100,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: Text(
                                                cartitems[index]
                                                        .name[0]
                                                        .toUpperCase() +
                                                    cartitems[index]
                                                        .name
                                                        .substring(1),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10,
                                              ),
                                              child: Text(
                                                cartitems[index].desc,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 192, 191, 191),
                                                  radius: 10,
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: const Icon(
                                                      Icons.remove,
                                                      size: 15,
                                                    ),
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      _controller
                                                          .decrementItemPrice(
                                                              cartitems[index]
                                                                  .id,
                                                              cartitems[index]
                                                                  .quantity,
                                                              cartitems[index]
                                                                  .price,
                                                              cartitems[index]
                                                                  .total);
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  child: Text(
                                                    cartitems[index].quantity,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                CircleAvatar(
                                                  backgroundColor: Colors.green,
                                                  radius: 10,
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: const Icon(
                                                      Icons.add,
                                                      size: 15,
                                                    ),
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      _controller
                                                          .incrimentItemPrice(
                                                              cartitems[index]
                                                                  .id,
                                                              cartitems[index]
                                                                  .quantity,
                                                              cartitems[index]
                                                                  .price,
                                                              cartitems[index]
                                                                  .total);
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                cartitems[index].total,
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                    const Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 1,
                      color: Colors.grey,
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Subtotal",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Rs. ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _controller.subtotalCart.value.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Delivery fee",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Rs. ",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "50.0",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    "No Item in cart\n\nSelect items from your favourite shop",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _controller.totalItemsInCart.value > 0
            ? Container(
                color: Colors.white,
                height: 120,
                // color: Colors.red,
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Net Total",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Rs. ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                !_controller.isCronicDisease.value
                                    ? (50 + _controller.subtotalCart.value)
                                        .toString()
                                    : (_controller.subtotalCart.value -
                                            (_controller.subtotalCart.value *
                                                0.05) +
                                            50)
                                        .toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.location_on,
                        size: 25,
                        color: Colors.white,
                      ),
                      label: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Text(
                          "Review payment and address",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Get.to(() => ConfirmationPage(
                              isCronic: _controller.isCronicDisease.value,
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.baseDarkPinkColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}
