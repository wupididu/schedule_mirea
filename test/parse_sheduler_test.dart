import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_mirea/utils/path_scheduler_provider.dart';

void main(){
  group('description', (){
    test('description', () async {
      final parseSheduler = PathSchedulerProvider();
      final link = await parseSheduler.getLink('ИВБО-02-19');
      print(link.toString());
    });
  });
}