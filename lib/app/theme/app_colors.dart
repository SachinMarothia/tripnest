import 'package:flutter/material.dart';

/// Central color system for TripMate.
///
/// Important:
/// UI widgets should prefer Theme.of(context).colorScheme
/// instead of directly accessing these colors.
///
/// Example:
///   Theme.of(context).colorScheme.primary
///
/// AppColors should mainly be used while defining themes
/// and for special brand/semantic colors.
abstract final class AppColors {
  AppColors._();

  // ============================================================
  // BRAND COLORS
  // ============================================================

  /// Main TripMate brand color.
  static const Color primary = Color(0xFF00796B);

  /// Darker version of the primary brand color.
  static const Color primaryDark = Color(0xFF005B50);

  /// Lighter brand color.
  static const Color primaryLight = Color(0xFF4DB6AC);

  /// Very light primary container.
  static const Color primaryContainer = Color(0xFFD7F2EE);

  /// Secondary travel/navigation blue.
  static const Color secondary = Color(0xFF3D7EFF);

  static const Color secondaryDark = Color(0xFF285FC7);

  static const Color secondaryLight = Color(0xFF7DA5FF);

  static const Color secondaryContainer = Color(0xFFDDE8FF);

  /// Warm accent for ratings, highlights and travel experiences.
  static const Color accent = Color(0xFFF5A623);

  static const Color accentLight = Color(0xFFFFE4B2);

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static const Color lightBackground = Color(0xFFF7F9FC);

  static const Color lightSurface = Color(0xFFFFFFFF);

  static const Color lightSurfaceVariant = Color(0xFFF0F3F7);

  static const Color lightCard = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF172033);

  static const Color lightTextSecondary = Color(0xFF667085);

  static const Color lightTextTertiary = Color(0xFF98A2B3);

  static const Color lightBorder = Color(0xFFE4E7EC);

  static const Color lightDivider = Color(0xFFEAECF0);

  static const Color lightDisabled = Color(0xFFD0D5DD);

  static const Color lightNavigationBar = Color(0xFFFFFFFF);

  static const Color lightInputFill = Color(0xFFF5F7FA);

  // ============================================================
  // DARK THEME
  // ============================================================

  /// Main dark background.
  ///
  /// Slight blue/green undertone rather than pure black.
  static const Color darkBackground = Color(0xFF0E1518);

  static const Color darkSurface = Color(0xFF151E22);

  static const Color darkSurfaceVariant = Color(0xFF1C282D);

  static const Color darkCard = Color(0xFF182328);

  static const Color darkTextPrimary = Color(0xFFF5F7F8);

  static const Color darkTextSecondary = Color(0xFFAAB8BE);

  static const Color darkTextTertiary = Color(0xFF78888F);

  static const Color darkBorder = Color(0xFF2B393F);

  static const Color darkDivider = Color(0xFF253238);

  static const Color darkDisabled = Color(0xFF536168);

  static const Color darkNavigationBar = Color(0xFF121B1F);

  static const Color darkInputFill = Color(0xFF1A252A);

  // ============================================================
  // DARK THEME BRAND VARIANTS
  // ============================================================

  /// Brighter primary color gives better contrast on dark surfaces.
  static const Color darkPrimary = Color(0xFF5AC8BA);

  static const Color darkPrimaryContainer = Color(0xFF164D47);

  static const Color darkSecondary = Color(0xFF8BADFF);

  static const Color darkSecondaryContainer = Color(0xFF233F75);

  // ============================================================
  // SEMANTIC COLORS
  // ============================================================

  static const Color success = Color(0xFF2E9B66);

  static const Color successContainer = Color(0xFFDDF5E8);

  static const Color warning = Color(0xFFF59E0B);

  static const Color warningContainer = Color(0xFFFFF0CF);

  static const Color error = Color(0xFFD64545);

  static const Color errorContainer = Color(0xFFFFE1E1);

  static const Color info = Color(0xFF3B82F6);

  static const Color infoContainer = Color(0xFFDCEAFF);

  // ============================================================
  // TRAVEL / FEATURE COLORS
  // ============================================================

  /// Used for hotel/accommodation related UI.
  static const Color hotel = Color(0xFF4776E6);

  /// Used for transport related UI.
  static const Color transport = Color(0xFF12A594);

  /// Used for food expenses/activities.
  static const Color food = Color(0xFFFF8A4C);

  /// Used for attractions and activities.
  static const Color activity = Color(0xFF8B5CF6);

  /// Used for shopping expenses.
  static const Color shopping = Color(0xFFE85D9E);

  /// Used for flights.
  static const Color flight = Color(0xFF4C8BF5);

  /// Used for documents.
  static const Color document = Color(0xFF7357D5);

  /// Used for packing/checklists.
  static const Color packing = Color(0xFF22A67A);

  // ============================================================
  // RATINGS
  // ============================================================

  static const Color rating = Color(0xFFFFB020);

  // ============================================================
  // MAP COLORS
  // ============================================================

  static const Color mapRoute = Color(0xFF3578E5);

  static const Color mapMarker = Color(0xFFE5484D);

  // ============================================================
  // COMMON
  // ============================================================

  static const Color white = Color(0xFFFFFFFF);

  static const Color black = Color(0xFF000000);

  static const Color transparent = Colors.transparent;

  // ============================================================
  // OVERLAYS
  // ============================================================

  static const Color imageOverlay = Color(0x66000000);

  static const Color imageOverlayStrong = Color(0x99000000);
}