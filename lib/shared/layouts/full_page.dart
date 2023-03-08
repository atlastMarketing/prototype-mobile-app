import "package:flutter/material.dart";

import "package:atlast_mobile_app/configs/layout.dart";
import "package:atlast_mobile_app/configs/theme.dart";
import "package:atlast_mobile_app/shared/scroll_behavior_empty.dart";

class LayoutFullPage extends StatelessWidget {
  final Widget child;
  final Function()? handleBack;
  final String? appBarTitleText;
  final Widget? appBarContent;

  const LayoutFullPage({
    Key? key,
    required this.child,
    this.handleBack,
    this.appBarTitleText,
    this.appBarContent,
  }) : super(key: key);

  PreferredSizeWidget? _buildAppBar() {
    final bool appBarInactive =
        handleBack == null && appBarTitleText == null && appBarContent == null;
    if (appBarInactive) return null;

    Widget? titleContent;
    if (appBarContent != null) {
      double rightPadding = 0;
      if (handleBack != null) rightPadding = 40;
      titleContent = Padding(
        padding: EdgeInsets.only(left: 40, right: 40 + rightPadding),
        child: appBarContent,
      );
    } else if (appBarTitleText != null) {
      titleContent = Text(appBarTitleText!, style: AppText.subheading);
    }

    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: handleBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.grey),
              onPressed: handleBack,
            )
          : null,
      title: titleContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      // remove scroll glow
      behavior: CustomScrollBehaviorEmpty(),
      child: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: SafeArea(
              child: Scaffold(
                appBar: _buildAppBar(),
                body: Padding(padding: pagePadding, child: child),
                extendBody: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
