import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_mirea/utils/schedule_converter.dart';

void main() {
  group('', (){
    test('description', (){
      // это очень тупой тест, но потыкаться проверить можно
      // можно запустить debug поставив точку останова в строке print
      const file = 'assets/ИИТ_1 курс_21-22_весна.xlsx';
      final converter = ScheduleConverter();
      converter.setFile(file);
      final subjects = converter.getSubjectsOnWeek('ИВБО-13-21'); 
      print(subjects);
    });

    test('get all subjects', (){
      const file = 'assets/ИИТ_1 курс_21-22_весна.xlsx';
      final converter = ScheduleConverter();
      converter.setFile(file);
      final subjects = converter.getAllSubjects('ИВБО-13-21');
      print(subjects);
    });
  });  
}