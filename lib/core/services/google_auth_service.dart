import 'package:google_sign_in/google_sign_in.dart';

import '../logger/app_logger.dart';

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
  GoogleAuthService({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: ['email', 'profile'],
            );

  final GoogleSignIn _googleSignIn;

  Future<GoogleUserCredential?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;

      AppLogger.info('Google sign-in success: ${account.email}');

      return GoogleUserCredential(
        id: account.id,
        email: account.email,
        displayName: account.displayName ?? account.email.split('@').first,
        photoUrl: account.photoUrl,
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Google sign-in failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
