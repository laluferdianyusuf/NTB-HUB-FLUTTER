import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OnboardingSlide {
  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    this.backgroundImage,
    this.isInterestSlide = false,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final String? backgroundImage;
  final bool isInterestSlide;

  bool get isFullScreenBackground => backgroundImage != null;
}

abstract final class OnboardingSlides {
  static const welcomeBackground =
      'lib/core/assets/images/onboarding/onboarding_welcome.png';
  static const eventsBackground =
      'lib/core/assets/images/onboarding/onboarding_events.png';
  static const interestsBackground =
      'lib/core/assets/images/onboarding/onboarding_interests.png';

  static const slides = [
    OnboardingSlide(
      title: 'Selamat Datang di NTB Hub',
      description:
          'Platform komunitas untuk warga Nusa Tenggara Barat. '
          'Terhubung, berbagi, dan jelajahi NTB bersama.',
      icon: Iconsax.global,
      gradient: [Color(0xFF1B5E4B), Color(0xFF2E8B6E)],
      backgroundImage: welcomeBackground,
    ),
    OnboardingSlide(
      title: 'Temukan Event & Venue',
      description:
          'Cari event menarik, booking venue, dan temukan tempat '
          'public place terbaik di sekitar Anda.',
      icon: Iconsax.calendar,
      gradient: [Color(0xFF0F4C75), Color(0xFF3282B8)],
      backgroundImage: eventsBackground,
    ),
    OnboardingSlide(
      title: 'Pilih Minat Anda',
      description:
          'Pilih topik yang Anda sukai agar kami bisa merekomendasikan '
          'konten yang relevan untuk Anda.',
      icon: Iconsax.heart,
      gradient: [Color(0xFF6A0572), Color(0xFFAB83A1)],
      backgroundImage: interestsBackground,
      isInterestSlide: true,
    ),  ];
}
