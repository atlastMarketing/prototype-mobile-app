import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/data/suggested_posts.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/models/user_model.dart';
import 'package:atlast_mobile_app/services/generator_service.dart';
import 'package:atlast_mobile_app/services/user_service.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/gradient_text.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/utils/form_validations.dart';

class OnboardingLogin extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const OnboardingLogin({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _OnboardingLoginState createState() => _OnboardingLoginState();
}

class _OnboardingLoginState extends State<OnboardingLogin> {
  // form variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isUserNotFound = false;

  Future<void> _fetchSuggestions(UserModel user) async {
    try {
      SuggestedPostsStore suggestedPostProvider =
          Provider.of<SuggestedPostsStore>(context, listen: false);

      final List<PostDraft> response = await GeneratorService.fetchSuggestions(
        // TODO: get the connected social media paltforms
        platform: SocialMediaPlatforms.instagram,
        userData: user,
      );

      suggestedPostProvider.addCollections(response);
      return;
    } catch (err) {
      print(err);
      return;
    }
  }

  void _handleLoginClick() async {
    UserStore userModelProvider =
        Provider.of<UserStore>(context, listen: false);

    UserModel? user = await UserService.login(_emailController.text);

    if (user == null) {
      print("CANNOT LOGIN - USER NOT FOUND!");
      setState(() => _isUserNotFound = true);
      return;
    }

    userModelProvider.save(
      user.id,
      email: _emailController.text,
      businessName: user.businessName,
      businessIndustry: user.businessIndustry,
      businessType: user.businessType,
      businessDescription: user.businessDescription,
      businessVoice: user.businessVoice,
      businessUrl: user.businessUrl,
      avatarImageUrl: user.avatarImageUrl,
    );

    await _fetchSuggestions(user);

    print("SUCCESSFUL LOGIN FOR USER WITH ID '${user.id}'");

    // check if user onboarded (any missing stuff?)
    if (user.businessName == null ||
        user.businessName == "" ||
        user.businessIndustry == null ||
        user.businessIndustry == "" ||
        user.businessType == null ||
        user.businessType == "" ||
        user.businessDescription == null ||
        user.businessDescription == "") {
      print("-- USER HAS MISSING FIELDS!");
      print("id: ${user.id}");
      print("businessName: ${user.businessName}");
      print("businessIndustry: ${user.businessIndustry}");
      print("businessType: ${user.businessType}");
      print("businessDescription: ${user.businessDescription}");
      print("businessVoice: ${user.businessVoice}");
      print("businessUrl: ${user.businessUrl}");
      print("avatarImageUrl: ${user.avatarImageUrl}");

      userModelProvider.setIsOnboarded(false);
      widget.navKey.currentState!.pushNamed("/onboarding-2");
    } else {
      userModelProvider.setIsOnboarded(true);
    }
  }

  void _handleCreateAccount() {
    widget.navKey.currentState!.pushNamed("/onboarding-1");
  }

  void _handleForgotPassword() {
    widget.navKey.currentState!.pushNamed("/forgot-password");
  }

  void forceLogin() {
    // ONLY FOR DEBUGGING
    print("login and onboarding overwrite!");
    Provider.of<UserStore>(context, listen: false).save(
      "642012b9d167fef05707548c",
      email: "example@atlast.com",
      businessName: "Picard's Flower Shop",
      businessType: "Physical Products",
      businessIndustry: "Accommodation and Food Services",
      businessDescription:
          "My flower shop is a family owned business offering a wide variety of plants, florals, and bouquets.",
      businessVoice: "Fun, Colourful, Casual, Family-oriented",
      // businessUrl: "",
      // avatarImageUrl: "",
    );
    Provider.of<UserStore>(context, listen: false).setIsOnboarded(true);
  }

  void _resetErrorStates() {
    if (_isUserNotFound == true) (() => _isUserNotFound = false);
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
          Row(
            children: [
              GestureDetector(
                onDoubleTap: forceLogin,
                child: GradientText(
                  "atlast",
                  style: AppText.title.merge(AppText.blackText),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withOpacity(0.5),
                      AppColors.primary,
                    ],
                  ),
                ),
              ),
              Text(
                ".",
                style: AppText.title.merge(AppText.blackText),
              ),
            ],
          ),
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
          _isUserNotFound
              ? const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Email is not associated with a user!",
                      style: AppText.errorText,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
