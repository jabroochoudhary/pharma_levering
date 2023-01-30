import 'package:country_state_city_picker/country_state_city_picker.dart';
import '/screens/editprofilescreen/edit_profile_view_mode.dart';
import '/widgets/my_appbar.dart';
import '/widgets/my_textfromfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../appColors/app_colors.dart';
import '../../widgets/my_button_widget.dart';
import '../profilescreen/profile_screen.dart';

class EditProfilescreen extends StatefulWidget {
  bool isFromOrder;
  EditProfilescreen({this.isFromOrder = false, Key? key}) : super(key: key);

  @override
  State<EditProfilescreen> createState() => _EditProfilescreenState();
}

class _EditProfilescreenState extends State<EditProfilescreen> {
  final _controller = Get.put(EditProfileViewModel());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: MyAppBar().detailsAppBar(
            context: context,
            title: "Edit Account",
            isBackButton: true,
            isCenterTitle: true,
            onBackButtonPressed: () => Get.off(ProfileScreen()),
            titleColor: Colors.white,
          ),
          body: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              MyTextFromField(
                hintText: "Full name",
                obscureText: false,
                controller: _controller.username.value,
                readOnly: widget.isFromOrder,
              ),
              MyTextFromField(
                hintText: "Email",
                obscureText: false,
                readOnly: true,
                controller: _controller.useremail.value,
              ),
              MyTextFromField(
                hintText: "Address",
                obscureText: false,
                controller: _controller.userAddress.value,
                lines: 3,
              ),
              MyTextFromField(
                hintText: "Mobile",
                obscureText: false,
                controller: _controller.usermobile.value,
                isNumber: true,
              ),
              widget.isFromOrder
                  ? SizedBox()
                  : Container(
                      padding: EdgeInsets.all(20),
                      child: SelectState(
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        onCountryChanged: (value) {
                          if (value == "🇵🇰    Pakistan") {
                            setState(() {
                              print(value.toString() + "Country name Selected");
                              _controller.country.value = value;
                            });
                          }
                        },
                        onStateChanged: (value) {
                          setState(() {
                            _controller.state.value = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            _controller.city.value = value;
                          });
                        },
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              _controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    )
                  : Container(
                      color: AppColors.baseGrey10Color,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 23),
                      margin: EdgeInsets.only(bottom: 20),
                      child: MyButtonwidget(
                        color: AppColors.baseDarkPinkColor,
                        text: "Update",
                        onPress: () {
                          _controller.updateAccount();
                        },
                      ),
                    ),
            ],
          ),
        ));
  }
}
