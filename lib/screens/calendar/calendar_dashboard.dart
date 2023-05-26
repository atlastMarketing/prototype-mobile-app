import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/data/scheduled_posts.dart';
import 'package:atlast_mobile_app/shared/calendar.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/widget_overlays.dart';
import 'package:atlast_mobile_app/shared/layouts/normal_page.dart';

import 'package:atlast_mobile_app/screens/calendar/calendar_edit_single_post.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarDashboard extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const CalendarDashboard({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  void _openEditSinglePost(BuildContext ctx, String postId) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (context) => CalendarEditSinglePost(
          navKey: navKey,
          postId: postId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutNormalPage(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const HeroHeading(text: "Your Calendar"),
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
                  // TODO: add "options" for onboarding
                  enableOnboarding: false,
                  disableSelection: false,
                  posts: model.posts,
                  handleTap: (String postId) =>
                      _openEditSinglePost(context, postId),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
