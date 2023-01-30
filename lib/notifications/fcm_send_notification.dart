import 'package:http/http.dart' as http;
import 'dart:convert';

class FcmNotifications {
  sendPushMessage(
      {String? title, String? body, String? thisDeviceToken}) async {
    try {
      ////
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=BLIJMT31UbSP1EwOKL6yYUFdmCh_oc9iEF05g7g7HyDrytNR-m-M0U8IhECDZICcFy5gZj1vk9HlN9LcI9Zo7Xg',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": "$thisDeviceToken",
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
}
