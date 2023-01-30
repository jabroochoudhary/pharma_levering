import 'package:e_medicine_shop/widgets/app_config.dart';
import 'package:e_medicine_shop/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemCardComponent {
  card({
    String? itemName,
    String? itemPrice,
    String? itemUrl,
    String? itemdesc,
    GestureTapCallback? onPressed,
    bool isInStock = false,
    bool isTablet = true,
    bool isCapsule = true,
    bool isSyrup = true,
    bool isPowder = true,
    bool isInjection = true,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // height: 200,
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 234, 234, 234),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  image: itemUrl.toString().length < 2
                      ? DecorationImage(image: AssetImage("images/bc.png"))
                      : DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            itemUrl!,
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    itemName!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    itemdesc!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\u{20A8} ${itemPrice!}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      !isInStock
                          ? const Text(
                              "Out stock",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(
                              "In stock",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      isTablet
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: FaIcon(
                                FontAwesomeIcons.tablets,
                                size: 15,
                                color: Colors.pink,
                              ),
                            )
                          : SizedBox(),
                      isCapsule
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: FaIcon(
                                FontAwesomeIcons.pills,
                                size: 15,
                                color: Colors.red,
                              ),
                            )
                          : SizedBox(),
                      isSyrup
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: FaIcon(
                                FontAwesomeIcons.bottleWater,
                                size: 15,
                                color: Colors.grey,
                              ),
                            )
                          : SizedBox(),
                      isInjection
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: FaIcon(
                                FontAwesomeIcons.syringe,
                                size: 15,
                                color: Colors.green,
                              ),
                            )
                          : SizedBox(),
                      isPowder
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: FaIcon(
                                FontAwesomeIcons.slack,
                                size: 15,
                                color: Colors.black,
                              ),
                            )
                          : SizedBox(),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  card2({
    String? itemName,
    String? itemPrice,
    String? itemUrl,
    String? itemdesc,
    String? formula,
    GestureTapCallback? onPressed,
    bool isInStock = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 120,
        margin: EdgeInsets.all(10.0),
        // padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 244, 244, 244),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topRight,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                image: itemUrl.toString().length < 2
                    ? DecorationImage(image: AssetImage("images/bc.png"))
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          itemUrl!,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    itemName!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.green),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Text(
                    itemdesc!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color.fromARGB(255, 58, 84, 58),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\u{20A8} ${itemPrice!}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      !isInStock
                          ? const Text(
                              "Out stock",
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            )
                          : const Text(
                              "In stock",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    width: 200,
                    child: AppText.text(
                      formula,
                      textAlignment: TextAlign.start,
                      color: Colors.pink,
                      maxlines: 2,
                      fontsize: 13,
                      fontweight: FontWeight.w400,
                      feildOverFlow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }
}
