import 'dart:io';
import 'package:excel/excel.dart';
import 'package:schedule_mirea/models/even_day.dart';
import 'package:schedule_mirea/models/subject_from_table.dart';
import 'package:schedule_mirea/models/subjects_on_day.dart';

import '../models/subjects_on_week.dart';

class SheduleConverter {
  late Excel _excel;
  late Sheet _sheet;

  void setFile(String fileName) {
    final bytes = File(fileName).readAsBytesSync();
    _excel = Excel.decodeBytes(bytes);
    _sheet = _excel.tables.values.first;
  }

  SubjectsOnWeek getSubjectsOnWeek(String group) {
    final colIndex = _getCol(group);

    return SubjectsOnWeek(
      monday: _getSubjectsOnDay(colIndex, 3),
      thuesday: _getSubjectsOnDay(colIndex, 15),
      wednesday: _getSubjectsOnDay(colIndex, 27),
      thursday: _getSubjectsOnDay(colIndex, 39),
      friday: _getSubjectsOnDay(colIndex, 51),
      saturday: _getSubjectsOnDay(colIndex, 63),
    );
  }

  EvenDay _getSubjectsOnDay(int colIndex, int rowIndex) {
    return EvenDay(
        even: SubjectsOnDay(
          first: _getSubject(colIndex, rowIndex + 1),
          second: _getSubject(colIndex, rowIndex + 3),
          third: _getSubject(colIndex, rowIndex + 5),
          fourth: _getSubject(colIndex, rowIndex + 7),
          fifth: _getSubject(colIndex, rowIndex + 9),
          sixth: _getSubject(colIndex, rowIndex + 11),
        ),
        notEven: SubjectsOnDay(
          first: _getSubject(colIndex, rowIndex),
          second: _getSubject(colIndex, rowIndex + 2),
          third: _getSubject(colIndex, rowIndex + 4),
          fourth: _getSubject(colIndex, rowIndex + 6),
          fifth: _getSubject(colIndex, rowIndex + 8),
          sixth: _getSubject(colIndex, rowIndex + 10),
        ));
  }

  SubjectFromTable? _getSubject(int colIndex, int rowIndex) {
    final Data? data = _sheet.rows[rowIndex][colIndex];
    if (data == null) {
      return null;
    }

    final String name = data.value;
    final String type = _sheet.rows[rowIndex][colIndex + 1]?.value ?? '';
    late final TypeOfSubject typeOfSubject;
    if (type == 'пр') {
      typeOfSubject = TypeOfSubject.prac;
    } else if (type == 'лаб') {
      typeOfSubject = TypeOfSubject.lab;
    } else if (type == 'лк') {
      typeOfSubject = TypeOfSubject.lek;
    } else {
      typeOfSubject = TypeOfSubject.none;
    }
    final String teacher = _sheet.rows[rowIndex][colIndex + 2]?.value ?? '';
    final String room = _sheet.rows[rowIndex][colIndex + 3]?.value ?? '';

    return SubjectFromTable(
      name: name,
      room: room,
      teacher: teacher,
      typeOfSubject: typeOfSubject,
    );
  }

  int _getCol(String group) {
    final col = _sheet.rows[1].indexWhere((element) => element?.value == group);

    if (col == -1) {
      // TODO создать норм эксепшн
      throw Exception('not exist that group');
    }

    return col;
  }

  // List<SubjectFromTable> getAllSubjects {

  // }

}
