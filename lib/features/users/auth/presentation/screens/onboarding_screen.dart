import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/constants/onboarding_data.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../providers/location_provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/interest_chip_grid.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  final _selectedInterests = <String>{};
  bool _isFinishing = false;

  int get _interestSlideIndex =>
      OnboardingSlides.slides.indexWhere((slide) => slide.isInterestSlide);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < OnboardingSlides.slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      return;
    }

    _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    if (_selectedInterests.isEmpty) {
      context.showSnackBar(
        'Pilih minimal 1 minat terlebih dahulu',
        isError: true,
      );
      return;
    }

    setState(() => _isFinishing = true);
    await _saveInterestsAndCompleteOnboarding(requestLocation: true);

    if (!mounted) return;
    setState(() => _isFinishing = false);
    context.go('/login');
  }

  Future<void> _skipOnboarding() async {
    final isInterestSlide =
        OnboardingSlides.slides[_currentPage].isInterestSlide;

    if (!isInterestSlide) {
      await _pageController.animateToPage(
        _interestSlideIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      return;
    }

    if (_selectedInterests.isEmpty) {
      context.showSnackBar(
        'Pilih minimal 1 minat terlebih dahulu',
        isError: true,
      );
      return;
    }

    setState(() => _isFinishing = true);
    await _saveInterestsAndCompleteOnboarding(requestLocation: false);

    if (!mounted) return;
    setState(() => _isFinishing = false);
    context.go('/login');
  }

  Future<void> _saveInterestsAndCompleteOnboarding({
    required bool requestLocation,
  }) async {
    final onboardingService = ref.read(onboardingServiceProvider);
    final locationService = ref.read(locationServiceProvider);
    final interests = _selectedInterests.toList();

    await onboardingService.saveUserInterests(interests);

    if (requestLocation) {
      final status = await locationService.requestPermission();
      await locationService.markPermissionHandled();

      if (status.isGranted || status.isLimited) {
        await ref.read(locationProvider.notifier).fetchCurrentLocation();
      }
    }

    await onboardingService.markOnboardingCompleted();
  }

  void _toggleInterest(String id) {
    setState(() {
      if (_selectedInterests.contains(id)) {
        _selectedInterests.remove(id);
      } else {
        _selectedInterests.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSlide = OnboardingSlides.slides[_currentPage];
    final isLastPage = _currentPage == OnboardingSlides.slides.length - 1;
    final isFullScreenSlide = currentSlide.isFullScreenBackground;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isFullScreenSlide
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: isFullScreenSlide
            ? Colors.black
            : Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: OnboardingSlides.slides.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final slide = OnboardingSlides.slides[index];

                if (slide.isInterestSlide) {
                  return _InterestSlide(
                    slide: slide,
                    selectedIds: _selectedInterests,
                    onToggle: _toggleInterest,
                  );
                }

                return _FullScreenPreviewSlide(slide: slide);
              },
            ),
            Positioned(
              top: 5,
              right: 5,
              child: SafeArea(
                child: TextButton(
                  onPressed: _isFinishing ? null : _skipOnboarding,
                  style: TextButton.styleFrom(
                    foregroundColor: isFullScreenSlide
                        ? Colors.white
                        : context.primaryColor,
                  ),
                  child: Row(
                    children: [
                      Text('Lewati'),
                      SizedBox(width: 8),
                      Icon(Iconsax.arrow_right_3),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _OnboardingBottomBar(
                isFullScreenSlide: isFullScreenSlide,
                isLastPage: isLastPage,
                pageController: _pageController,
                isFinishing: _isFinishing,
                onNext: _nextPage,
                onFinish: _finishOnboarding,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FullScreenPreviewSlide extends StatelessWidget {
  const _FullScreenPreviewSlide({required this.slide});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          slide.backgroundImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.35),
                Colors.black.withValues(alpha: 0.08),
                Colors.black.withValues(alpha: 0.25),
                Colors.black.withValues(alpha: 0.88),
              ],
              stops: const [0.0, 0.35, 0.55, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 168),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Icon(slide.icon, size: 28, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    slide.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    slide.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 16,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingBottomBar extends StatelessWidget {
  const _OnboardingBottomBar({
    required this.isFullScreenSlide,
    required this.isLastPage,
    required this.pageController,
    required this.isFinishing,
    required this.onNext,
    required this.onFinish,
  });

  final bool isFullScreenSlide;
  final bool isLastPage;
  final PageController pageController;
  final bool isFinishing;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottomPadding),
      decoration: BoxDecoration(
        gradient: isFullScreenSlide
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.72),
                  Colors.black.withValues(alpha: 0.92),
                ],
              )
            : null,
        color: isFullScreenSlide
            ? null
            : Theme.of(context).scaffoldBackgroundColor,
        border: isFullScreenSlide
            ? null
            : Border(top: BorderSide(color: context.adaptiveDivider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmoothPageIndicator(
            controller: pageController,
            count: OnboardingSlides.slides.length,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: isFullScreenSlide
                  ? Colors.white
                  : context.primaryColor,
              dotColor: isFullScreenSlide
                  ? Colors.white.withValues(alpha: 0.35)
                  : context.adaptiveDivider,
              expansionFactor: 3,
            ),
          ),
          const SizedBox(height: 24),
          if (isLastPage) ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isFinishing ? null : onFinish,
                icon: isFinishing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(Iconsax.location, color: Colors.white),
                label: Text(
                  isFinishing ? 'Menyiapkan...' : 'Aktifkan Lokasi & Mulai',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lokasi digunakan untuk peta, event terdekat, dan rekomendasi wisata.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isFullScreenSlide
                    ? Colors.white.withValues(alpha: 0.72)
                    : context.adaptiveTextSecondary.withValues(alpha: 0.9),
              ),
            ),
          ] else
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isFullScreenSlide ? 2 : 0,
                ),
                child: const Text(
                  'Lanjutkan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InterestSlide extends StatelessWidget {
  const _InterestSlide({
    required this.slide,
    required this.selectedIds,
    required this.onToggle,
  });

  final OnboardingSlide slide;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final selectedCount = selectedIds.length;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          slide.backgroundImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.55),
                Colors.black.withValues(alpha: 0.35),
                Colors.black.withValues(alpha: 0.72),
                Colors.black.withValues(alpha: 0.94),
              ],
              stops: const [0.0, 0.28, 0.62, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 52, 24, 196),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Icon(slide.icon, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 18),
                Text(
                  slide.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  slide.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selectedCount > 0
                        ? context.primaryColor.withValues(alpha: 0.22)
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: selectedCount > 0
                          ? context.primaryColor.withValues(alpha: 0.65)
                          : Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    selectedCount > 0
                        ? '$selectedCount minat dipilih'
                        : 'Pilih minimal 1 minat',
                    style: TextStyle(
                      color: selectedCount > 0
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.75),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Minat Saya',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: InterestChipGrid(
                      selectedIds: selectedIds,
                      onToggle: onToggle,
                      style: InterestGridStyle.enterprise,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
