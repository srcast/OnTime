import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/tutorial/home_tutorial.dart';
import 'package:on_time/tutorial/tutorial_flow.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/layout/widgets/activity_card.dart';
import 'package:on_time/layout/widgets/day_summary.dart';
import 'package:on_time/layout/widgets/dialog.dart';
import 'package:on_time/layout/widgets/point_modal.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  List<Ponto>? _lastPointsShown;
  final _tutorialKeys = HomeTutorialKeys();
  final _tutorialPoints = [homeTutorialExamplePoint()];
  bool _tutorialStarted = false;

  // tutorial at this page -> shown once (not on every build); again if it restarts
  void _startTutorialOnce(TutorialFlow tutorial) {
    if (!tutorial.isAt(TutorialStep.home)) {
      _tutorialStarted = false;
      return;
    }
    if (_tutorialStarted) return;
    _tutorialStarted = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) showHomeTutorial(context, _tutorialKeys, tutorial);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // new list of points -> animates list to last position
  void _scrollToLastPointOnChange(List<Ponto> points) {
    if (identical(points, _lastPointsShown)) return;
    _lastPointsShown = points;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<DateTime?> _showPointModal(DateTime date, {bool isUpdate = false}) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PointModal(date: date, isUpdate: isUpdate),
    );
  }

  Future<void> _addPoint(HomePageVM vm) async {
    final date = await _showPointModal(vm.date);
    if (date != null) await vm.addPoint(date);
  }

  Future<void> _updatePoint(HomePageVM vm, Ponto point) async {
    final date = await _showPointModal(point.date, isUpdate: true);
    if (date != null) await vm.updatePoint(point, date);
  }

  Future<void> _deletePoint(HomePageVM vm, Ponto point) async {
    final confirmed = await DialogPopup.show(
      context,
      title: Labels.delete.tr(),
      message: Labels.deletePointMsg.tr(),
      negativeResponse: Labels.cancel.tr(),
      positiveResponse: Labels.delete.tr(),
    );
    if (confirmed) await vm.deletePoint(point);
  }

  Future<void> _openCalendar(HomePageVM vm) async {
    final date = await DatesHelper.pickDate(context, vm.date);
    await vm.selectDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomePageVM>();
    final tutorial = context.watch<TutorialFlow>();
    final isTutorial = tutorial.isAt(TutorialStep.home);
    _startTutorialOnce(tutorial);

    // tutorial -> example point instead of the saved ones
    final points = isTutorial ? _tutorialPoints : vm.points;
    _scrollToLastPointOnChange(points);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => vm.changeDate('-'),
                  icon: Icon(Icons.arrow_back_ios),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => _openCalendar(vm),
                        child: Text(
                          toBeginningOfSentenceCase(
                                DateFormat(
                                  "E, d MMMM y",
                                  Localizations.localeOf(context).toString(),
                                ).format(vm.date),
                              ) ??
                              '',
                          style: TextStyle(
                            fontSize: 16,
                            color: context.colors.defaultText,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35, // fixes height
                        child:
                            vm.timerVisible
                                ? Text(
                                  vm.hour,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                : OutlinedButton(
                                  onPressed: () => vm.goToToday(),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: AppColors.softGreen,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    side: BorderSide(
                                      color: AppColors.softGreen,
                                    ),
                                  ),
                                  child: Text(
                                    Labels.today.tr(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed:
                      vm.timerVisible
                          ? null
                          : () => vm.changeDate(
                            '+',
                          ), // timer visible, it means it is today, cant go further on date
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 10),

                  points.isEmpty
                      ? Expanded(
                        child: Center(child: Text(Labels.noPointsDayMsg.tr())),
                      )
                      : Expanded(
                        child: SlidableAutoCloseBehavior(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: points.length,
                            itemBuilder: (context, index) {
                              final ponto = points[index];

                              final bool showText = ponto.getIn && index > 0;
                              final String textToShow =
                                  showText
                                      ? (ponto.sessionId !=
                                              points[index - 1].sessionId
                                          ? Labels.workBegins.tr()
                                          : Labels.pause.tr())
                                      : '';
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (showText)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        textToShow,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),

                                  Slidable(
                                    key:
                                        isTutorial
                                            ? _tutorialKeys.listItem
                                            : ValueKey(ponto.id),
                                    endActionPane: ActionPane(
                                      motion: const DrawerMotion(),
                                      extentRatio: 0.4,
                                      children: [
                                        SlidableAction(
                                          key:
                                              isTutorial
                                                  ? _tutorialKeys.pointEdit
                                                  : null,
                                          onPressed:
                                              (_) => _updatePoint(vm, ponto),
                                          backgroundColor:
                                              context.colors.editPointButton,
                                          foregroundColor: AppColors.editButton,
                                          icon: Icons.edit,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        SlidableAction(
                                          key:
                                              isTutorial
                                                  ? _tutorialKeys.pointDelete
                                                  : null,
                                          onPressed:
                                              (_) => _deletePoint(vm, ponto),
                                          backgroundColor:
                                              context.colors.deletePointButton,
                                          foregroundColor:
                                              AppColors.deleteButton,
                                          icon: Icons.delete_outline,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: ActivityCard(
                                      key:
                                          isTutorial
                                              ? _tutorialKeys.listItemContent
                                              : ValueKey(
                                                'activity_card_${ponto.id}',
                                              ),
                                      ponto: ponto,
                                      index: index,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                  SizedBox(height: 10),
                ],
              ),
            ),
            DaySummary(
              minutesWorked: vm.sessionMinutes,
              hourValue: vm.hourValueBase,
              profit: vm.sessionProfit,
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              key: _tutorialKeys.checkIn,
              backgroundColor: AppColors.softGreen,
              foregroundColor: AppColors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () => _addPoint(vm),
              child: Icon(Icons.add, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
