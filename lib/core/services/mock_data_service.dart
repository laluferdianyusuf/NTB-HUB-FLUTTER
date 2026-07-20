import 'package:flutter/material.dart';

import 'package:latlong2/latlong.dart';

import '../../models/activity_model.dart';
import '../../models/carousel_item_model.dart';
import '../../models/group_model.dart';
import '../../models/home_event_model.dart';
import '../../models/news_model.dart';
import '../../models/post_model.dart';
import '../../models/quick_action_models.dart';
import '../../models/public_place_model.dart';
import '../../models/notification_model.dart';
import '../../models/task_model.dart';
import '../../models/transaction_model.dart';
import '../../models/user_model.dart';
import '../../models/venue_model.dart';

class MockDataService {
  const MockDataService();

  static final UserModel currentUser = UserModel(
    id: '1',
    name: 'Ahmad Rizki',
    email: 'ahmad.rizki@email.com',
    avatarUrl: null,
    location: 'Mataram, NTB',
    bio: 'Pecinta wisata dan budaya NTB',
    joinedAt: DateTime(2024, 3, 15),
  );

  static final List<PostModel> posts = allPosts.take(3).toList();

  static List<NewsModel> get allNews {
    const categories = ['Wisata', 'Infrastruktur', 'Budaya', 'Ekonomi', 'Olahraga'];
    const titles = [
      'NTB Raih Penghargaan Destinasi Wisata Terbaik 2026',
      'Pembangunan Jalan Tol Mataram-Sumbawa Dimulai',
      'Festival Bau Nyale 2026: Jadwal dan Lokasi',
      'UMKM NTB Tembus Pasar Ekspor Australia',
      'Tim Sepak Bola NTB Lolos ke National League',
      'Revitalisasi Candi Lingsar Dimulai Tahun Ini',
      'Investasi Green Energy NTB Capai Rp 2 Triliun',
      'Festival Kuliner Khas NTB Hadir di Jakarta',
    ];

    return List.generate(40, (index) {
      return NewsModel(
        id: '${index + 1}',
        title: '${titles[index % titles.length]} #${index + 1}',
        summary:
            'Berita terkini seputar NTB dan komunitas lokal. Update ke-${index + 1}.',
        category: categories[index % categories.length],
        publishedAt: DateTime.now().subtract(Duration(hours: index * 3)),
        author: 'Redaksi NTB Hub',
        sourceUrl: 'https://ntbhub.com/berita/${index + 1}',
      );
    });
  }

  static List<PostModel> get allPosts {
    const authors = [
      'NTB Hub Official',
      'Siti Nurhaliza',
      'Budi Santoso',
      'Komunitas Wisata NTB',
    ];
    const contents = [
      'Selamat datang di NTB Hub! Platform komunitas untuk warga NTB.',
      'Pemandangan sunset di Pantai Tanjung Aan memang tidak ada duanya!',
      'Event Festival Budaya Sasak tahun ini akan lebih meriah.',
      'Tips traveling hemat ke Lombok dan Sumbawa.',
    ];

    return List.generate(30, (index) {
      return PostModel(
        id: '${index + 1}',
        authorName: authors[index % authors.length],
        content: '${contents[index % contents.length]} (Post ${index + 1})',
        likes: 20 + (index * 7) % 200,
        comments: 5 + (index * 3) % 50,
        createdAt: DateTime.now().subtract(Duration(hours: index * 2)),
      );
    });
  }

