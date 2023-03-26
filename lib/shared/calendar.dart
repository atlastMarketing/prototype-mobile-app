import 'package:atlast_mobile_app/shared/help_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/shared/avatar_image.dart';
import 'package:atlast_mobile_app/utils/datetime_utils.dart';

class CustomCalendar extends StatefulWidget {
  final List<PostContent> posts;
  final void Function(String id, PostContent post)? updatePost;
  final void Function(String)? handleTap;

  final List<CalendarView> allowedViews;
  final CalendarView defaultView;
  final DateTime? minDateRestriction;
  final DateTime? initialDate;

  final bool allowDragAndDrop;
  final bool disableSelection;
  final bool disableInteractions;
  final bool enableOnboarding;

  const CustomCalendar({
    Key? key,
    required this.posts,
    this.updatePost,
    this.handleTap,
    this.allowedViews = const [CalendarView.week],
    this.defaultView = CalendarView.week,
    this.minDateRestriction,
    this.initialDate,
    this.disableSelection = false,
    this.disableInteractions = false,
    this.allowDragAndDrop = false,
    this.enableOnboarding = false,
  }) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final CalendarController _calendarController = CalendarController();
  bool _isPopupDismissed = false;

  @override
  void initState() {
    super.initState();
  }

  List<PostContent> _getDataSource() {
    return [...widget.posts];
  }

  bool _isFirstAppointment(String id) => widget.posts[0].id == id;

  Widget _buildAppointment(
    BuildContext ctx,
    CalendarAppointmentDetails details,
  ) {
    final PostContent currPost = details.appointments.first;

    final shouldShowOnboarding = widget.enableOnboarding &&
        !widget.disableInteractions &&
        !_isPopupDismissed &&
        Provider.of<UserStore>(context, listen: false).hasHelpPopups &&
        _isFirstAppointment(currPost.id);

    if ([
      CalendarView.week,
      CalendarView.timelineDay,
      CalendarView.timelineWeek,
      CalendarView.timelineWorkWeek,
      CalendarView.timelineMonth,
    ].contains(_calendarController.view)) {
      return shouldShowOnboarding
          ? HelpPopup(
              title: "Edit me!",
              content:
                  "Hold and drag on any post to schedule on a different day or time. Click on posts to edit.",
              handleDismiss: (_) => setState(() => _isPopupDismissed = true),
              child: Container(
                height: details.bounds.width,
                width: details.bounds.width,
                color: Colors.transparent,
                child: AvatarImage(
                  currPost.imageUrl ?? "",
                  width: details.bounds.width,
                  height: details.bounds.width,
                  borderRadius: 0,
                ),
              ),
            )
          : Container(
              height: details.bounds.width,
              width: details.bounds.width,
              color: Colors.transparent,
              child: AvatarImage(
                currPost.imageUrl ?? "",
                width: details.bounds.width,
                height: details.bounds.width,
                borderRadius: 0,
              ),
            );
    }

    if ([
      CalendarView.day,
    ].contains(_calendarController.view)) {
      return Container(
        color: AppColors.primary,
        height: details.bounds.height,
        width: details.bounds.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Row(
            children: [
              AvatarImage(
                currPost.imageUrl ?? "",
                width: details.bounds.height - 4,
                height: details.bounds.height - 4,
                fit: BoxFit.contain,
                borderRadius: 0,
              ),
              Flexible(
                child: Text(
                  currPost.caption ?? "",
                  style: AppText.bodySmall.merge(AppText.whiteText),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Text(
        currPost.caption ?? "",
        style: AppText.bodySmall,
      ),
    );
  }

  void _handleTap(CalendarTapDetails details) {
    dynamic appointments = details.appointments;

    if (appointments != null && widget.handleTap != null) {
      PostContent appointment = appointments.first;
      widget.handleTap!(appointment.id);
    }
  }

  void _onDragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {
    PostContent currPost =
        appointmentDragEndDetails.appointment! as PostContent;
    // CalendarResource? sourceResource = appointmentDragEndDetails.sourceResource;
    // CalendarResource? targetResource = appointmentDragEndDetails.targetResource;
    DateTime? droppingTime = appointmentDragEndDetails.droppingTime;

    if (droppingTime == null) return; // reset
    if (widget.minDateRestriction != null &&
        droppingTime.isBefore(widget.minDateRestriction!)) return;

    DateTime nearestHour =
        roundDown(droppingTime, delta: const Duration(hours: 1));
    currPost.dateTime = nearestHour.millisecondsSinceEpoch;
    if (widget.updatePost != null) widget.updatePost!(currPost.id, currPost);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMultipleViews = widget.allowedViews.length > 1;

    bool adnd = widget.allowDragAndDrop;
    if (widget.disableInteractions) adnd = false;
    return SfCalendar(
      controller: _calendarController,
      dataSource: PostDataSource(_getDataSource()),

      // functionality
      view: widget.defaultView,
      allowDragAndDrop: adnd,
      onDragEnd: adnd ? _onDragEnd : null,
      timeZone: "Pacific Standard Time", // TODO: don't hardcode
      allowedViews: hasMultipleViews ? widget.allowedViews : null,
      // allowedViews: [
      //   CalendarView.day,
      //   CalendarView.month,
      //   CalendarView.schedule,
      //   CalendarView.timelineDay,
      //   CalendarView.timelineMonth,
      //   CalendarView.week,
      //   CalendarView.workWeek,
      // ],
      onTap: _handleTap,

      // view settings
      showNavigationArrow: !hasMultipleViews,
      showDatePickerButton: true,
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 0,
        endHour: 24,
        nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday],
        minimumAppointmentDuration: Duration(minutes: 60),
      ),
      monthViewSettings: const MonthViewSettings(
        showAgenda: true,
        appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
      ),
      dragAndDropSettings: const DragAndDropSettings(
        showTimeIndicator: true,
      ),
      appointmentBuilder: _buildAppointment,
      initialDisplayDate: widget.initialDate,
      initialSelectedDate: widget.initialDate,
      minDate: widget.minDateRestriction,

      // decorations
      todayHighlightColor: AppColors.primary,
      selectionDecoration: widget.disableSelection
          ? BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.transparent),
            )
          : BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              shape: BoxShape.rectangle,
            ),
      cellEndPadding: 0,
    );
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
}

class PostDataSource extends CalendarDataSource {
  PostDataSource(List<PostContent> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.fromMillisecondsSinceEpoch(appointments![index].dateTime);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.fromMillisecondsSinceEpoch(appointments![index].dateTime)
        .add(const Duration(hours: 1));
  }

  @override
  String getSubject(int index) {
    return appointments![index].caption;
  }

  @override
  Color getColor(int index) {
    return AppColors.primary;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }

  @override
  PostContent? convertAppointmentToObject(
      Object? customData, Appointment appointment) {
    return PostContent(
      id: (customData as PostContent).id,
      platform: customData.platform,
      caption: customData.caption!,
      dateTime: appointment.startTime.millisecondsSinceEpoch,
      imageUrl: customData.imageUrl,
    );
  }
}
