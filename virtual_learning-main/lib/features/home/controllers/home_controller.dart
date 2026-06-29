
import 'package:flutter_riverpod/legacy.dart';

class HomeController extends StateNotifier<int> {
  HomeController() : super(0);

  void changeTab(int index) {
    state = index;
  }
}

final homeControllerProvider =
StateNotifierProvider<HomeController, int>(
      (ref) => HomeController(),
);