  static final List<CarouselItemModel> carouselItems = [
    CarouselItemModel(
      id: '1',
      title: 'Festival Bau Nyale 2026',
      subtitle: 'Saksikan tradisi unik Lombok di Pantai Seger',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      gradientColors: [Color(0xFF1B5E4B), Color(0xFF2E8B6E)],
    ),
    CarouselItemModel(
      id: '2',
      title: 'NTB Expo & UMKM Fair',
      subtitle: 'Dukung produk lokal Nusa Tenggara Barat',
      imageUrl:
          'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
      gradientColors: [Color(0xFF0F4C75), Color(0xFF3282B8)],
    ),
    CarouselItemModel(
      id: '3',
      title: 'Wisata Pantai Tanjung Aan',
      subtitle: 'Pasir putam dan sunset terbaik di Lombok',
      imageUrl:
          'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800',
      gradientColors: [Color(0xFF2D6A4F), Color(0xFF40916C)],
    ),
    CarouselItemModel(
      id: '4',
      title: 'Booking Venue NTB Hub',
      subtitle: 'Temukan venue terbaik untuk acara Anda',
      imageUrl:
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800',
      gradientColors: [Color(0xFF6A0572), Color(0xFFAB83A1)],
    ),
  ];

  static List<VenueModel> get allVenues {
    const names = [
      'Auditorium Mataram',
      'Convention Hall Lombok',
      'Gedung Serbaguna Sumbawa',
      'Ballroom Hotel Lombok',
      'Outdoor Garden NTB Hub',
    ];
    const locations = ['Mataram', 'Lombok', 'Sumbawa', 'Lombok', 'Mataram'];
    const categories = ['Indoor', 'Indoor', 'Indoor', 'Hotel', 'Outdoor'];

    return List.generate(24, (index) {
      return VenueModel(
        id: '${index + 1}',
        name: '${names[index % names.length]} #${index + 1}',
        location: locations[index % locations.length],
        capacity: 100 + (index * 50) % 2000,
        rating: 3.5 + (index % 15) / 10,
        category: categories[index % categories.length],
        priceRange: index % 3 == 0 ? 'Rp 500rb+' : 'Rp 1jt+',
      );
    });
  }

  static List<HomeEventModel> get allHomeEvents {
    const titles = [
      'Festival Bau Nyale 2026',
      'NTB Expo & UMKM Fair',
      'Lomba Perahu Tradisional',
      'Festival Kuliner NTB',
      'Konser Musik Daerah',
    ];
    const locations = [
      'Pantai Seger, Lombok',
      'Mataram Convention Center',
      'Pantai Tanjung, Sumbawa',
      'Taman Sangkareang',
      'Auditorium Mataram',
    ];
    const categories = ['Budaya', 'Bisnis', 'Olahraga', 'Kuliner', 'Musik'];

    return List.generate(24, (index) {
      return HomeEventModel(
        id: '${index + 1}',
        title: '${titles[index % titles.length]} #${index + 1}',
        location: locations[index % locations.length],
        date: DateTime.now().add(Duration(days: index * 3 + 1)),
        attendees: 100 + (index * 37) % 1500,
        category: categories[index % categories.length],
      );
    });
  }

  static List<PublicPlaceModel> get allPublicPlaces {
    const names = [
      'Taman Sangkareang',
      'Pantai Tanjung Aan',
      'Bukit Merese',
      'Air Terjun Benang Stokel',
      'Masjid Islamic Center NTB',
      'Museum Negeri Nusa Tenggara Barat',
    ];
    const locations = [
      'Mataram',
      'Lombok Tengah',
      'Lombok Tengah',
      'Lombok Utara',
      'Mataram',
      'Mataram',
    ];
    const types = [
      'Taman',
      'Pantai',
      'Bukit',
      'Air Terjun',
      'Religi',
      'Museum',
    ];

    return List.generate(24, (index) {
      return PublicPlaceModel(
        id: '${index + 1}',
        name: '${names[index % names.length]} #${index + 1}',
        location: locations[index % locations.length],
        type: types[index % types.length],
        rating: 3.8 + (index % 12) / 10,
        isOpen: index % 4 != 0,
      );
    });
  }

  static final List<NewsModel> news = allNews.take(4).toList();

