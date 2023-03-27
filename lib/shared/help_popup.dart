import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';

class HelpPopup extends StatelessWidget {
  final String title;
  final String? content;
  final Widget child;
  final bool highlight;
  final bool down;
  final void Function(InfoPopupController)? handleDismiss;

  const HelpPopup({
    Key? key,
    this.title = "",
    this.content,
    this.highlight = true,
    this.down = false,
    this.handleDismiss,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool enabled =
        Provider.of<UserStore>(context, listen: false).hasHelpPopups;
    if (!enabled) return child;
    return InfoPopupWidget(
      onControllerCreated: (InfoPopupController controller) =>
          controller.show(),
      onAreaPressed: handleDismiss,
      arrowTheme: down ? helpPopupArrowThemeDown : helpPopupArrowThemeUp,
      contentMaxWidth: MediaQuery.of(context).size.width - 100,
      customContent: HelpPopupContent(title: title, content: content),
      enableHighlight: highlight,
      dismissTriggerBehavior: PopupDismissTriggerBehavior.onTapArea,
      child: child,
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
          content != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(content!,
                      style: AppText.body.merge(AppText.whiteText)),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
