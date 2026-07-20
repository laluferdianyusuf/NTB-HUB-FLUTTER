import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../extensions/env.dart';
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

  String get initial =>
      displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G';
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
        'idToken': idToken,
        if (accessToken != null) 'accessToken': accessToken,
        'googleId': id,
        'email': email,
        'name': displayName,
        if (photoUrl != null) 'photoUrl': photoUrl,
      };
}

class GoogleAuthService {
  GoogleAuthService({GoogleSignIn? googleSignIn, LocalStorage? storage})
      : _googleSignIn = googleSignIn ?? _createGoogleSignIn(),
        _storage = storage ?? LocalStorage();

  static GoogleSignIn _createGoogleSignIn() {
    // Web client ID (client_type 3) from google-services.json / Firebase.
    // Android uses this as serverClientId to obtain idToken for backend verification.
    final webClientId = Env.googleClientId;

    return GoogleSignIn(
      clientId: kIsWeb ? webClientId : null,
      serverClientId: !kIsWeb ? webClientId : null,
      scopes: const ['email', 'profile'],
    );
  }

  static bool get isConfigured =>
      Env.googleClientId != null && Env.googleClientId!.isNotEmpty;

  static String? get clientIdPreview {
    final id = Env.googleClientId;
    if (id == null || id.length < 12) return id;
    return '${id.substring(0, 8)}...${id.substring(id.length - 12)}';
  }

  final GoogleSignIn _googleSignIn;
  final LocalStorage _storage;
  static const _cachedAccountsKey = 'cached_google_accounts';

  StreamSubscription<GoogleSignInAccount?>? _webUserSubscription;
  final StreamController<GoogleUserCredential> _webSignInController =
      StreamController<GoogleUserCredential>.broadcast();
  bool _webInitialized = false;

  Stream<GoogleUserCredential> get webSignInEvents =>
      _webSignInController.stream;

  GoogleSignIn get googleSignIn => _googleSignIn;

  Future<void>? _webInitFuture;

  /// Ensures GIS SDK is initialized before [renderButton] on web.
  Future<void> ensureWebInitialized() {
    if (!kIsWeb) return Future.value();
    return _webInitFuture ??= _initializeWebSignIn();
  }

  Future<void> _initializeWebSignIn() async {
    if (_webInitialized) return;
    _webInitialized = true;

    _webUserSubscription ??=
        _googleSignIn.onCurrentUserChanged.listen(_handleWebUserChanged);

    // Initialize GIS plugin without triggering an interactive sign-in flow.
    await _googleSignIn.isSignedIn();
  }

  Future<void> _handleWebUserChanged(GoogleSignInAccount? account) async {
    if (account == null) return;

    try {
      final credential = await _credentialFromAccount(account);
      _webSignInController.add(credential);
    } catch (error, stackTrace) {
      AppLogger.error('Google web sign-in failed', error, stackTrace);
    }
  }

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

      return [
        currentInfo,
        ...cached.where((a) => a.email != currentInfo.email),
      ];
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

  Future<GoogleUserCredential?> signInWithAccount(
    GoogleAccountInfo account,
  ) async {
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

    if (kIsWeb) {
      throw UnsupportedError(
        'Login Google di web harus menggunakan tombol resmi Google.',
      );
    }

    return signIn();
  }

  Future<GoogleUserCredential?> signIn() async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Login Google di web harus menggunakan tombol resmi Google.',
      );
    }

    if (!isConfigured) {
      throw StateError(
        'GOOGLE_CLIENT_ID belum diatur di .env untuk login Google.',
      );
    }

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      final credential = await _credentialFromAccount(account);
      AppLogger.info('Google sign-in success: ${account.email}');
      return credential;
    } catch (error, stackTrace) {
      if (_isUserCancellation(error)) {
        AppLogger.info('Google sign-in cancelled by user');
        return null;
      }

      AppLogger.error('Google sign-in failed', error, stackTrace);
      rethrow;
    }
  }

  Future<GoogleUserCredential> _credentialFromAccount(
    GoogleSignInAccount account,
  ) async {
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

    return credential;
  }

  bool _isUserCancellation(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('popup_closed') ||
        message.contains('cancel') ||
        message.contains('sign_in_canceled');
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

  void dispose() {
    _webUserSubscription?.cancel();
    _webSignInController.close();
  }
}
