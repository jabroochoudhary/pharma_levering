import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_medicine_shop/widgets/app_text.dart';
import '../../shortcutdata.dart';
import '/screens/pendingorders/panding_order_user_screen.dart';
import '/widgets/Drawer/app_drawer.dart';
import '/widgets/searchform.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/Admin%20Side/Add%20Item/add_item_view_modal.dart';
import '/screens/homepage/item_card_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Network Services/firebase_collection_name.dart';
import '../stores/store_view_model.dart';
import '/screens/order/order.dart';
import '/screens/stores/stores.dart';

import '../../widgets/shortcutwidget.dart';
// import '../../widgets/show_all_widget.dart';

import '../detailscreen/item_detail_screen.dart';
// import '../tabbar/tabbar_data.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                        Get.to(() => PendingOrdersUserScreen());
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
  Widget buildShortCuts() {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 10.0, right: 20.0),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: true,
        itemCount: ShortCutData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1,
        ),
        itemBuilder: (
          context,
          index,
        ) {
          var historyDataStore = ShortCutData[index];
          dynamic listname = ShortCutData[index].productName;
          return ShortCutWidget(
            productImage: historyDataStore.productImage,
            productName: historyDataStore.productName,
            onPressed: () {
              if (listname == "Order by image") {
                Get.to(() => OrderScreen());
              }
              if (listname == "Stores") {
                Get.to(() => StoresScreen());
              }
            },
          );
        },
      ),
    );
  }

  Widget buildAdvertismentPlace() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
          height: 160,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 400.0,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: [
              "https://csons.com.pk/app/pharmalev1.jpg",
              "https://csons.com.pk/app/pharmalev2.png",
              "https://csons.com.pk/app/pharmalev3.jpg",
              "https://csons.com.pk/app/pharmalev4.jpg",
            ].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(i),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          )),
    );
  }

  final _storeController = Get.put(StoreViewModal());

  List<filterModel> allItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer().drawer(context: context, tilePressed: () {}),
      appBar: buildAppBar(context),
      body: Obx(() => ListView(
            children: [
              _storeController.searchText.value.isNotEmpty
                  ? const SizedBox()
                  : buildAdvertismentPlace(),
              _storeController.searchText.value.isNotEmpty
                  ? const SizedBox(
                      height: 10,
                    )
                  : buildShortCuts(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchField().filed(onChange: (v) {
                  _storeController.searchText.value = v;
                }, onSubmit: (v) {
                  _storeController.searchText.value = v;
                }),
              ),
              !_storeController.searchText.value.isNotEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          AppText.text(
                            "Item search by ",
                            color: Colors.red,
                            fontsize: 18,
                            fontweight: FontWeight.w500,
                          ),
                          Checkbox(
                            value: _storeController.isSortByName.value,
                            activeColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            onChanged: (value) {
                              _storeController.isSortByName.value = value!;
                              _storeController.iSortByFormula.value =
                                  !_storeController.isSortByName.value;
                            },
                          ),
                          AppText.text("Name", color: Colors.black),
                          Checkbox(
                            value: _storeController.iSortByFormula.value,
                            activeColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            onChanged: (value) {
                              _storeController.iSortByFormula.value = value!;
                              _storeController.isSortByName.value =
                                  !_storeController.iSortByFormula.value;
                            },
                          ),
                          AppText.text("Formula", color: Colors.black),
                        ],
                      ),
                    ),
              _storeController.searchText.value.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(CollectionName.storeCollection)
                              .where("city",
                                  isEqualTo: _storeController.userCity.value)
                              .where("state",
                                  isEqualTo: _storeController.userState.value)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> snapshotStore) {
                            if (snapshotStore.hasData) {
                              allItems.clear();
                              return snapshotStore.data!.docs.isNotEmpty
                                  ? ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      primary: true,
                                      itemCount:
                                          snapshotStore.data!.docs.length,
                                      itemBuilder: (BuildContext context,
                                          int indexStore) {
                                        String storeId = snapshotStore
                                            .data!.docs[indexStore]['id']
                                            .toString();
                                        String storeName = snapshotStore
                                            .data!.docs[indexStore]['storeName']
                                            .toString();
                                        return StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection(CollectionName
                                                    .itemsCollection)
                                                .where("storeId",
                                                    isEqualTo: storeId)
                                                .snapshots(),
                                            builder: (context, secondsnapshot) {
                                              if (secondsnapshot.hasData) {
                                                final items =
                                                    secondsnapshot.data!.docs;
                                                for (int n = 0;
                                                    n < items.length;
                                                    n++) {
                                                  allItems.add(filterModel(
                                                    desc: items[n]['desc'],
                                                    id: items[n]['id'],
                                                    imageUrl: items[n]
                                                        ['imageUrl'],
                                                    isInStock: items[n]
                                                        ['isInStock'],
                                                    name: items[n]['name'],
                                                    price: items[n]['price'],
                                                    shopName: storeName,
                                                    storeId: items[n]
                                                        ['storeId'],
                                                    formula: items[n]
                                                        ['formula'],
                                                    isCronic: items[n]
                                                        ['isCronic'],
                                                  ));
                                                }
                                                print(allItems.length);

                                                return items.length != 0
                                                    ? GridView.builder(
                                                        shrinkWrap: true,
                                                        primary: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          childAspectRatio: 0.7,
                                                        ),
                                                        itemCount: items.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int indexitem) {
                                                          return ItemCardComponent()
                                                              .card(
                                                            itemUrl: items[
                                                                    indexitem]
                                                                ['imageUrl'],
                                                            itemName:
                                                                items[indexitem]
                                                                    ['name'],
                                                            itemdesc:
                                                                items[indexitem]
                                                                    ['desc'],
                                                            isInStock: items[
                                                                    indexitem]
                                                                ['isInStock'],
                                                            itemPrice:
                                                                items[indexitem]
                                                                        [
                                                                        'price']
                                                                    .toString(),
                                                            isCapsule: items[
                                                                    indexitem]
                                                                ['isCapsule'],
                                                            isInjection: items[
                                                                    indexitem]
                                                                ['isInjection'],
                                                            isPowder: items[
                                                                    indexitem]
                                                                ['isPowder'],
                                                            isSyrup:
                                                                items[indexitem]
                                                                    ['isSyrup'],
                                                            isTablet: items[
                                                                    indexitem]
                                                                ['isTablet'],
                                                            onPressed: () {
                                                              final data = AddItemModal
                                                                  .fromJson(items[
                                                                              indexitem]
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>);

                                                              Get.to(() => ItemDetailScreen(
                                                                  data,
                                                                  snapshotStore
                                                                          .data!
                                                                          .docs[indexStore]
                                                                      [
                                                                      'storeName']));
                                                            },
                                                          );
                                                        })
                                                    : SizedBox();
                                              } else {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.green,
                                                  ),
                                                );
                                              }
                                            });
                                      })
                                  : const Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                          "Please make sure your internet connection is stable.\n OR \n No store in your area.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 149, 155, 165)),
                                        ),
                                      ),
                                    );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                ),
                              );
                            }
                          }),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      primary: true,
                      physics: NeverScrollableScrollPhysics(),
                      // gridDelegate:
                      //     const SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 2,
                      //   childAspectRatio: 0.7,
                      // ),
                      itemCount: allItems.length,
                      itemBuilder: (BuildContext context, int indexitem) {
                        return _storeController.isSortByName.value
                            ? allItems[indexitem]
                                    .name
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(_storeController
                                        .searchText.value
                                        .toString()
                                        .toLowerCase())
                                ? ItemCardComponent().card2(
                                    itemUrl: allItems[indexitem].imageUrl,
                                    itemName:
                                        allItems[indexitem].name.toString(),
                                    itemdesc:
                                        allItems[indexitem].desc.toString(),
                                    itemPrice:
                                        allItems[indexitem].price.toString(),
                                    isInStock: allItems[indexitem].isInStock!,
                                    formula:
                                        allItems[indexitem].formula.toString(),
                                    onPressed: () {
                                      final data = AddItemModal(
                                        desc: allItems[indexitem].desc,
                                        id: allItems[indexitem].id,
                                        imageUrl: allItems[indexitem].imageUrl,
                                        isInStock:
                                            allItems[indexitem].isInStock,
                                        name: allItems[indexitem].name,
                                        price: allItems[indexitem].price,
                                        storeId: allItems[indexitem].storeId,
                                        formula: allItems[indexitem].formula,
                                      );

                                      Get.to(() => ItemDetailScreen(
                                          data,
                                          allItems[indexitem]
                                              .shopName
                                              .toString()));
                                    },
                                  )
                                : Container()
                            : allItems[indexitem]
                                    .formula
                                    .toString()
                                    .toLowerCase()
                                    .contains(_storeController.searchText.value
                                        .toString()
                                        .toLowerCase())
                                ? ItemCardComponent().card2(
                                    itemUrl: allItems[indexitem].imageUrl,
                                    itemName:
                                        allItems[indexitem].name.toString(),
                                    itemdesc:
                                        allItems[indexitem].desc.toString(),
                                    itemPrice:
                                        allItems[indexitem].price.toString(),
                                    isInStock: allItems[indexitem].isInStock!,
                                    formula:
                                        allItems[indexitem].formula.toString(),
                                    onPressed: () {
                                      final data = AddItemModal(
                                        desc: allItems[indexitem].desc,
                                        id: allItems[indexitem].id,
                                        imageUrl: allItems[indexitem].imageUrl,
                                        isInStock:
                                            allItems[indexitem].isInStock,
                                        name: allItems[indexitem].name,
                                        price: allItems[indexitem].price,
                                        storeId: allItems[indexitem].storeId,
                                        formula: allItems[indexitem].formula,
                                      );

                                      Get.to(() => ItemDetailScreen(
                                          data,
                                          allItems[indexitem]
                                              .shopName
                                              .toString()));
                                    },
                                  )
                                : Container();
                      }),
            ],
          )),
    );
  }
}
