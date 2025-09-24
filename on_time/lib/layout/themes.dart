import 'package:flutter/material.dart';
import 'package:on_time/layout/app_styles.dart';
import 'package:on_time/utils/colors.dart';

extension AppTheme on BuildContext {
  AppStyles get colors => Theme.of(this).extension<AppStyles>()!;
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundGrayLight,
  splashColor: Colors.transparent,
  extensions: <ThemeExtension<AppStyles>>[
    AppStyles(
      editPointButton: AppColors.editButtonBackground,
      deletePointButton: AppColors.deleteButtonBackground,
      focusColor: AppColors.strongBlueLight,
      defaultText: AppColors.defaultTextLight,
      actionsText: AppColors.darkGrayLight,
      titleText: AppColors.labelMediumGrayLight,
      scaffoldBackground: AppColors.backgroundGrayLight,
      cardBackground: Colors.grey,
      tabBarBackground: AppColors.white,
      analysisSelectorBackground: AppColors.analysisSelectorBackgroundLight,
    ),
  ],
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  splashColor: Colors.transparent,
  primaryColor: Colors.blueAccent,
  extensions: <ThemeExtension<AppStyles>>[
    const AppStyles(
      editPointButton: AppColors.backgroundCardDark,
      deletePointButton: AppColors.backgroundCardDark,
      focusColor: AppColors.strongBlueDark,
      defaultText: AppColors.white,
      actionsText: AppColors.white,
      titleText: AppColors.labelMediumDark,
      scaffoldBackground: AppColors.backgroundDark,
      cardBackground: AppColors.backgroundCardDark,
      tabBarBackground: AppColors.backgroundCardDark,
      analysisSelectorBackground: AppColors.backgroundCardDark,
    ),
  ],
);
