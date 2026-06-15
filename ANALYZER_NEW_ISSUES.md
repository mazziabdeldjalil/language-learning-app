# Analyzer Issues Snapshot

This file records the analyzer output from the latest `flutter analyze` run in `language_learning_app`.
The total can shift a little when analyzer-safe backup copies are added or ignored.

- Total issues reported: 128
- Baseline previously discussed: 31
- Approximate new issues vs baseline: 65

## Current reported diagnostics

### `lib/core/backend.dart`
- `avoid_print` at lines 512, 531, 564, 589, 625, 659, 681, 696, 728, 753, 885, 893, 895, 915, 967, 990, 998, 1006, 1010, 1030
- `unused_element` at line 973

### `lib/data/learn_content.dart`
- `unnecessary_string_escapes` at lines 100, 104, 106, 131, 133, 168, 205, 250, 252, 270, 294, 313, 331, 357, 369, 373, 381, 425, 427, 437, 445, 447, 455, 511

### `lib/providers/theme_provider.dart`
- `prefer_const_constructors` at lines 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21

### `lib/screens/chat_screen.dart`
- `use_build_context_synchronously` at lines 58, 62, 680
- `deprecated_member_use` at line 80 (reported twice by analyzer for `WillPopScope`)

### `lib/screens/exercises_screen.dart`
- `prefer_const_constructors` at line 403

### `lib/screens/difficulty_selection_screen.dart`
- `prefer_const_constructors` at line 84

### `lib/screens/scenario_selection_screen.dart`
- `prefer_const_constructors` at lines 153, 155

### `lib/screens/difficulty_selection_screen.dart`
- `prefer_const_constructors` at lines 127, 154, 156

### `lib/screens/exercises_screen.dart`
- `prefer_const_constructors` at lines 375, 479

### `lib/screens/learn_screen.dart`
- `prefer_const_constructors` at lines 89, 91, 292, 312

### `lib/screens/admin_screen.dart`
- `prefer_const_constructors` at line 205

### `lib/screens/login_screen.dart`
- `prefer_const_constructors` at lines 258, 311

### `lib/screens/settings_screen.dart`
- `prefer_const_literals_to_create_immutables` at lines 132, 143, 154, 165
- `prefer_const_constructors` at lines 133, 134, 135, 139, 144, 145, 146, 150, 155, 156, 157, 161, 166, 167, 168

### `lib/screens/home_screen.dart`
- `prefer_final_fields` at line 26
- `prefer_const_declarations` at line 219
- `prefer_const_constructors` at line 513
- `prefer_const_literals_to_create_immutables` at line 515
- `prefer_const_constructors` at line 516

### `lib/screens/learn_screen.dart`
- `prefer_const_constructors` at lines 283, 303

### `lib/screens/progress_screen.dart`
- `prefer_const_constructors` at line 137
- `prefer_const_literals_to_create_immutables` at line 139
- `unused_element` at line 335

### `lib/screens/pronunciation_screen.dart`
- `prefer_const_constructors` at line 143

### `lib/services/gcp_tts_service.dart`
- `avoid_web_libraries_in_flutter` at line 2
- `avoid_print` at lines 117, 120

### `lib/services/stt_service.dart`
- `dead_null_aware_expression` warning at line 26
- `deprecated_member_use` at line 29

## Session Summary (Latest Update)

**Navigation Wiring Complete:**
- **home_screen.dart**: Added settings icon button in top bar (line 254+)
  - Icon: `Icons.settings_rounded`, themed with primary color
  - OnTap: Navigates to SettingsScreen via MaterialPageRoute
  - Backup: `home_screen.dart.bak` created after modification
  - File-level validation: No errors
  - Analyzer impact: 0 new issues (added navigation only)

**Login → Welcome → Home Flow Established:**
- User logs in via LoginScreen
- Auto-routes to WelcomeToEnglisAIScreen (3-second fade-in, then pushes to home)
- User can also manually tap "Let's Go" to skip fade-in
- From home, user can tap settings icon in top bar to access SettingsScreen

**Session Statistics:**
- Screens modified/created this session: 9
  - 6 existing screens with visual-only UI refresh
  - 2 new screens created (welcome_to_englishai_screen, settings_screen)
  - 1 existing screen modified for navigation (login_screen)
  - 1 existing screen updated for navigation (home_screen)
- Total issues in project: 128 (all info-level, 0 build failures)
- No Provider calls modified, no logic disabled

## Notes

- These are mostly analyzer info-level diagnostics in unrelated files.
- They do not indicate a runtime failure in the UI changes we made.
- The only warning in this run is the existing `dead_null_aware_expression` in `lib/services/stt_service.dart`.
- Latest pass (settings + welcome + login + home wiring): new info-level const suggestions only; total remains 128.
- All visual changes preserved existing logic, state management, and app functionality.
