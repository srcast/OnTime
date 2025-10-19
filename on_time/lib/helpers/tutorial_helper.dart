import 'package:on_time/database/locator.dart';
import 'package:on_time/services/configs_service.dart';

class TutorialHelper {
  static bool hasSeenTutorial = false;
  static bool tutorialOngoing = false;
  static bool tutorialOngoingConfigsPage = false;

  static Future<void> cancelTutorial() async {
    hasSeenTutorial = true;
    tutorialOngoing = false;
    tutorialOngoingConfigsPage = false;
    await locator<ConfigsService>().updateHasSeenTutorial(hasSeenTutorial);
  }
}
