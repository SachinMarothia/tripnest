import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

abstract final class AppTheme {
  AppTheme._();

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,

      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.primaryDark,

      secondary: AppColors.secondary,
      onSecondary: AppColors.white,

      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.secondaryDark,

      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,

      error: AppColors.error,
      onError: AppColors.white,

      outline: AppColors.lightBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.lightBackground,

      // ========================================================
      // TEXT THEME
      // ========================================================

      textTheme: _textTheme(
        primaryColor: AppColors.lightTextPrimary,
        secondaryColor: AppColors.lightTextSecondary,
      ),

      // ========================================================
      // APP BAR
      // ========================================================

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      // ========================================================
      // CARDS
      // ========================================================

      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),

      // ========================================================
      // INPUT FIELDS
      // ========================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInputFill,

        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.lightTextTertiary,
        ),

        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.lightTextSecondary,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: _inputBorder(AppColors.lightBorder),

        enabledBorder: _inputBorder(
          AppColors.lightBorder,
        ),

        focusedBorder: _inputBorder(
          AppColors.primary,
          width: 1.5,
        ),

        errorBorder: _inputBorder(
          AppColors.error,
        ),

        focusedErrorBorder: _inputBorder(
          AppColors.error,
          width: 1.5,
        ),
      ),

      // ========================================================
      // ELEVATED BUTTON
      // ========================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,

          minimumSize: const Size(
            double.infinity,
            52,
          ),

          textStyle: AppTextStyles.button,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // ========================================================
      // OUTLINED BUTTON
      // ========================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,

          minimumSize: const Size(
            double.infinity,
            52,
          ),

          textStyle: AppTextStyles.button,

          side: const BorderSide(
            color: AppColors.lightBorder,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // ========================================================
      // TEXT BUTTON
      // ========================================================

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // ========================================================
      // NAVIGATION BAR
      // ========================================================

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightNavigationBar,
        indicatorColor: AppColors.primaryContainer,
        elevation: 0,

        labelTextStyle: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
              );
            }

            return AppTextStyles.labelSmall.copyWith(
              color: AppColors.lightTextSecondary,
            );
          },
        ),

        iconTheme: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: AppColors.primary,
              );
            }

            return const IconThemeData(
              color: AppColors.lightTextSecondary,
            );
          },
        ),
      ),

      // ========================================================
      // DIVIDER
      // ========================================================

      dividerTheme: const DividerThemeData(
        color: AppColors.lightDivider,
        thickness: 1,
        space: 1,
      ),

      // ========================================================
      // ICON
      // ========================================================

      iconTheme: const IconThemeData(
        color: AppColors.lightTextPrimary,
      ),

      // ========================================================
      // PROGRESS INDICATOR
      // ========================================================

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),

      // ========================================================
      // SNACKBAR
      // ========================================================

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightTextPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ============================================================
  // DARK THEME
  // ============================================================

  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkBackground,

      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkTextPrimary,

      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkBackground,

      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondaryContainer: AppColors.darkTextPrimary,

      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,

      error: AppColors.error,
      onError: AppColors.white,

      outline: AppColors.darkBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.darkBackground,

      // ========================================================
      // TEXT
      // ========================================================

      textTheme: _textTheme(
        primaryColor: AppColors.darkTextPrimary,
        secondaryColor: AppColors.darkTextSecondary,
      ),

      // ========================================================
      // APP BAR
      // ========================================================

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      // ========================================================
      // CARDS
      // ========================================================

      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),

          side: const BorderSide(
            color: AppColors.darkBorder,
            width: 1,
          ),
        ),
      ),

      // ========================================================
      // INPUT
      // ========================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInputFill,

        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkTextTertiary,
        ),

        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: _inputBorder(
          AppColors.darkBorder,
        ),

        enabledBorder: _inputBorder(
          AppColors.darkBorder,
        ),

        focusedBorder: _inputBorder(
          AppColors.darkPrimary,
          width: 1.5,
        ),

        errorBorder: _inputBorder(
          AppColors.error,
        ),

        focusedErrorBorder: _inputBorder(
          AppColors.error,
          width: 1.5,
        ),
      ),

      // ========================================================
      // ELEVATED BUTTON
      // ========================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,

          minimumSize: const Size(
            double.infinity,
            52,
          ),

          textStyle: AppTextStyles.button,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // ========================================================
      // OUTLINED BUTTON
      // ========================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,

          minimumSize: const Size(
            double.infinity,
            52,
          ),

          textStyle: AppTextStyles.button,

          side: const BorderSide(
            color: AppColors.darkBorder,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // ========================================================
      // TEXT BUTTON
      // ========================================================

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // ========================================================
      // NAVIGATION
      // ========================================================

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkNavigationBar,
        indicatorColor: AppColors.darkPrimaryContainer,
        elevation: 0,

        labelTextStyle: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return AppTextStyles.labelSmall.copyWith(
                color: AppColors.darkPrimary,
              );
            }

            return AppTextStyles.labelSmall.copyWith(
              color: AppColors.darkTextSecondary,
            );
          },
        ),

        iconTheme: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: AppColors.darkPrimary,
              );
            }

            return const IconThemeData(
              color: AppColors.darkTextSecondary,
            );
          },
        ),
      ),

      // ========================================================
      // DIVIDER
      // ========================================================

      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 1,
      ),

      // ========================================================
      // ICON
      // ========================================================

      iconTheme: const IconThemeData(
        color: AppColors.darkTextPrimary,
      ),

      // ========================================================
      // PROGRESS
      // ========================================================

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.darkPrimary,
      ),

      // ========================================================
      // SNACKBAR
      // ========================================================

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,

        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ============================================================
  // TEXT THEME
  // ============================================================

  static TextTheme _textTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: primaryColor,
      ),

      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: primaryColor,
      ),

      headlineLarge: AppTextStyles.headingLarge.copyWith(
        color: primaryColor,
      ),

      headlineMedium: AppTextStyles.headingMedium.copyWith(
        color: primaryColor,
      ),

      headlineSmall: AppTextStyles.headingSmall.copyWith(
        color: primaryColor,
      ),

      titleLarge: AppTextStyles.titleLarge.copyWith(
        color: primaryColor,
      ),

      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: primaryColor,
      ),

      titleSmall: AppTextStyles.titleSmall.copyWith(
        color: primaryColor,
      ),

      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: primaryColor,
      ),

      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: primaryColor,
      ),

      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: secondaryColor,
      ),

      labelLarge: AppTextStyles.labelLarge.copyWith(
        color: primaryColor,
      ),

      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: secondaryColor,
      ),

      labelSmall: AppTextStyles.labelSmall.copyWith(
        color: secondaryColor,
      ),
    );
  }

  // ============================================================
  // INPUT BORDER
  // ============================================================

  static OutlineInputBorder _inputBorder(
      Color color, {
        double width = 1,
      }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),

      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}