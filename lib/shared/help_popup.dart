import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';

// ignore: constant_identifier_names
const bool WEB_MODE =
    String.fromEnvironment('WEB_MODE', defaultValue: '') != "";

class HelpPopup extends StatefulWidget {
  final String title;
  final String? content;
  final Widget child;
  final bool highlight;
  final bool down;
  final bool disabled;
  final void Function(InfoPopupController)? handleDismiss;
  final int? delayMilliseconds;

  const HelpPopup({
    Key? key,
    this.title = "",
    this.content,
    this.highlight = true,
    this.down = false,
    this.handleDismiss,
    this.disabled = false,
    this.delayMilliseconds,
    required this.child,
  }) : super(key: key);

  @override
  State<HelpPopup> createState() => _HelpPopupState();
}

class _HelpPopupState extends State<HelpPopup> {
  bool _isClicked = false;
  bool _isDelayFinished = false;

  void _handleDismiss(InfoPopupController ctrl) {
    setState(() => _isClicked = true);
    if (widget.handleDismiss != null) widget.handleDismiss!(ctrl);
  }

  @override
  void initState() {
    super.initState();
    if (widget.delayMilliseconds != null) {
      Future.delayed(Duration(milliseconds: widget.delayMilliseconds!), () {
        if (mounted) setState(() => _isDelayFinished = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("WEB_MODE: $WEB_MODE");
    final bool enabled =
        Provider.of<UserStore>(context, listen: false).hasHelpPopups;
    if (WEB_MODE || !enabled || widget.disabled) return widget.child;
    if (_isClicked) return widget.child;
    if (widget.delayMilliseconds != null && !_isDelayFinished) {
      return widget.child;
    }

    return InfoPopupWidget(
      onControllerCreated: (InfoPopupController controller) =>
          controller.show(),
      onAreaPressed: _handleDismiss,
      arrowTheme: widget.down ? helpPopupArrowThemeDown : helpPopupArrowThemeUp,
      contentMaxWidth: MediaQuery.of(context).size.width - 100,
      customContent:
          HelpPopupContent(title: widget.title, content: widget.content),
      enableHighlight: widget.highlight,
      dismissTriggerBehavior: PopupDismissTriggerBehavior.onTapArea,
      child: widget.child,
    );
  }
}

const helpPopupArrowThemeDown = InfoPopupArrowTheme(
  color: AppColors.secondary,
  arrowDirection: ArrowDirection.down,
);
const helpPopupArrowThemeUp = InfoPopupArrowTheme(
  color: AppColors.secondary,
  arrowDirection: ArrowDirection.up,
);

class HelpPopupContent extends StatelessWidget {
  final String title;
  final String? content;

  const HelpPopupContent({
    Key? key,
    this.title = "",
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: AppColors.white,
                size: 16,
              ),
              const Padding(padding: EdgeInsets.only(right: 5)),
              Text(title, style: AppText.bodyBold.merge(AppText.whiteText))
            ],
          ),
          if (content != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child:
                  Text(content!, style: AppText.body.merge(AppText.whiteText)),
            ),
        ],
      ),
    );
  }
}
