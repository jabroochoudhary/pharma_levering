import 'dart:async';

import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../appColors/app_colors.dart';
import '../../stylies/signup_screen_stylies.dart';
import '../../svgimages/svg_images.dart';
import '../../widgets/my_button_widget.dart';
import '../../widgets/my_textfromfield_widget.dart';
import 'package:flutter/cupertino.dart';

import '../login/login.dart';
import '../login/login_view_model.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Widget buildTopPart() {
  Widget buildSocialButton(
      {required Widget child, required VoidCallback onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      shape: OutlineInputBorder(
        borderSide: BorderSide(
          width: 0.5,
          color: AppColors.baseGrey40Color,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }

  Widget buildBottomPart() {
    return Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "or sign in with social networks",
            style: SignupScreenStylies.signInSocialStyle,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //facebook social button
                buildSocialButton(
                  onPressed: () {},
                  child: SvgPicture.asset(
                    SvgImages.facebook,
                    color: AppColors.baseBlackColor,
                    width: 45,
                  ),
                ),
                //Google social button
                buildSocialButton(
                  onPressed: () {},
                  child: SvgPicture.asset(
                    SvgImages.google,
                    color: AppColors.baseBlackColor,
                    width: 45,
                  ),
                ),
                //Twitter social button
                buildSocialButton(
                  onPressed: () {},
                  child: SvgPicture.asset(
                    SvgImages.twitter,
                    color: AppColors.baseBlackColor,
                    width: 45,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20.0),
            child: MaterialButton(
              onPressed: () {},
              color: AppColors.baseGrey10Color,
              height: 55,
              elevation: 0,
              child: Center(
                child: Text(
                  "Sign up",
                  style: SignupScreenStylies.signUpButtonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0.0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      title: Column(
        children: [
          Text(
            "Register your account",
            style: TextStyle(color: AppColors.baseWhiteColor, fontSize: 18),
          ),
          Text(
            "Secure Signup",
            style: TextStyle(
              color: AppColors.baseWhiteColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  final _controller = Get.put(loginViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => SafeArea(
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildAppBar(context),
                  Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      MyTextFromField(
                        hintText: "Full name",
                        obscureText: false,
                        controller: _controller.nameController.value,
                      ),
                      MyTextFromField(
                        hintText: "Email",
                        obscureText: false,
                        controller: _controller.emailController.value,
                      ),
                      MyTextFromField(
                        hintText: "Mobile Number",
                        obscureText: false,
                        isNumber: true,
                        controller: _controller.mobileController.value,
                      ),
                      MyTextFromField(
                        hintText: "Password",
                        controller: _controller.passwordController.value,
                        obscureText: true,
                      ),
                      MyTextFromField(
                        hintText: "Address",
                        obscureText: false,
                        controller: _controller.addressController.value,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "You want to open your store?",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Switch(
                                activeColor: AppColors.baseDarkGreenColor,
                                value: _controller.isBussines.value,
                                onChanged: (v) {
                                  _controller.isBussines.value = v;
                                })
                          ],
                        ),
                      ),
                      _controller.isBussines.value
                          ? MyTextFromField(
                              hintText: "Store name",
                              obscureText: false,
                              controller: _controller.storeNameController.value,
                            )
                          : SizedBox(),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: SelectState(
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          onCountryChanged: (value) {
                            if (value == "🇵🇰    Pakistan") {
                              setState(() {
                                print(value.toString() +
                                    "Country name Selected");
                                _controller.countryValue.value = value;
                              });
                            }
                          },
                          onStateChanged: (value) {
                            setState(() {
                              _controller.stateValue.value = value;
                            });
                          },
                          onCityChanged: (value) {
                            setState(() {
                              _controller.cityValue.value = value;
                            });
                          },
                        ),
                      ),
                      _controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.baseDarkGreenColor,
                              ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(15.0),
                                    child: MyButtonwidget(
                                      text: "SignUp",
                                      color: AppColors.baseDarkGreenColor,
                                      onPress: () {
                                        if (_controller.isBussines.value) {
                                          _controller.singupStore();
                                        } else {
                                          _controller.singupUser();
                                        }

                                        // Get.back();
                                      }, //here add record  in database
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(15.0),
                                    child: MyButtonwidget(
                                      text: "Log In",
                                      color: AppColors.baseDarkGreenColor,
                                      onPress: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "By sigining up you agress to our\n\t",
                          style: SignupScreenStylies.signInAgressStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: "Terms\t",
                              style: SignupScreenStylies.termsTextStyle,
                            ),
                            TextSpan(
                              text: "and\t",
                              style: SignupScreenStylies.andTextStyle,
                            ),
                            TextSpan(
                              text: "Conditions of Use",
                              style: SignupScreenStylies.conditionsOfUseStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  //buildTopPart(),

                  // buildBottomPart(),

                  //buildBottomPart(context: context),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
