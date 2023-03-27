import "package:flutter/material.dart";

import "package:atlast_mobile_app/configs/layout.dart";
import "package:atlast_mobile_app/configs/theme.dart";

class LayoutNormalPage extends StatelessWidget {
  final Widget content;
  final Function()? handleBack;
  final String? appBarTitleText;
  final Widget? appBarContent;
  final EdgeInsets? paddingOverwrite;

  const LayoutNormalPage({
    Key? key,
    required this.content,
    this.handleBack,
    this.appBarTitleText,
    this.appBarContent,
    // fancy aesthetic stuff (not necessary)
    // if any of the pages break because of overflows, this is the first thing to turn off.
    this.paddingOverwrite,
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
      titleContent = Text(
        appBarTitleText!,
        style: AppText.subheading.merge(AppText.blackText),
      );
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: handleBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 30),
              onPressed: handleBack,
            )
          : null,
      title: titleContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? appBar = _buildAppBar();
    double maxHeight = MediaQuery.of(context).size.height;
    // minus safearea
    maxHeight -= MediaQuery.of(context).padding.top;
    maxHeight -= MediaQuery.of(context).padding.bottom;
    // minus appbar
    maxHeight -= appBar != null ? appBar.preferredSize.height : 0;

    EdgeInsets padding = paddingOverwrite ?? pagePadding;

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Padding(padding: padding, child: content);
        }),
        resizeToAvoidBottomInset: true,
        extendBody: false,
      ),
    );
  }
}
