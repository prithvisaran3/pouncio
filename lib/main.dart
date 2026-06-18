import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'models/app_settings.dart';
import 'models/job.dart';
import 'models/job_filter.dart';
import 'models/notification_item.dart';
import 'router/router.dart';
import 'theme/colors.dart';
import 'features/settings/application/settings_provider.dart';
import 'services/fcm_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('[Pouncio Startup ERROR] Failed to load .env file: $e');
  }

  // Runtime authorization / security key verification
  final secretKey = dotenv.env['APP_SECRET_KEY'];
  const expectedKey = 'pouncio_secure_key_prithvi_2026';
  if (secretKey != expectedKey) {
    debugPrint('[Pouncio Startup ERROR] Security key verification failed.');
    runApp(const SecurityLockoutApp());
    return;
  }

  // Initialize Firebase
  debugPrint('[Pouncio Startup] Initializing Firebase...');
  bool isFirebaseInitialized = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('[Pouncio Startup] Firebase initialized successfully.');
    isFirebaseInitialized = true;
  } catch (e) {
    debugPrint('[Pouncio Startup ERROR] Failed to initialize Firebase core: $e');
  }

  if (isFirebaseInitialized) {
    // Initialize Firebase Messaging push notifications safely
    try {
      debugPrint('[Pouncio Startup] Configuring Push Notifications...');
      final messaging = FirebaseMessaging.instance;
      
      // Request permission (especially required on iOS)
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('[Pouncio Startup] Notification permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Subscribe to new jobs topic (may fail on simulator due to APNS token absence)
        try {
          await messaging.subscribeToTopic('new_jobs');
          debugPrint('[Pouncio Startup] Subscribed to "new_jobs" topic for push notifications.');
        } catch (e) {
          debugPrint('[Pouncio Startup WARNING] Failed to subscribe to topic "new_jobs" (expected on simulators): $e');
        }
      }

      // Configure foreground presentation options to display banners, play custom sound, etc.
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Configure foreground message handler
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[Pouncio Foreground Message] Title: ${message.notification?.title}, Body: ${message.notification?.body}');
      });
    } catch (e) {
      debugPrint('[Pouncio Startup WARNING] Failed to configure push notifications: $e');
    }
  }

  // Initialize Hive local cache
  debugPrint('[Pouncio Startup] Initializing Hive local cache...');
  await Hive.initFlutter();

  // Register all model adapters
  Hive.registerAdapter(JobImplAdapter());
  Hive.registerAdapter(EmploymentTypeAdapter());
  Hive.registerAdapter(RemoteTypeAdapter());
  Hive.registerAdapter(VisaStatusAdapter());
  Hive.registerAdapter(ExperienceLevelAdapter());
  Hive.registerAdapter(JobSourceAdapter());
  
  Hive.registerAdapter(JobFilterImplAdapter());
  Hive.registerAdapter(VisaFilterOptionAdapter());
  
  Hive.registerAdapter(NotificationItemImplAdapter());
  Hive.registerAdapter(FreshnessTierAdapter());
  Hive.registerAdapter(ReadStateAdapter());
  
  Hive.registerAdapter(AppSettingsImplAdapter());
  Hive.registerAdapter(AppThemeAdapter());

  // Open Hive boxes for settings and filters
  debugPrint('[Pouncio Startup] Opening Hive local storage boxes...');
  try {
    await Hive.openBox<AppSettings>('settings');
    await Hive.openBox<JobFilter>('filters');
    await Hive.openBox<Job>('saved_jobs');
    await Hive.openBox<String>('read_notifications');
    await Hive.openBox<String>('dismissed_notifications');
    debugPrint('[Pouncio Startup] Hive local database boxes opened successfully.');
  } catch (e) {
    debugPrint('[Pouncio Startup ERROR] Failed to open Hive boxes: $e');
  }

  runApp(
    const ProviderScope(
      child: PouncioApp(),
    ),
  );
}

class PouncioApp extends ConsumerWidget {
  const PouncioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize/sync FCM Token reactively for logged-in users
    ref.watch(fcmTokenInitializerProvider);

    // Watch settings to live-reload selected app theme
    final settings = ref.watch(settingsStateProvider);

    Brightness? brightness;
    switch (settings.theme) {
      case AppTheme.light:
        brightness = Brightness.light;
        break;
      case AppTheme.dark:
        brightness = Brightness.dark;
        break;
      case AppTheme.system:
        brightness = null; // Auto-delegate to iOS host system
        break;
    }

    return CupertinoApp.router(
      title: 'Pouncio',
      theme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: AppColors.accent,
        scaffoldBackgroundColor: settings.theme == AppTheme.dark
            ? AppColors.bgDark
            : (settings.theme == AppTheme.light ? AppColors.bgLight : null),
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class SecurityLockoutApp extends StatelessWidget {
  const SecurityLockoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        backgroundColor: const Color(0xFF1C1C1E),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.lock_shield_fill,
                    size: 80,
                    color: Color(0xFFFF453A),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Unauthorized Build',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'This application has been secured to prevent unauthorized replication and distribution.\n\nTo run this app, please ensure you have set the correct APP_SECRET_KEY in your local .env file and configured the required environment variables.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8E8E93),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Security Verification Failed',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 14,
                        color: Color(0xFFBF5AF2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
