import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/quick_action_data.dart';
import '../../../../../core/extensions/context_extensions.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Text(
            'Quick Action',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.adaptiveTextPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 52,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: QuickActionData.actions.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final action = QuickActionData.actions[index];
              return _QuickActionItem(
                action: action,
                onTap: () => context.push(action.route),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({required this.action, required this.onTap});

  final QuickActionDefinition action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cardColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(color: context.adaptiveDivider),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, color: action.color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                action.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.adaptiveTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
