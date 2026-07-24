import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';

class BookingStepHeader extends StatelessWidget {
  const BookingStepHeader({super.key, required this.currentStep});

  final int currentStep;

  static const steps = ['Unit', 'Jadwal', 'Total', 'Bayar'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _StepItem(
                label: steps[i],
                index: i + 1,
                isActive: currentStep >= i,
                isCurrent: currentStep == i,
              ),
            ),
            if (i < steps.length - 1)
              Container(
                width: 12,
                height: 2,
                margin: const EdgeInsets.only(bottom: 18),
                color: currentStep > i
                    ? context.primaryColor
                    : context.adaptiveDivider,
              ),
          ],
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.label,
    required this.index,
    required this.isActive,
    required this.isCurrent,
  });

  final String label;
  final int index;
  final bool isActive;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive
                ? context.primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent ? context.primaryColor : context.adaptiveDivider,
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: context.primaryColor.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(
              color: isActive ? Colors.white : context.adaptiveTextSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            color: isCurrent
                ? context.primaryColor
                : context.adaptiveTextSecondary,
          ),
        ),
      ],
    );
  }
}
