import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/sample_page.dart';

import 'campaign/creator_campaign_1_prompt.dart';
import 'campaign/creator_campaign_2_media.dart';

class Creator extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const Creator({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _CreatorState createState() => _CreatorState();
}

class _CreatorState extends State<Creator> {
  int _selectedCreatorOptionIdx = -1;

  _exitCreator() {
    Navigator.of(context).pop();
  }

  _handleInitialContinue() {
    if (_selectedCreatorOptionIdx == 0) {
      // create post
      widget.navKey.currentState!.pushNamed("/post-1");
    } else if (_selectedCreatorOptionIdx == 1) {
      // create campaign
      widget.navKey.currentState!.pushNamed("/campaign-1");
    } else if (_selectedCreatorOptionIdx == 2) {
      // create ad
      widget.navKey.currentState!.pushNamed("/ad-1");
    }
  }

  void _selectCreatorOption(int optionIdx) {
    setState(() => _selectedCreatorOptionIdx = optionIdx);
  }

  Widget _buildCreatorOptionButton(
    String title,
    String description,
    IconData iconData,
    int optionIdx,
  ) {
    final bool isActive = _selectedCreatorOptionIdx == optionIdx;
    return SizedBox(
      height: 130,
      width: double.infinity,
      child: Material(
        color: isActive ? AppColors.secondary : AppColors.light,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _selectCreatorOption(optionIdx),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      iconData,
                      size: 30,
                      color: isActive ? AppColors.white : AppColors.black,
                    ),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppText.buttonLargeText.merge(
                              isActive ? AppText.whiteText : AppText.blackText,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 5)),
                          Text(
                            description,
                            style: isActive
                                ? AppText.whiteText
                                : AppText.blackText,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorOptions() {
    return LayoutFullPage(
      squeezeContents: false,
      handleBack: _exitCreator,
      content: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const HeroHeading(text: "What would you like\nto create?"),
                _buildCreatorOptionButton(
                  "Create a Post",
                  "This generates a single post. Good for one time promotions.",
                  Icons.campaign,
                  0,
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                _buildCreatorOptionButton(
                  "Create a Campaign",
                  "This generates and schedules multiple posts belonging to the same campaign.",
                  Icons.insert_invitation,
                  1,
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                _buildCreatorOptionButton(
                  "Create an Ad",
                  "Reach more customers with precise targeting and actionable insights.",
                  Icons.ads_click,
                  2,
                ),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              disabled: _selectedCreatorOptionIdx < 0 ||
                  _selectedCreatorOptionIdx > 2,
              text: 'Continue',
              handlePressed: _handleInitialContinue,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // lazy loading
    return WillPopScope(
      onWillPop: () async {
        if (widget.navKey.currentState!.canPop()) {
          widget.navKey.currentState!.pop();
          return false;
        }

        return true;
      },
      child: Scaffold(
        body: Navigator(
          key: widget.navKey,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                switch (settings.name) {
                  case "/post-1":
                    return const SamplePage();
                  case "/campaign-1":
                    return CreatorCampaignPrompt(
                      navKey: widget.navKey,
                    );
                  case "/campaign-2":
                    return CreatorCampaignMedia(
                      navKey: widget.navKey,
                    );
                  case "/ad-1":
                    return const SamplePage();
                  default:
                    return _buildCreatorOptions();
                }
              },
            );
          },
        ),
        extendBody: false,
      ),
    );
  }
}
