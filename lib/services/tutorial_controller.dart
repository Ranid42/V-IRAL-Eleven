import 'package:shared_preferences/shared_preferences.dart';

import '../demo_strings.dart';

class TutorialController {
  static const String _prefix = 'showcase_tutorial_seen_';

  static Future<bool> hasSeenStep(String stepId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefix$stepId') ?? false;
  }

  static Future<void> markStepSeen(String stepId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$stepId', true);
  }

  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (final id in DemoStrings.tutorialAllStepIds) {
      await prefs.remove('$_prefix$id');
    }
  }
}
