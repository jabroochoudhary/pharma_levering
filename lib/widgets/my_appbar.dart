import 'package:flutter/material.dart';

import 'app_text.dart';

class MyAppBar {
  detailsAppBar({
    required BuildContext context,
    String? title,
    bool isCenterTitle = false,
    bool isBackButton = false,
    bool isActionIcon = false,
    Color titleColor = Colors.green,
    GestureTapCallback? onDrawerPressed,
    GestureTapCallback? onBackButtonPressed,
    GestureTapCallback? actionIconPressed,
  }) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.height;

    return AppBar(
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      centerTitle: isCenterTitle,
      leading: isBackButton
          ? IconButton(
              onPressed: onBackButtonPressed,
              icon: Icon(
                Icons.arrow_back,
                size: 25,
                weight: 20,
                color: titleColor,
              ),
            )
          : IconButton(
              onPressed: onDrawerPressed,
              icon: const Icon(
                Icons.menu_sharp,
                size: 25,
                weight: 20,
                color: Colors.white,
              ),
            ),
      title: AppText.text(
        title,
        color: Colors.white,
        fontsize: 18,
        fontweight: FontWeight.w600,
      ),
      actions: isActionIcon
          ? [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18,
                child: Center(
                  child: InkWell(
                      onTap: actionIconPressed,
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.grey,
                      )),
                ),
              ),
              const SizedBox(
                width: 15,
              )
            ]
          : [],
      bottomOpacity: 0.0,
      elevation: 0.0,
      // flexibleSpace: Container(
      //   height: 100,
      //   color: Colors.green,
      // ),
    );
  }
}
