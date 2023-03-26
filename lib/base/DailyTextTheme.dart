import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyTextTheme extends TextTheme {
  DailyTextTheme({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelSmall,
  }) : super(
    displayLarge: Get.theme.textTheme.displayLarge?.merge(displayLarge),
    displayMedium: Get.theme.textTheme.displayMedium?.merge(displayMedium),
    displaySmall: Get.theme.textTheme.displaySmall?.merge(displaySmall),
    headlineMedium: Get.theme.textTheme.headlineMedium?.merge(headlineMedium),
    headlineSmall: Get.theme.textTheme.headlineSmall?.merge(headlineSmall),
    titleLarge: Get.theme.textTheme.titleLarge?.merge(titleLarge),
    titleMedium: Get.theme.textTheme.titleMedium?.merge(titleMedium),
    titleSmall: Get.theme.textTheme.titleSmall?.merge(titleSmall),
    bodyLarge: Get.theme.textTheme.bodyLarge?.merge(bodyLarge),
    bodyMedium: Get.theme.textTheme.bodyMedium?.merge(bodyMedium),
    bodySmall: Get.theme.textTheme.bodySmall?.merge(bodySmall),
    labelLarge: Get.theme.textTheme.labelLarge?.merge(labelLarge),
    labelSmall: Get.theme.textTheme.labelSmall?.merge(labelSmall),
  );
}
