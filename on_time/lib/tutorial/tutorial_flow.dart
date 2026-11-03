import 'package:flutter/foundation.dart';
import 'package:on_time/helpers/app_feedback.dart';
import 'package:on_time/services/configs_service.dart';

// pages of the tutorial, in order
enum TutorialStep { home, configurations, hourValue, done }

// state of the tutorial shared by the pages -> each page shows its part when the flow is at its step
class TutorialFlow extends ChangeNotifier {
  TutorialFlow(this._configsService, {required bool hasSeenTutorial})
    : _step = hasSeenTutorial ? TutorialStep.done : TutorialStep.home;

  final ConfigsService _configsService;
  TutorialStep _step;

  TutorialStep get step => _step;

  bool get isActive => _step != TutorialStep.done;

  bool isAt(TutorialStep step) => _step == step;

  Future<void> advance() async {
    if (!isActive) return;

    _step = TutorialStep.values[_step.index + 1];
    notifyListeners();
    if (_step == TutorialStep.done) await _saveHasSeen(true);
  }

  Future<void> skip() async {
    if (!isActive) return;

    _step = TutorialStep.done;
    notifyListeners();
    await _saveHasSeen(true);
  }

  Future<void> restart() async {
    _step = TutorialStep.home;
    notifyListeners();
    await _saveHasSeen(false);
  }

  Future<void> _saveHasSeen(bool hasSeen) async {
    try {
      await _configsService.updateHasSeenTutorial(hasSeen);
    } catch (e, s) {
      AppFeedback.logError('TutorialFlow._saveHasSeen', e, s);
    }
  }
}
