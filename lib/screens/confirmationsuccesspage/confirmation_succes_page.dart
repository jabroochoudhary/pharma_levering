import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../appColors/app_colors.dart';

import '../../svgimages/svg_images.dart';
import '../../widgets/my_button_widget.dart';
import '../homepage/home_page.dart';

class ConfirmationSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: const [
                        Text(
                          "Congratulations",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: AppColors.baseBlackColor,
                          ),
                        ),
                        Text(
                          "Your order is Placed",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: AppColors.baseBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: const [
                        Text(
                          "You will be notified when the order is accepted",
                          style: TextStyle(
                            color: AppColors.baseGrey40Color,
                          ),
                        ),
                        Text(
                          "and on the way.",
                          style: TextStyle(
                            color: AppColors.baseGrey40Color,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: MyButtonwidget(
              onPress: () {
                Get.back();
              },
              text: "Back to Home",
              color: AppColors.baseDarkPinkColor,
            ),
          ),
        ],
      ),
    );
  }
}
