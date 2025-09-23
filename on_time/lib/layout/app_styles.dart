import 'package:flutter/material.dart';

@immutable
class AppStyles extends ThemeExtension<AppStyles> {
  final Color insertButton;
  final Color deleteButton;
  final Color cancelButton;
  final Color saveButton;

  final Color bodyText;
  final Color titleText;

  final Color scaffoldBackground;
  final Color cardBackground;

  const AppStyles({
    required this.insertButton,
    required this.deleteButton,
    required this.cancelButton,
    required this.saveButton,
    required this.bodyText,
    required this.titleText,
    required this.scaffoldBackground,
    required this.cardBackground,
  });

  @override
  AppStyles copyWith({
    Color? insertButton,
    Color? deleteButton,
    Color? cancelButton,
    Color? saveButton,
    Color? bodyText,
    Color? titleText,
    Color? scaffoldBackground,
    Color? cardBackground,
  }) {
    return AppStyles(
      insertButton: insertButton ?? this.insertButton,
      deleteButton: deleteButton ?? this.deleteButton,
      cancelButton: cancelButton ?? this.cancelButton,
      saveButton: saveButton ?? this.saveButton,
      bodyText: bodyText ?? this.bodyText,
      titleText: titleText ?? this.titleText,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      cardBackground: cardBackground ?? this.cardBackground,
    );
  }

  @override
  AppStyles lerp(ThemeExtension<AppStyles>? other, double t) {
    if (other is! AppStyles) return this;
    return AppStyles(
      insertButton: Color.lerp(insertButton, other.insertButton, t)!,
      deleteButton: Color.lerp(deleteButton, other.deleteButton, t)!,
      cancelButton: Color.lerp(cancelButton, other.cancelButton, t)!,
      saveButton: Color.lerp(saveButton, other.saveButton, t)!,
      bodyText: Color.lerp(bodyText, other.bodyText, t)!,
      titleText: Color.lerp(titleText, other.titleText, t)!,
      scaffoldBackground:
          Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
    );
  }
}
