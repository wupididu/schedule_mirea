import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/ui/consts.dart';
import 'package:schedule_mirea/ui/home_page/home_page_controller.dart';
import 'package:schedule_mirea/ui/home_page/home_page_state.dart';
import 'package:schedule_mirea/ui/home_page/subject_item_widget.dart';
import 'package:schedule_mirea/utils/calendar_utils.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../db/models/subject.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MethodsProvider.get().homePageController;
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomePageState>(
        stream: MethodsProvider.get().homePageStateHolder.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TableCalendar(
                    availableCalendarFormats: const {
                      CalendarFormat.week: 'Week'
                    },
                    // daysOfWeekStyle: D,
                    calendarFormat: CalendarFormat.week,
                    firstDay: CalendarUtils.getSemesterStart(),
                    lastDay: CalendarUtils.getSemesterLastDay(),
                    focusedDay: snapshot.data?.selectedDate ?? DateTime.now(),
                    selectedDayPredicate: (day) {
                      return isSameDay(
                          snapshot.data?.selectedDate ?? DateTime.now(), day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      _controller.updateSubjects(focusedDay);
                    },
                    calendarBuilders: CalendarBuilders(
                      headerTitleBuilder: (context, day) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat.yMMM().format(day)),
                          Text(
                              "${CalendarUtils.getCurrentWeek(snapshot.data?.selectedDate)} week"),
                        ],
                      ),
                      selectedBuilder: (context, day, focusedDay) {
                        return Center(
                          child: Container(
                            width: 36,
                            height: 36,
                            child: Center(
                                child: Text(
                              day.day.toString(),
                              style: const TextStyle(color: Colors.white),
                            )),
                            decoration: BoxDecoration(
                              color: kAccentColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        );
                      },
                      todayBuilder: (context, day, focusedDay) {
                        return Center(
                          child: Container(
                            width: 36,
                            height: 36,
                            child: Center(
                                child: Text(
                              day.day.toString(),
                              style: const TextStyle(color: Colors.white),
                            )),
                            decoration: BoxDecoration(
                              color: kHintTextColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: _getListOfSubjects(
                          snapshot.data!.subjects,
                          snapshot.data!.currentPair,
                          snapshot.data!.selectedDate.day),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  List<SubjectItemWidget> _getListOfSubjects(
      List<Subject?> subjects, int? currentPair, int selectedDay) {
    final listOfWidgets = <SubjectItemWidget>[];
    for (int i = 0; i < subjects.length; i++) {
      listOfWidgets.add(SubjectItemWidget(
          numOfPair: i,
          subject: subjects[i],
          isActive: i == currentPair && selectedDay == DateTime.now().day));
    }
    return listOfWidgets;
  }
}
