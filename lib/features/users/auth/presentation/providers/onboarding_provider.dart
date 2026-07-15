import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/onboarding_service.dart';

final onboardingServiceProvider = Provider<OnboardingService>(
  (ref) => OnboardingService(),
);
