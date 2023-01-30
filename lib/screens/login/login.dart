import 'package:e_medicine_shop/screens/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '/screens/signup/signup_screen.dart';
import '../../appColors/app_colors.dart';
// import '../../routes/routes.dart';
import '../../stylies/login_screen_stylies.dart';
import '../../svgimages/svg_images.dart';
import '../../widgets/my_button_widget.dart';
import '../../widgets/my_textfromfield_widget.dart';
import '../homepage/home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = Get.put(loginViewModel());

  Widget buildTopPart() {
    return Column(
      children: [
        Column(
          children: [
            MyTextFromField(
              hintText: "Email",
              obscureText: false,
              controller: _controller.emailController.value,
            ),
            MyTextFromField(
              hintText: "Password",
              obscureText: true,
              controller: _controller.passwordController.value,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Is store account?",
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
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: _controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.baseDarkGreenColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyButtonwidget(
                        text: "Log in",
                        color: AppColors.baseDarkGreenColor,
                        onPress: () {
                          _controller.login();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: MyButtonwidget(
                        text: "Create Account",
                        color: AppColors.baseDarkGreenColor,
                        onPress: () {
                          Get.to(() => SignupScreen());
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => SafeArea(
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 50),
              Lottie.asset("images/login.json"),
              buildTopPart(),
            ],
          ),
        ),
      ),
    ));
  }
}
