import 'package:flutter/material.dart';
import 'package:schedule_mirea/ui/consts.dart';

import '../../db/models/subject.dart';
import '../../models/subject_from_table.dart';
import '../tasks_page/tasks_page.dart';

class SubjectItemWidget extends StatelessWidget {
  final Subject? subject;
  final int numOfPair;
  final bool isActive;

  const SubjectItemWidget({
    required this.numOfPair,
    required this.isActive,
    this.subject,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 32,
                child: CustomPaint(
                  painter: LinePaint(isActive, numOfPair),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: _itemColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: subject == null
                        ? const SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'Ничего нет',
                                style: TextStyle(color: kAccentColor),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TasksPage(
                                      name: subject!.name,
                                      subjectId: subject!.id,
                                      typeOfSubject: subject!.type,
                                  )));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject!.name,
                                  style: _titleTextStyle,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          subject!.teacher,
                                          style: _smallTextStyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          _typeOfSubject,
                                          style: _smallTextStyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          subject!.room,
                                          style: _smallTextStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                width: 48,
              ),
            ],
          ),
          ..._timeInterval(context),
        ],
      ),
    );
  }

  String get _typeOfSubject {
    switch (subject?.type) {
      case TypeOfSubject.none:
        return '';
      case TypeOfSubject.lek:
        return 'ЛК';
      case TypeOfSubject.prac:
        return 'ПРАК';
      case TypeOfSubject.lab:
        return 'ЛАБ';
      case null:
        return '';
    }
  }

  List<Widget> _timeInterval(BuildContext context) {
    final start = kPairTimeMap[numOfPair]?['start']?.format(context);
    final end = kPairTimeMap[numOfPair]?['end']?.format(context);
    return [
      Positioned(
          top: 8,
          right: 2,
          child: Text(
            start ?? '',
            style: const TextStyle(
              color: kTextColor,
              fontWeight: FontWeight.bold,
            ),
          )),
      Positioned(
          bottom: 8,
          right: 2,
          child: Text(
            end ?? '',
            style: const TextStyle(
              color: kTextColor,
              fontWeight: FontWeight.bold,
            ),
          )),
    ];
  }

  TextStyle get _titleTextStyle => TextStyle(
        fontSize: 11,
        color: _textColor,
        fontWeight: FontWeight.bold,
      );

  TextStyle get _smallTextStyle => TextStyle(fontSize: 10, color: _textColor);

  Color get _itemColor => isActive ? kPrimaryColor : kSecondaryColor;

  Color get _textColor => isActive ? kButtonTextColor : kTextColor;
}

class LinePaint extends CustomPainter {
  final bool isActive;
  final int numOfPair;

  LinePaint(this.isActive, this.numOfPair);

  @override
  void paint(Canvas canvas, Size size) {
    const lineP1 = Offset(10, 20);
    const lineP2 = Offset(10, 500);
    final whitePaint = Paint()..color = kBackgroundColor;
    final primaryPaint = Paint()..color = kPrimaryColor;

    if (numOfPair != 5) {
      canvas.drawLine(lineP1, lineP2, primaryPaint..strokeWidth = 2);
    } else {
      canvas.drawLine(lineP1, lineP2, whitePaint..strokeWidth = 4);
    }

    const circle = Offset(10, 10);

    canvas.drawCircle(circle, 12, whitePaint);

    if (isActive) {
      canvas.drawCircle(circle, 10, primaryPaint);
      canvas.drawCircle(circle, 8, whitePaint);
      canvas.drawCircle(circle, 5, primaryPaint);
    } else {
      canvas.drawCircle(circle, 6, primaryPaint);
      canvas.drawCircle(circle, 4, whitePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
