import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_mirea/utils/parse_scheduler.dart';

void main(){
  group('description', (){
    test('description', () async {
      final parseSheduler = ParseScheduler('ИВБО-02-19');
      final link = await parseSheduler.getLink();
      print(link.toString());
    });
  });
}