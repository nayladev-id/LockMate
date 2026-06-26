import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. Tambahkan import ini

import 'app/app.dart';
import 'features/auth/provider/auth_provider.dart';
import 'features/vault/provider/vault_provider.dart';
import 'services/crypto_service.dart';
import 'services/secure_storage_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  // ── 1. Flutter binding ────────────────────────────────────────────────────
  WidgetsFlutterBinding.ensureInitialized();

  // ── 2. Inisialisasi Supabase (Tambahan Baru) ──────────────────────────────
  await Supabase.initialize(
    url:
        'https://badwaxzuelgjvawytbuu.supabase.co', // Ganti dengan URL dari dashboard Supabase
    anonKey:
        'sb_publishable_em6jbrr_Y-NFkTEBk7VoWA_EXvDSqrv', // Ganti dengan Anon Key dari dashboard Supabase
  );

  // ── 3. SharedPreferences warm-up ──────────────────────────────────────────
  await SharedPreferences.getInstance();

  // ── 4. Instansiasi services ────────────────────────────────────────────────
  final cryptoService = CryptoService();
  final secureStorageService = SecureStorageService();
  final storageService = StorageService();

  // ── 5. Bootstrap app dengan Provider ──────────────────────────────────────
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            crypto: cryptoService,
            secureStorage: secureStorageService,
            storage: storageService,
          ),
        ),
        ChangeNotifierProvider<VaultProvider>(
          create: (_) =>
              VaultProvider(storage: storageService, crypto: cryptoService),
        ),
      ],
      child: const LockMateApp(),
    ),
  );
}
