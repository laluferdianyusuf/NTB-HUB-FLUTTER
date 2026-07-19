import 'package:google_sign_in/google_sign_in.dart';

import '../logger/app_logger.dart';
import '../storage/local_storage.dart';

class GoogleAccountInfo {
  const GoogleAccountInfo({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  String get initial => displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G';
}

class GoogleUserCredential {
  const GoogleUserCredential({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.idToken,
    this.accessToken,
  });

  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? idToken;
  final String? accessToken;

  Map<String, dynamic> toBackendPayload() => {
    'id_token': idToken,
    'access_token': accessToken,
    'google_id': id,
    'email': email,
    'name': displayName,
    'photo_url': photoUrl,
  };
}

class GoogleAuthService {
  GoogleAuthService({GoogleSignIn? googleSignIn, LocalStorage? storage})
      : _googleSignIn = googleSignIn ??
            GoogleSignIn(scopes: ['email', 'profile']),
        _storage = storage ?? LocalStorage();

  final GoogleSignIn _googleSignIn;
  final LocalStorage _storage;
  static const _cachedAccountsKey = 'cached_google_accounts';

  Future<List<GoogleAccountInfo>> getAvailableAccounts() async {
    final cached = await _loadCachedAccounts();
    final current = _googleSignIn.currentUser;

    if (current != null) {
      final currentInfo = GoogleAccountInfo(
        id: current.id,
        email: current.email,
        displayName: current.displayName ?? current.email.split('@').first,
        photoUrl: current.photoUrl,
      );

      final merged = [
        currentInfo,
        ...cached.where((a) => a.email != currentInfo.email),
      ];
      return merged;
    }

    if (cached.isNotEmpty) return cached;

    return const [
      GoogleAccountInfo(
        id: 'demo_1',
        email: 'ahmad.rizki@gmail.com',
        displayName: 'Ahmad Rizki',
      ),
      GoogleAccountInfo(
        id: 'demo_2',
        email: 'siti.nurhaliza@gmail.com',
        displayName: 'Siti Nurhaliza',
      ),
    ];
  }

  Future<GoogleUserCredential?> signInWithAccountPicker() async {
    return signIn();
  }

  Future<GoogleUserCredential?> signInWithAccount(GoogleAccountInfo account) async {
    if (account.id.startsWith('demo_')) {
      return GoogleUserCredential(
        id: account.id,
        email: account.email,
        displayName: account.displayName,
        photoUrl: account.photoUrl,
        idToken: 'demo_id_token_${account.id}',
        accessToken: 'demo_access_token_${account.id}',
      );
    }

    return signIn();
  }

  Future<GoogleUserCredential?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;
      final credential = GoogleUserCredential(
        id: account.id,
        email: account.email,
        displayName: account.displayName ?? account.email.split('@').first,
        photoUrl: account.photoUrl,
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );

      await _cacheAccount(
        GoogleAccountInfo(
          id: credential.id,
          email: credential.email,
          displayName: credential.displayName,
          photoUrl: credential.photoUrl,
        ),
      );

      AppLogger.info('Google sign-in success: ${account.email}');
      return credential;
    } catch (e, stackTrace) {
      AppLogger.error('Google sign-in failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> _cacheAccount(GoogleAccountInfo account) async {
    final cached = await _loadCachedAccounts();
    final updated = [
      account,
      ...cached.where((a) => a.email != account.email),
    ].take(5).toList();

    await _storage.save(
      _cachedAccountsKey,
      updated
          .map(
            (a) => {
              'id': a.id,
              'email': a.email,
              'displayName': a.displayName,
              'photoUrl': a.photoUrl,
            },
          )
          .toList(),
    );
  }

  Future<List<GoogleAccountInfo>> _loadCachedAccounts() async {
    final raw = await _storage.read<List<dynamic>>(_cachedAccountsKey);
    if (raw == null) return [];

    return raw.map((item) {
      final map = item as Map<String, dynamic>;
      return GoogleAccountInfo(
        id: map['id'] as String,
        email: map['email'] as String,
        displayName: map['displayName'] as String,
        photoUrl: map['photoUrl'] as String?,
      );
    }).toList();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
