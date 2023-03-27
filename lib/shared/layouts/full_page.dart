import "package:flutter/material.dart";

import "package:atlast_mobile_app/configs/layout.dart";
import "package:atlast_mobile_app/configs/theme.dart";

class LayoutFullPage extends StatelessWidget {
  final Widget content;
  final Function()? handleBack;
  final String? appBarTitleText;
  final Widget? appBarContent;
  final bool squeezeContents;
  final EdgeInsets? paddingOverwrite;
  final List<Widget> actionWidgets;

  const LayoutFullPage({
    Key? key,
    required this.content,
    this.handleBack,
    this.appBarTitleText,
    this.appBarContent,
    // fancy aesthetic stuff (not necessary)
    // if any of the pages break because of overflows, this is the first thing to turn off.
    this.squeezeContents = false,
    this.paddingOverwrite,
    this.actionWidgets = const [],
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
      actions: actionWidgets,
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return squeezeContents
              ? SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                      maxHeight: maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(padding: padding, child: content),
                    ),
                  ),
                )
              : Padding(padding: padding, child: content);
        }),
      ),
      resizeToAvoidBottomInset: true,
      extendBody: false,
    );
  }
}
