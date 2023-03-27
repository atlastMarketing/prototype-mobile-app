import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/scheduled_posts.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/shared/avatar_image.dart';
import 'package:atlast_mobile_app/shared/layouts/normal_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';

import './user_profile_edit.dart';

class UserProfile extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const UserProfile({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  void _logout() {
    Provider.of<UserStore>(context, listen: false).clear();
    Provider.of<UserStore>(context, listen: false).setIsOnboarded(false);
    Provider.of<UserStore>(context, listen: false).setHasHelpPopups(true);
  }

  void _editProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserProfileEdit(navKey: widget.navKey),
      ),
    );
  }

  Widget _buildProfile() {
    int numScheduledPosts =
        Provider.of<ScheduledPostsStore>(context, listen: false).posts.length;
    // int numPublishedPosts = Provider.of<ScheduledPostsStore>(context, listen: false).posts.length;
    int numPublishedPosts = 0;

    return Consumer<UserStore>(
      builder: (context, model, child) => Column(children: [
        Column(
          children: [
            AvatarImage(
              model.data.avatarImageUrl ?? "",
              borderRadius: 20,
              height: 150,
              width: 150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child:
                  Text(model.data.businessName ?? "", style: AppText.heading),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  model.data.businessIndustry ?? "",
                  textAlign: TextAlign.center,
                  style: AppText.primaryText,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                model.data.businessDescription ?? "",
                textAlign: TextAlign.center,
                style: AppText.darkText,
              ),
            ),
          ],
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(numPublishedPosts.toString(), style: AppText.subheading),
                  const Text(
                    "Published\nPosts",
                    textAlign: TextAlign.center,
                    style: AppText.darkText,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(numScheduledPosts.toString(), style: AppText.subheading),
                  const Text(
                    "Scheduled\nPosts",
                    textAlign: TextAlign.center,
                    style: AppText.darkText,
                  ),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget _buildButton({
    void Function()? handlePress,
    required IconData icon,
    required String text,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: handlePress,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 25),
              ),
              const Padding(padding: EdgeInsets.only(right: 15)),
              Text(text, style: AppText.buttonText),
              const Spacer(),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Consumer<UserStore>(
      builder: (context, model, child) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            _buildButton(
              icon: Icons.quick_contacts_mail,
              text: "Join Waitlist",
              handlePress: () async {
                await launchUrl(Uri.parse("https://www.marketatlast.com/"));
              },
            ),
            const Divider(),
            _buildButton(
              icon: Icons.edit,
              text: "Edit Profile",
              handlePress: _editProfile,
            ),
            _buildButton(
              icon: Icons.settings,
              text: "Settings",
              handlePress: () {},
            ),
            const Divider(),
            _buildButton(
              icon: Icons.developer_mode,
              text: "Debug",
              handlePress: () {
                widget.navKey.currentState!.pushNamed("/debug");
              },
            ),
            _buildButton(
              icon: Icons.logout,
              text: "Logout",
              handlePress: _logout,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutNormalPage(
      paddingOverwrite: pagePaddingNoBottom,
      appBarContent: const Text(""),
      content: SingleChildScrollBare(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfile(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }
}
