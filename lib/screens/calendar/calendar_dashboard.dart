import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/data/scheduled_posts.dart';
import 'package:atlast_mobile_app/shared/calendar.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/widget_overlays.dart';

import 'package:atlast_mobile_app/screens/calendar/calendar_edit_single_post.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarDashboard extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const CalendarDashboard({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _CalendarDashboardState createState() => _CalendarDashboardState();
}

class _CalendarDashboardState extends State<CalendarDashboard> {
  bool infoPopupDismissed = false;

  void _openEditSinglePost(BuildContext ctx, String postId) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (context) => CalendarEditSinglePost(
          navKey: widget.navKey,
          postId: postId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              infoPopupDismissed == false
                  ? InfoPopupWidget(
                      onControllerCreated: (InfoPopupController controller) {
                        controller.show();
                      },
                      infoPopupDismissed: () {
                        setState(() => infoPopupDismissed = true);
                      },
                      contentTitle:
                          "Weekdays between 10am-3pm are the most effective times to post on social media platforms like Facebook and Instagram.\n\n- Your AI Marketing Advisor",
                      enableHighlight: true,
                      child: const HeroHeading(text: "Calendar Dashboard"))
                  : const HeroHeading(text: "Calendar Dashboard"),
              Expanded(
                  child: WidgetOverlays(
                // loading: _campaignDatesIsLoading || _captionsIsLoading,
                child: Consumer<ScheduledPostsStore>(
                  builder: (context, model, child) => CustomCalendar(
                    allowedViews: const [
                      CalendarView.day,
                      CalendarView.week,
                      CalendarView.month,
                      CalendarView.schedule,
                    ],
                    disableSelection: false,
                    posts: model.posts,
                    handleTap: (String postId) =>
                        _openEditSinglePost(context, postId),
                  ),
                ),
              )),
            ],
          ),
        ),
        extendBody: false,
      ),
    );
  }
}
