import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/services/theme_settings_service.dart';
import '../../../../../core/theme/theme_provider.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(appThemeProvider);

    return AppPageScaffold(
      title: 'Tema Aplikasi',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _SectionHeader(
            title: 'Mode Tampilan',
            subtitle: 'Pilih tampilan terang, gelap, atau ikuti sistem.',
          ),
          const SizedBox(height: 12),
          _ThemeModeSelector(
            selected: themeState.preference,
            onChanged: (value) {
              ref.read(appThemeProvider.notifier).setThemePreference(value);
              context.showSnackBar('Mode tampilan diperbarui');
            },
          ),
          const SizedBox(height: 28),
          _SectionHeader(
            title: 'Warna Aksen',
            subtitle: 'Sesuaikan warna utama aplikasi.',
          ),
          const SizedBox(height: 12),
          ...AppAccent.values.map(
            (accent) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AccentOptionCard(
                accent: accent,
                isSelected: themeState.accent == accent,
                onTap: () {
                  ref.read(appThemeProvider.notifier).setAccent(accent);
                  context.showSnackBar(
                    'Aksen ${AppColors.accentLabel(accent)} diterapkan',
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          _ThemePreviewCard(accent: themeState.accent),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: context.adaptiveTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: context.adaptiveTextSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({required this.selected, required this.onChanged});

  final AppThemePreference selected;
  final ValueChanged<AppThemePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ThemeModeCard(
            icon: Iconsax.sun_1,
            label: 'Terang',
            isSelected: selected == AppThemePreference.light,
            onTap: () => onChanged(AppThemePreference.light),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ThemeModeCard(
            icon: Iconsax.moon,
            label: 'Gelap',
            isSelected: selected == AppThemePreference.dark,
            onTap: () => onChanged(AppThemePreference.dark),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ThemeModeCard(
            icon: Iconsax.mobile,
            label: 'Sistem',
            isSelected: selected == AppThemePreference.system,
            onTap: () => onChanged(AppThemePreference.system),
          ),
        ),
      ],
    );
  }
}

class _ThemeModeCard extends StatelessWidget {
  const _ThemeModeCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Material(
      color: isSelected
          ? primary.withValues(alpha: 0.1)
          : context.adaptiveSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isSelected ? primary : context.adaptiveDivider,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? primary : context.adaptiveTextSecondary,
                size: 22,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? context.adaptiveTextPrimary
                      : context.adaptiveTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccentOptionCard extends StatelessWidget {
  const _AccentOptionCard({
    required this.accent,
    required this.isSelected,
    required this.onTap,
  });

  final AppAccent accent;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.accentColor(accent);
    final previewColors = AppColors.accentPreviewColors(accent);

    return Material(
      color: context.adaptiveSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? accentColor : context.adaptiveDivider,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _AccentSwatchGroup(colors: previewColors),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppColors.accentLabel(accent),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: context.adaptiveTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _accentDescription(accent),
                      style: TextStyle(
                        fontSize: 12,
                        color: context.adaptiveTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Iconsax.tick_circle, color: accentColor, size: 22)
              else
                Icon(
                  Iconsax.arrow_right_3,
                  color: context.adaptiveTextSecondary,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _accentDescription(AppAccent accent) => switch (accent) {
    AppAccent.mint => 'Hijau segar — warna utama NTB Hub',
    AppAccent.ocean => 'Biru laut — tenang dan profesional',
    AppAccent.violet => 'Ungu modern — bold dan kreatif',
  };
}

class _AccentSwatchGroup extends StatelessWidget {
  const _AccentSwatchGroup({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 28,
      child: Stack(
        children: [
          for (var i = 0; i < colors.length; i++)
            Positioned(
              left: i * 14.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: colors[i],
                  shape: BoxShape.circle,
                  border: Border.all(color: context.adaptiveSurface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  const _ThemePreviewCard({required this.accent});

  final AppAccent accent;

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.accentColor(accent);
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.adaptiveSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.adaptiveDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pratinjau',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.adaptiveTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.adaptiveDivider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 10,
                  decoration: BoxDecoration(
                    color: context.adaptiveTextPrimary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 180,
                  height: 8,
                  decoration: BoxDecoration(
                    color: context.adaptiveTextSecondary.withValues(
                      alpha: 0.45,
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Tombol',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: context.adaptiveDivider),
                      ),
                      child: Text(
                        'Outline',
                        style: TextStyle(
                          color: context.adaptiveTextPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
