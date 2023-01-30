import 'package:e_medicine_shop/screens/editprofilescreen/edit_profile_screen.dart';
import 'package:e_medicine_shop/screens/profilescreen/profile_screen_view_model.dart';
import 'package:e_medicine_shop/widgets/app_notification.dart';
import 'package:e_medicine_shop/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../appColors/app_colors.dart';
import '../../svgimages/svg_images.dart';

class ProfileScreen extends StatefulWidget {
  bool isOnlyDetail;
  String userDocId;
  ProfileScreen({this.userDocId = "", this.isOnlyDetail = false, Key? key})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _controller = Get.put(ProfileScreenViewModel());

  @override
  void initState() {
    print(widget.userDocId);
    initvar();
    super.initState();
  }

  initvar() {
    _controller.user(widget.userDocId);
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0.70,
      centerTitle: true,
      backgroundColor: Colors.green,
      title: const Text(
        "Account",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: widget.isOnlyDetail
          ? []
          : [
              IconButton(
                onPressed: () {
                  if (!_controller.isLoading.value) {
                    Get.off(() => EditProfilescreen());
                  }
                },
                icon: SvgPicture.asset(
                  SvgImages.edit,
                  color: Colors.white,
                  width: 25,
                ),
              )
            ],
      shadowColor: AppColors.baseGrey10Color,
    );
  }

  Widget buildlistTileWidget(
      {required String leading, required String trailing}) {
    return ListTile(
        tileColor: AppColors.baseWhiteColor,
        leading: Text(
          leading,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: SizedBox(
          width: 200,
          child: AppText.text(trailing,
              color: Colors.black,
              maxlines: 2,
              fontsize: 16,
              textAlignment: TextAlign.right),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.baseGrey10Color,
        appBar: buildAppBar(),
        body: _controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                    height: 200,
                    margin: EdgeInsets.only(bottom: 10),
                    color: AppColors.baseWhiteColor,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.green, width: 1.5),
                              ),
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 35,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 60,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            _controller.username.value,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: 150,
                            child: AppText.text(
                              _controller.userAddress.value,
                              color: Colors.black,
                              fontsize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    color: AppColors.baseWhiteColor,
                    child: Column(
                      children: [
                        buildlistTileWidget(
                            leading: "Full name",
                            trailing: _controller.username.value),
                        Divider(),
                        buildlistTileWidget(
                          leading: "Email",
                          trailing: _controller.useremail.value,
                        ),
                        Divider(),
                        InkWell(
                          onTap: () {
                            // launch('tel:${_controller.usermobile.value}');
                            FlutterPhoneDirectCaller.callNumber(
                                _controller.usermobile.value);
                          },
                          child: buildlistTileWidget(
                            leading: "Mobile",
                            trailing: _controller.usermobile.value.toString(),
                          ),
                        ),
                        Divider(),
                        InkWell(
                          onTap: () {
                            Get.defaultDialog(
                              title: "Address",
                              backgroundColor: Colors.white,
                              titleStyle: const TextStyle(color: Colors.green),
                              content: Container(
                                padding: EdgeInsets.all(5),
                                child: AppText.text(
                                  _controller.userAddress.value,
                                  color: Colors.grey,
                                  fontsize: 15,
                                  fontweight: FontWeight.w400,
                                  textAlignment: TextAlign.start,
                                  maxlines: 5,
                                ),
                              ),
                              buttonColor: Colors.green,
                              radius: 10,
                            );
                          },
                          child: buildlistTileWidget(
                            leading: "Address",
                            trailing: _controller.userAddress.value,
                          ),
                        ),
                        Divider(),
                        buildlistTileWidget(
                          leading: "City",
                          trailing: _controller.city.value,
                        ),
                        Divider(),
                        buildlistTileWidget(
                          leading: "State",
                          trailing: _controller.state.value,
                        ),
                        Divider(),
                        buildlistTileWidget(
                          leading: "Country",
                          trailing: _controller.country.value,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
