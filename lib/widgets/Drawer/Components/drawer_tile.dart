import 'package:flutter/material.dart';

import '../../app_config.dart';
import '../../app_text.dart';

class DrawerTile {
  tile(
      {required BuildContext context,
      required IconData icon,
      required String tileName,
      double iconSize = 25,
      double fontSize = 15,
      GestureTapCallback? onPressed}) {
    return SizedBox(
      height: 45,
      child: ListTile(
        // tileColor: Colors.red,
        onTap: onPressed,

        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: Colors.green.withOpacity(0.7),
            ),
            SizedBox(
              width: AppConfig(context).width / 15,
            ),
            AppText.text(
              tileName,
              color: Colors.black,
              fontsize: fontSize,
              fontweight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
