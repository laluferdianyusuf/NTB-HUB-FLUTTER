import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

abstract final class UserInterests {
  static const options = [
    InterestOption(id: 'wisata', label: 'Wisata', icon: Iconsax.map),
    InterestOption(id: 'kuliner', label: 'Kuliner', icon: Iconsax.coffee),
    InterestOption(id: 'event', label: 'Event', icon: Iconsax.calendar),
    InterestOption(id: 'umkm', label: 'UMKM', icon: Iconsax.shop),
    InterestOption(id: 'budaya', label: 'Budaya', icon: Iconsax.book),
    InterestOption(id: 'olahraga', label: 'Olahraga', icon: Iconsax.activity),
    InterestOption(id: 'komunitas', label: 'Komunitas', icon: Iconsax.people),
    InterestOption(id: 'booking', label: 'Booking', icon: Iconsax.ticket),
  ];
}

class InterestOption {
  const InterestOption({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

class OnboardingSlide {
  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    this.isInterestSlide = false,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final bool isInterestSlide;
}

abstract final class OnboardingSlides {
  static const slides = [
    OnboardingSlide(
      title: 'Selamat Datang di NTB Hub',
      description:
          'Platform komunitas untuk warga Nusa Tenggara Barat. '
          'Terhubung, berbagi, dan jelajahi NTB bersama.',
      icon: Iconsax.global,
      gradient: [Color(0xFF1B5E4B), Color(0xFF2E8B6E)],
    ),
    OnboardingSlide(
      title: 'Temukan Event & Venue',
      description:
          'Cari event menarik, booking venue, dan temukan tempat '
          'public place terbaik di sekitar Anda.',
      icon: Iconsax.calendar,
      gradient: [Color(0xFF0F4C75), Color(0xFF3282B8)],
    ),
    OnboardingSlide(
      title: 'Pilih Minat Anda',
      description:
          'Pilih topik yang Anda sukai agar kami bisa merekomendasikan '
          'konten yang relevan untuk Anda.',
      icon: Iconsax.heart,
      gradient: [Color(0xFF6A0572), Color(0xFFAB83A1)],
      isInterestSlide: true,
    ),
  ];
}
