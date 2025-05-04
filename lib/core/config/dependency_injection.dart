import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/services/firebase_auth_service.dart';
import '../../features/auth/data/services/local_auth_service.dart';
import '../../features/auth/data/services/secure_storage_service.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

/// Initializes all dependencies
Future<void> initDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Services
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  getIt.registerLazySingleton<LocalAuthService>(() => LocalAuthService());
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      localAuthService: getIt<LocalAuthService>(),
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );

  // Core

  // Data sources

  // Use cases

  // Controllers/Providers
}
