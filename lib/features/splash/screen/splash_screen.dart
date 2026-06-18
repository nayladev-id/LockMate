import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Daftar pesan status dari HTML
  final List<String> _statusMsgs = [
    "Initializing Vault...",
    "Checking Biometrics...",
    "Decrypting Metadata...",
    "Establishing Secure Link...",
    "Verifying Sovereignty...",
  ];

  int _currentStatusIdx = 0;
  Timer? _statusTimer;
  late List<ParticleModel> _particles;

  @override
  void initState() {
    super.initState();
    // Generate 15 partikel acak seperti pada desain HTML
    final random = math.Random();
    _particles = List.generate(15, (index) {
      final colors = [
        const Color(0xFFF2CA50),
        const Color(0xFF47F8E1),
        const Color(0xFFD3E4FE),
      ];
      return ParticleModel(
        color: colors[random.nextInt(colors.length)],
        top: random.nextDouble(),
        left: random.nextDouble(),
        size: random.nextDouble() * 4 + 2,
      );
    });

    // Jalankan perputaran teks status setiap 3 detik
    _statusTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentStatusIdx = (_currentStatusIdx + 1) % _statusMsgs.length;
        });
      }
    });

    _initRouting();
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  Future<void> _initRouting() async {
    // Menunggu 4.5 detik agar animasi & transisi teks terasa premium
    await Future<void>.delayed(const Duration(milliseconds: 4500));

    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    final hasProfile = await auth.hasExistingProfile();

    if (!mounted) return;

    if (hasProfile) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.kBackground, // Latar belakang hitam pekat sesuai halaman 2
      body: Stack(
        children: [
          // 1. Ambient Background Layer (Radial Gradient Biru Siber Halus di atas Hitam)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    AppColors.kCyberGlow.withOpacity(
                      0.06,
                    ), // Sorotan biru siber sangat tipis di tengah layar
                    AppColors
                        .kBackground, // Menyatu dengan warna hitam pekat di tepinya
                  ],
                ),
              ),
            ),
          ),

          // 2. Random Background Particles
          ..._particles.map(
            (particle) => Positioned(
              top: MediaQuery.of(context).size.height * particle.top,
              left: MediaQuery.of(context).size.width * particle.left,
              child: Opacity(
                opacity:
                    0.15, // Dibuat sedikit lebih tipis agar serasi dengan background hitam
                child: Container(
                  width: particle.size,
                  height: particle.size,
                  decoration: BoxDecoration(
                    color: particle.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // Logo Cluster dengan Ring Glow Animasi Pulse Biru
                  Stack(
                        alignment: Alignment.center,
                        children: [
                          // Efek Denyut Cyber Glow Biru di Belakang Logo agar senada dengan halaman kedua
                          Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.kCyberGlow.withOpacity(0.12),
                                ),
                              )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .scale(
                                begin: const Offset(0.95, 0.95),
                                end: const Offset(1.05, 1.05),
                                duration: 1500.ms,
                                curve: Curves.easeInOut,
                              ),

                          // Gambar Logo Utama Anda
                          Image.asset(
                            'assets/images/logo.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                        curve: Curves.easeOutBack,
                        duration: 800.ms,
                      ),

                  const SizedBox(height: 24),

                  // Judul Aplikasi: LockMate
                  Text(
                    'LockMate',
                    style: AppTextStyles.headlineLg.copyWith(
                      color: AppColors
                          .kCyberGlow, // Diubah ke warna biru siber cerah sesuai tema halaman 2
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w800,
                      fontSize: 40,
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                  const SizedBox(height: 4),

                  // Tagline: SECURE YOUR DIGITAL LEGACY
                  Text(
                    'SECURE YOUR DIGITAL LEGACY',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.kOnSurfaceVariant,
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                  const SizedBox(height: 40),

                  // Glassmorphic Status Box
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kSurfaceContainer.withOpacity(
                          0.4,
                        ), // Menggunakan kontainer gelap bawaan tema
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.kCyberGlow.withOpacity(
                            0.15,
                          ), // Border biru siber tipis transparan
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.kCyberGlow,
                              ), // Loading warna biru siber
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Transisi Teks Status
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              _statusMsgs[_currentStatusIdx],
                              key: ValueKey<String>(
                                _statusMsgs[_currentStatusIdx],
                              ),
                              style: AppTextStyles.labelSm.copyWith(
                                color: AppColors.kOnSurfaceVariant,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

                  const Spacer(flex: 4),

                  // Loading Bar Progress Bawah
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Container(
                        width: 200,
                        height: 2,
                        color: Colors.white.withOpacity(0.05),
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.kCyberGlow,
                          ), // Progres warna biru siber
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Footer Keamanan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield,
                        size: 14,
                        color: AppColors.kOnSurfaceVariant.withOpacity(0.4),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'END-TO-END ENCRYPTED',
                        style: AppTextStyles.labelSm.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kOnSurfaceVariant.withOpacity(0.4),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ParticleModel {
  final Color color;
  final double top;
  final double left;
  final double size;

  ParticleModel({
    required this.color,
    required this.top,
    required this.left,
    required this.size,
  });
}
