import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/ui/notification_page/notification_page_state.dart';

class NotificationPageStateHolder
    extends StateNotifier<List<NotificationPageItemData>> {
  NotificationPageStateHolder() : super([]);

  void update(List<NotificationPageItemData> items) {
    state = items;
  }
}

final notificationPageStateHolderProvider =
    Provider((ref) => NotificationPageStateHolder());
