
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
    return Expanded(
      child: Align(
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
            Text(
              "atlast",
              style: AppText.title.merge(AppText.blackText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
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
          // validator: (String? val) {
          //   if (!isValidPassword(val)) {
          //     return 'Password must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters';
          //   }
          // },
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      child: Column(
        children: [
          _buildHeroWidget(),
          Form(
            key: _formKey,
            child: _buildForm(),
          ),
        ],
      ),
    );
  }
}
