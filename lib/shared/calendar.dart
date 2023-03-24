import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/shared/avatar_image.dart';
import 'package:atlast_mobile_app/utils/datetime_utils.dart';

class CustomCalendar extends StatefulWidget {
  final List<PostContent> initialPosts;
  final void Function(PostContent)? updatePost;
  final void Function(String)? handleTap;

  final List<CalendarView> allowedViews;
  final CalendarView defaultView;
  final bool allowDragAndDrop;

  final bool disableSelection;

  const CustomCalendar({
    Key? key,
    required this.initialPosts,
    this.updatePost,
    this.handleTap,
    this.allowedViews = const [CalendarView.week],
    this.defaultView = CalendarView.week,
    this.disableSelection = false,
    this.allowDragAndDrop = false,
  }) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
  }

  List<PostContent> _getDataSource() {
    return widget.initialPosts;
  }

  Widget _buildAppointment(
    BuildContext ctx,
    CalendarAppointmentDetails details,
  ) {
    final PostContent currPost = details.appointments.first;

    if ([
      CalendarView.week,
      CalendarView.timelineDay,
      CalendarView.timelineWeek,
      CalendarView.timelineWorkWeek,
      CalendarView.timelineMonth,
    ].contains(_calendarController.view)) {
      return Container(
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
    DateTime date = details.date!;

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

    DateTime nearestHour =
        roundDown(droppingTime, delta: const Duration(hours: 1));
    currPost.dateTime = nearestHour.millisecondsSinceEpoch;
    if (widget.updatePost != null) widget.updatePost!(currPost);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMultipleViews = widget.allowedViews.length > 1;
    return SfCalendar(
      controller: _calendarController,
      dataSource: PostDataSource(_getDataSource()),

      // functionality
      view: widget.defaultView,
      allowDragAndDrop: widget.allowDragAndDrop,
      onDragEnd: _onDragEnd,
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
      dateTime: customData.dateTime!,
      imageUrl: customData.imageUrl,
    );
  }
}
