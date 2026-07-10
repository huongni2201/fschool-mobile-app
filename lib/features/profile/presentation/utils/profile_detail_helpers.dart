part of '../pages/profile_page.dart';

String _profileValue(String? value) {
  final trimmed = value?.trim();

  if (trimmed == null || trimmed.isEmpty) return ProfileStrings.updating;

  return trimmed;
}
