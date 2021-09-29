import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uuid/uuid.dart';
import 'package:volt_arena/consts/collections.dart';
import 'package:volt_arena/consts/colors.dart';
import 'package:volt_arena/consts/universal_variables.dart';
import 'package:volt_arena/database/database.dart';
import 'package:volt_arena/models/meetingsModel.dart';

class CalenderScreen extends StatefulWidget {
  static const routeName = '/CalenderScreen';

  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen>
    with AutomaticKeepAliveClientMixin<CalenderScreen> {
  CalendarController _controller = CalendarController();
  List<Meeting> meetingsList = [];
  TimeOfDay? startingTime;
  TimeOfDay? endingTime;
  DateTime dateTime = DateTime.now();
  TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    getMeetings();
  }

  getMeetings() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot meetingsSnapShot =
        await DatabaseMethods().fetchCalenderDataFromFirebase();
    List<MeetingsModel> allMeetings = [];

    meetingsSnapShot.docs.forEach((e) {
      allMeetings.add(MeetingsModel.fromDocument(e));
    });
    List<Meeting> asd = [];
    allMeetings.forEach((e) {
      asd.add(Meeting(
          eventName: e.meetingTitle,
          background: Colors.blue.shade900,
          from: e.startingTime!.toDate(),
          to: e.endingTime!.toDate(),
          isAllDay: e.isAllDay));
    });
    setState(() {
      this.meetingsList = asd;
      _isLoading = false;
    });
    print(meetingsList);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
            body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: _isLoading
                ? LoadingIndicator()
                : SfCalendar(
                    backgroundColor: Colors.transparent,
                    allowedViews: [
                      CalendarView.day,
                      CalendarView.schedule,
                      CalendarView.month,
                      CalendarView.timelineDay,
                      CalendarView.week,
                      CalendarView.timelineMonth,
                      CalendarView.timelineWeek,
                      CalendarView.timelineWorkWeek,
                      CalendarView.workWeek
                    ],
                    view: CalendarView.month,
                    showDatePickerButton: true,
                    showNavigationArrow: true,
                    allowViewNavigation: true,
                    controller: _controller,
                    onTap: (CalendarTapDetails asd) async {
                      // DatePicker.showTime12hPicker(context,currentTime: DateTime.now(),);
                      print(asd.targetElement.index);
                      if (
                          // currentUser!.isAdmin! &&
                          asd.targetElement.index != 0) {
                        meetingTimePicker(context, asd.date!).then((value) {
                          print(meetingsList);
                          setState(() {
                            this.meetingsList = meetingsList;
                          });
                        });
                      }
                    },
                    dataSource:
                        //  AppointmentDataSource(_getDataSourceAppointment()),
                        MeetingDataSource(meetingsList),
                    monthViewSettings: MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.appointment,
                        showAgenda: true),
                  ),
          ),
        )),
      ),
    );
  }

  meetingTimePicker(BuildContext context, DateTime asd) async {
    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: StatefulBuilder(builder: (context, setState) {
              return Dialog(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Book Event",
                        style: titleTextStyle(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? startingTimeTemp = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            helpText: "Select Event Starting Time");
                        setState(() {
                          this.startingTime = startingTimeTemp!;
                        });
                        print(startingTime);
                      },
                      child: Text(startingTime == null
                          ? "Select Event Starting Time"
                          : startingTime!.format(context)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var endingTimeTemp = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            helpText: "Select Event Ending Time");
                        setState(() {
                          this.endingTime = endingTimeTemp!;
                        });
                      },
                      child: Text(endingTime == null
                          ? "Select Event Ending Time"
                          : endingTime!.format(context)),
                    ),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                          labelText: "Title", hintText: "Enter Event Title"),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            meetingsList.add(getDataSource(
                              title: _titleController.text,
                              dateTime: asd,
                              startTimeOfDay: startingTime,
                              endTimeOfDay: endingTime,
                            ));
                          });

                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined),
                            Text("Add Event"),
                          ],
                        ))
                  ],
                ),
              );
            }),
          );
        });
  }

  Meeting getDataSource(
      {TimeOfDay? startTimeOfDay,
      TimeOfDay? endTimeOfDay,
      String? title,
      DateTime? dateTime,
      bool isAllDay = false}) {
    Meeting meetings;
    final DateTime today = dateTime!;
    final DateTime startTime = DateTime(today.year, today.month, today.day,
        startTimeOfDay!.hour, startTimeOfDay.minute, 0);
    final DateTime endTime = DateTime(today.year, today.month, today.day,
        endingTime!.hour, endingTime!.minute, 0);

    String meetingId = Uuid().v4();
    calenderRef.doc(meetingId).set({
      "meetingId": meetingId,
      "meetingTitle": title,
      "startingTime": startTime,
      "endingTime": endTime,
      "isAllDay": isAllDay,
    });
    meetings = Meeting(
        background: Colors.blue.shade900,
        eventName: title,
        isAllDay: isAllDay,
        from: startTime,
        to: endTime);
    return meetings;
  }

  @override
  bool get wantKeepAlive => true;
}

// List<Appointment> _getDataSourceAppointment() {
//   final List<Appointment> meetings = <Appointment>[];
//   final DateTime? today = DateTime.now();
//   final DateTime? startTime =
//       DateTime(today!.year, today.month, today.day, 9, 0, 0);
//   final DateTime endTime = startTime!.add(const Duration(hours: 2));
//   meetings.add(Appointment(
//       endTime: endTime,
//       startTime: startTime,
//       subject: "gjhgdasd",
//       notes: "asdhas"));

//   meetings.add(Appointment(
//       endTime: endTime,
//       startTime: startTime,
//       subject: "asdasd",
//       notes: "sdhgasdhas"));
//   return meetings;
// }

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting({this.eventName, this.from, this.to, this.background, this.isAllDay});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background = Colors.purple;
  bool? isAllDay;
}
