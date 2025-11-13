import 'package:flutter/material.dart';

@immutable
class AppStyles extends ThemeExtension<AppStyles> {
  final Color editPointButton;
  final Color deletePointButton;

  //text
  final Color focusColor;
  final Color defaultText;
  final Color actionsText;
  final Color titleText;

  // backgrounds
  final Color scaffoldBackground;
  final Color cardBackground;
  final Color tabBarBackground;
  final Color analysisSelectorBackground;

  const AppStyles({
    required this.editPointButton,
    required this.deletePointButton,
    required this.focusColor,
    required this.defaultText,
    required this.actionsText,
    required this.titleText,
    required this.scaffoldBackground,
    required this.cardBackground,
    required this.tabBarBackground,
    required this.analysisSelectorBackground,
  });

  @override
  AppStyles copyWith({
    Color? editPointButton,
    Color? deletePointButton,
    Color? focusColor,
    Color? defaultText,
    Color? actionsText,
    Color? titleText,
    Color? scaffoldBackground,
    Color? cardBackground,
    Color? tabBarBackground,
    Color? analysisSelectorBackground,
  }) {
    return AppStyles(
      editPointButton: editPointButton ?? this.editPointButton,
      deletePointButton: deletePointButton ?? this.deletePointButton,
      focusColor: focusColor ?? this.focusColor,
      defaultText: defaultText ?? this.defaultText,
      actionsText: actionsText ?? this.actionsText,
      titleText: titleText ?? this.titleText,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      tabBarBackground: tabBarBackground ?? this.tabBarBackground,
      analysisSelectorBackground:
          analysisSelectorBackground ?? this.analysisSelectorBackground,
    );
  }

  @override
  AppStyles lerp(ThemeExtension<AppStyles>? other, double t) {
    if (other is! AppStyles) return this;
    return AppStyles(
      editPointButton: Color.lerp(editPointButton, other.editPointButton, t)!,
      deletePointButton:
          Color.lerp(deletePointButton, other.deletePointButton, t)!,
      focusColor: Color.lerp(focusColor, other.focusColor, t)!,
      defaultText: Color.lerp(defaultText, other.defaultText, t)!,
      actionsText: Color.lerp(actionsText, other.actionsText, t)!,
      titleText: Color.lerp(titleText, other.titleText, t)!,
      scaffoldBackground:
          Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      tabBarBackground:
          Color.lerp(tabBarBackground, other.tabBarBackground, t)!,
      analysisSelectorBackground:
          Color.lerp(
            analysisSelectorBackground,
            other.analysisSelectorBackground,
            t,
          )!,
    );
  }
}
