import 'package:atlast_mobile_app/shared/gradient_text.dart';
import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/utils/form_validations.dart';

class OnboardingLogin extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final void Function() handleLogin;

  const OnboardingLogin({
    Key? key,
    required this.navKey,
    required this.handleLogin,
  }) : super(key: key);

  @override
  _OnboardingLoginState createState() => _OnboardingLoginState();
}

class _OnboardingLoginState extends State<OnboardingLogin> {
  // form variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLoginClick() {
    print("email: ${_emailController.text}");
    print("pass: ${_passwordController.text}");
    // TODO: check if the signed-in user has completed onboarding
    widget.handleLogin();
  }

  void _handleCreateAccount() {
    widget.navKey.currentState!.pushNamed("/create-1");
  }

  void _handleForgotPassword() {
    widget.navKey.currentState!.pushNamed("/forgot-password");
  }

  Widget _buildHeroWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Marketing",
            style: AppText.title.merge(AppText.blackText),
          ),
          Text(
            "made easy,",
            style: AppText.title.merge(AppText.blackText),
          ),
          GradientText("atlast",
              style: AppText.title.merge(AppText.blackText),
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withOpacity(0.5),
                  AppColors.primary,
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CustomFormTextField(
            controller: _emailController,
            placeholderText: "Email",
            validator: (String? val) {
              if (!isValidEmail(val)) {
                return 'Enter a valid email!';
              }
            },
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          CustomFormTextField(
            controller: _passwordController,
            placeholderText: "Password",
            obscureText: true,
          ),
          Align(
            alignment: Alignment.centerRight,
            heightFactor: 1,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: const Text("Forgot Password?"),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              handlePressed: () {
                _formKey.currentState!.save();
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _handleLoginClick();
                }
              },
              fillColor: AppColors.secondary,
              text: 'Login',
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              handlePressed: _handleCreateAccount,
              fillColor: AppColors.primary,
              text: 'Create an Account',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      squeezeContents: true,
      content: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: _buildHeroWidget(),
          ),
          const Spacer(),
          _buildForm(),
        ],
      ),
    );
  }
}
