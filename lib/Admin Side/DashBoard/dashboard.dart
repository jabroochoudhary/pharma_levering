import '/Admin%20Side/alltimeorders/all_time_orders_admin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../widgets/size_config.dart';
import '/Admin%20Side/Add%20Item/add_item.dart';
import '/Admin%20Side/admin_drawer.dart';
import '/Admin%20Side/pandingordersadmin/panding_orders_admin_screen.dart';
import '/Admin%20Side/rxordersadmin/admin_rx_order_screen.dart';
import '/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DashBoardAdmin extends StatefulWidget {
  DashBoardAdmin({Key? key}) : super(key: key);

  @override
  State<DashBoardAdmin> createState() => _DashBoardAdminState();
}

class _DashBoardAdminState extends State<DashBoardAdmin> {
  ///////////////////
  ///     Notificationss
  late AndroidNotificationChannel channel;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // String thisDeviceToken = "";
  @override
  void initState() {
    requestPermission();
    loadFcm();
    listenFcm();

    // getToken();
    FirebaseMessaging.instance.subscribeToTopic("Shops");
    super.initState();
  }

  void listenFcm() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              playSound: true,
              color: Colors.orange,

              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!\nm\nh\ng\n');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    notification.title!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  content: Text(notification.body! +
                      "\nClick open to view details of order."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.to(() => AllTimeAdminOrders());
                      },
                      child: const Text(
                        "Open",
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  ],
                ));
      }
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted pervisional permission");
    } else {
      print("User undeclined permission");
    }
  }

  void loadFcm() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
        enableLights: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  //////////////////
  List caption = [
    "Panding Orders",
    "Completed Orders",
    "Rx Orders",
    "Add Item",
  ];

  List logo = [
    "images/panding.json",
    "images/complete.json",
    "images/rxorder.json",
    "images/additem.json",
  ];

  List<dynamic> pages = [
    PandingOrdersAdminScreen(),
    PandingOrdersAdminScreen(isCompleteOrder: true),
    AdminRxOrdersScreen(),
    AddNewItem(),
  ];

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: AdminDrawer().drawer(),
      appBar: MyAppBar().detailsAppBar(
        context: context,
        title: "DashBoard",
        isCenterTitle: true,
        onDrawerPressed: () {
          _scaffoldkey.currentState!.openDrawer();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 3,
              ),
              SizedBox(
                height: 100,
              ),
              GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 40.0,
                ),
                itemCount: caption.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(pages[index]);
                      // print(pages[index]);
                      // Navigator.push(context, CustomTransition(pages[index]));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 130,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 76, 175, 109),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            child: Lottie.asset(logo[index]),
                            height: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              caption[index],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