  static final List<GroupModel> groups = [
    GroupModel(
      id: '1',
      name: 'Pecinta Wisata NTB',
      description: 'Komunitas traveler dan pecinta wisata Nusa Tenggara Barat',
      memberCount: 1250,
      category: 'Wisata',
    ),
    GroupModel(
      id: '2',
      name: 'UMKM NTB Berkah',
      description: 'Wadah pelaku UMKM NTB untuk berkolaborasi dan berkembang',
      memberCount: 890,
      category: 'Bisnis',
    ),
    GroupModel(
      id: '3',
      name: 'Komunitas Tenun Sasak',
      description: 'Melestarikan dan mempromosikan tenun tradisional Sasak',
      memberCount: 456,
      category: 'Budaya',
    ),
    GroupModel(
      id: '4',
      name: 'Sepeda NTB',
      description: 'Komunitas pesepeda di seluruh NTB',
      memberCount: 678,
      category: 'Olahraga',
    ),
  ];

  static final List<ActivityModel> activities = [
    ActivityModel(
      id: '1',
      title: 'Kamu bergabung dengan Pecinta Wisata NTB',
      type: ActivityType.groupJoin,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ActivityModel(
      id: '2',
      title: 'Post kamu mendapat 10 suka baru',
      type: ActivityType.like,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    ActivityModel(
      id: '3',
      title: 'Event Festival Bau Nyale akan dimulai besok',
      type: ActivityType.event,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    ActivityModel(
      id: '4',
      title: 'Booking venue "Auditorium Mataram" dikonfirmasi',
      type: ActivityType.booking,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ActivityModel(
      id: '5',
      title: 'Budi Santoso mengomentari post kamu',
      type: ActivityType.comment,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static List<TransactionModel> get transactions {
    const titles = [
      'Booking Auditorium Mataram',
      'Booking Convention Hall Lombok',
      'Tiket Festival Bau Nyale',
      'Booking Outdoor Garden NTB Hub',
      'Tiket NTB Expo & UMKM Fair',
    ];

    return List.generate(8, (index) {
      return TransactionModel(
        id: '${index + 1}',
        title: titles[index % titles.length],
        amount: 150000 + (index * 75000),
        status: index == 2 ? 'Pending' : 'Sukses',
        date: DateTime.now().subtract(Duration(days: index * 2)),
        type: index.isEven ? 'Booking' : 'Event',
      );
    });
  }

  static List<NotificationModel> get notifications => [
    NotificationModel(
      id: '1',
      title: 'Booking Dikonfirmasi',
      body: 'Booking Auditorium Mataram #12 telah dikonfirmasi.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      type: NotificationType.booking,
    ),
    NotificationModel(
      id: '2',
      title: 'Event Baru di Sekitarmu',
      body: 'Festival Bau Nyale 2026 akan dimulai minggu depan.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.event,
    ),
    NotificationModel(
      id: '3',
      title: 'Promo NTB Hub',
      body: 'Diskon 20% booking venue untuk member komunitas.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.promo,
      isRead: true,
    ),
    NotificationModel(
      id: '4',
      title: 'Pembaruan Sistem',
      body: 'Fitur Task & Map telah tersedia di aplikasi terbaru.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.system,
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      title: 'Reminder Event',
      body: 'NTB Expo & UMKM Fair dimulai besok pukul 09:00.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.event,
      isRead: true,
    ),
  ];

  static List<TaskModel> get tasks => [
    TaskModel(
      id: '1',
      title: 'Survey Venue Auditorium',
      description: 'Lakukan survey kondisi venue sebelum event.',
      location: const LatLng(-8.5833, 116.1167),
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(hours: 4)),
      priority: 'Tinggi',
    ),
    TaskModel(
      id: '2',
      title: 'Koordinasi Event Bau Nyale',
      description: 'Hubungi panitia dan konfirmasi jadwal acara.',
      location: const LatLng(-8.8975, 116.2778),
      status: TaskStatus.pending,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: 'Sedang',
    ),
    TaskModel(
      id: '3',
      title: 'Cek Public Place Taman',
      description: 'Verifikasi fasilitas dan kebersihan area.',
      location: const LatLng(-8.5769, 116.1003),
      status: TaskStatus.pending,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: 'Rendah',
    ),
    TaskModel(
      id: '4',
      title: 'Distribusi Flyer UMKM',
      description: 'Sebarkan materi promosi UMKM di Mataram.',
      location: const LatLng(-8.5900, 116.1200),
      status: TaskStatus.completed,
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      priority: 'Sedang',
    ),
  ];

  static const int walletBalance = 245000;

  static List<FoodItemModel> get foodItems {
    const names = [
      'Ayam Taliwang Spesial',
      'Plecing Kangkung',
      'Nasi Balap Puyung',
      'Beberuk Terong',
      'Sate Rembiga',
      'Es Kelapa Muda',
    ];
    const merchants = [
      'Warung NTB Hub',
      'Kuliner Mataram',
      'UMKM Lombok',
      'Dapur Sasak',
      'Sate Pak Budi',
      'Es Teler NTB',
    ];
    const categories = ['Makanan', 'Sayur', 'Nasi', 'Sayur', 'Sate', 'Minuman'];

    return List.generate(12, (index) {
      return FoodItemModel(
        id: '${index + 1}',
        name: names[index % names.length],
        merchant: merchants[index % merchants.length],
        price: 15000 + (index * 3500),
        rating: 4.0 + (index % 10) / 10,
        category: categories[index % categories.length],
      );
    });
  }

  static List<TopUpPackageModel> get topUpPackages => const [
    TopUpPackageModel(id: '1', amount: 50000, bonus: 0, isPopular: false),
    TopUpPackageModel(id: '2', amount: 100000, bonus: 5000, isPopular: true),
    TopUpPackageModel(id: '3', amount: 200000, bonus: 15000, isPopular: false),
    TopUpPackageModel(id: '4', amount: 500000, bonus: 50000, isPopular: true),
    TopUpPackageModel(id: '5', amount: 1000000, bonus: 120000, isPopular: false),
  ];

  static List<PromoDealModel> get promoDeals => [
    PromoDealModel(
      id: '1',
      title: 'Diskon Booking Venue 20%',
      description: 'Berlaku untuk booking venue di Mataram & Lombok.',
      discountLabel: '20% OFF',
      validUntil: DateTime.now().add(const Duration(days: 7)),
      category: 'Venue',
    ),
    PromoDealModel(
      id: '2',
      title: 'Gratis Ongkir Order Food',
      description: 'Minimal order Rp 50.000 untuk wilayah Mataram.',
      discountLabel: 'FREE ONGKIR',
      validUntil: DateTime.now().add(const Duration(days: 3)),
      category: 'Kuliner',
    ),
    PromoDealModel(
      id: '3',
      title: 'Cashback Top Up 10%',
      description: 'Top up saldo minimal Rp 100.000 dapat cashback.',
      discountLabel: '10% CASHBACK',
      validUntil: DateTime.now().add(const Duration(days: 14)),
      category: 'Wallet',
    ),
    PromoDealModel(
      id: '4',
      title: 'Buy 1 Get 1 Produk UMKM',
      description: 'Produk pilihan UMKM NTB selama stok tersedia.',
      discountLabel: 'B1G1',
      validUntil: DateTime.now().add(const Duration(days: 5)),
      category: 'UMKM',
    ),
  ];

  static List<NewProductModel> get newProducts {
    const names = [
      'Tenun Songket NTB',
      'Kerupuk Kulit Sapi',
      'Madu Hutan Sumbawa',
      'Kopi Sembalun',
      'Tahu Bacem NTB',
      'Minyak Kayu Putih',
    ];
    const sellers = [
      'UMKM Songket Lombok',
      'Kerupuk Bu Siti',
      'Madu Sumbawa Asli',
      'Kopi Sembalun Co.',
      'Tahu Bu Ani',
      'Minyak NTB Organik',
    ];

    return List.generate(10, (index) {
      return NewProductModel(
        id: '${index + 1}',
        name: names[index % names.length],
        seller: sellers[index % sellers.length],
        price: 35000 + (index * 12000),
        category: index.isEven ? 'Kerajinan' : 'Kuliner',
        isNew: index < 6,
      );
    });
  }
}
