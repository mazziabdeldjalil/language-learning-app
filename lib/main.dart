import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/backend.dart';
import 'core/supabase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';
import 'providers/theme_provider.dart';
import 'screens/index.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAzRGMSzkJ85Oa6gxw9PId-DkuRyQOyTh0",
          authDomain: "fluentydz.firebaseapp.com",
          projectId: "fluentydz",
          storageBucket: "fluentydz.firebasestorage.app",
          messagingSenderId: "416381337314",
          appId: "1:416381337314:web:8c7166fe13a5ad5331a8bb",
        ),
      );
    }
  } catch (e) {
    debugPrint("Firebase already initialized or error: $e");
  }

  await NotificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  AppThemePreset _currentPreset = AppThemePreset.darkGreen;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(AppThemeManager.storageKey);
    if (!mounted) return;
    setState(() => _currentPreset = AppThemeManager.fromString(saved));
  }

  void setTheme(AppThemePreset preset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppThemeManager.storageKey, AppThemeManager.toStorageString(preset));
    if (!mounted) return;
    setState(() => _currentPreset = preset);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FluentlyDZ',
      theme: AppThemeManager.themeFor(_currentPreset),
      darkTheme: AppThemeManager.themeFor(_currentPreset),
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/learn': (context) => const LearnScreen(),
        '/community': (context) => const CommunityScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/login': (context) => const LoginScreen(),
        '/scenario': (context) => const ScenarioSelectionScreen(),
        '/difficulty': (context) => const DifficultySelectionScreen(),
        '/chat': (context) => const ChatScreen(),
        '/teacher': (context) => const TeacherScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/student-detail': (context) {
          final student = ModalRoute.of(context)!.settings.arguments as StudentSummary;
          return StudentDetailScreen(student: student);
        },
        '/my-class': (context) => const MyClassScreen(),
      },
    );
  }
}

class _AppEntry extends StatefulWidget {
  const _AppEntry();

  @override
  State<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<_AppEntry> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Provider.of<ChatProvider>(context, listen: false).initialize();
    if (mounted) setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Check Supabase auth first
    final session = SupabaseConfig.client.auth.currentSession;
    if (session == null) {
      // Show onboarding before login
      return const WelcomeToEnglishAIScreen();
    }

    // Authenticated - go to HomeScreen
    return const HomeScreen();
  }
}





