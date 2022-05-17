import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/ui/calendar_page/calendar_page_controller.dart';
import 'package:schedule_mirea/ui/calendar_page/subject_task_item.dart';
import 'package:schedule_mirea/utils/calendar_utils.dart';
import 'package:table_calendar/table_calendar.dart';

import '../consts.dart';
import 'calendar_page_state.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarPageController _controller =
      MethodsProvider.get().calendarPageController;

  @override
  void initState() {
    super.initState();
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CalendarPageState>(
        stream: MethodsProvider.get().calendarPageSateHolder.stream,
        builder: (context, snapshot) {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month'
                    },
                    calendarFormat: CalendarFormat.month,
                    focusedDay: snapshot.data?.selectedDate ?? DateTime.now(),
                    firstDay: CalendarUtils.getSemesterStart(),
                    lastDay: CalendarUtils.getSemesterLastDay(),
                    selectedDayPredicate: (day) {
                      return isSameDay(
                          snapshot.data?.selectedDate ?? DateTime.now(), day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      _controller.selectDate(focusedDay);
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
                ),
                Expanded(
                  child: _getListOfItems(snapshot.data),
                )
              ],
            ),
          );
        });
  }

  Widget _getListOfItems(CalendarPageState? state) {
    if (state == null) {
      return Center(
        child: _placeHolder,
      );
    }

    final widgets =
        state.listOfTasks.map((e) => SubjectTaskItem(subjectTask: e)).toList();

    return widgets.isEmpty ? _placeHolder : ListView(children: widgets);
  }

  Widget get _placeHolder =>
      const Center(child: Text('EMPTY', style: TextStyle(color: kAccentColor)));
}
