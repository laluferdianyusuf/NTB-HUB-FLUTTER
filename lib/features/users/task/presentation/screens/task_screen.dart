import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/map_place_model.dart';
import '../../../../../models/task_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/location_provider.dart';
import '../providers/task_provider.dart';
class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  TaskModel? _selectedTask;

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authProvider);
    final userLocation = ref.watch(locationProvider);
    final latLng = userLocation == null
        ? null
        : LatLng(userLocation.latitude, userLocation.longitude);

    final isLoggedIn = authAsync.maybeWhen(
      data: (user) => user != null,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Task'),
        actions: [
          if (isLoggedIn)
            IconButton(
              onPressed: () => ref.invalidate(tasksProvider),
              icon: const Icon(Iconsax.refresh),
            ),
        ],
      ),
      body: isLoggedIn
          ? _LoggedInTaskContent(
              selectedTask: _selectedTask,
              userLocation: latLng,
              onTaskTap: (task) => setState(() => _selectedTask = task),
            )
          : _TaskBody(
              tasks: const [],
              selectedTask: null,
              userLocation: latLng,
              onTaskTap: (_) {},
              requiresLogin: true,
            ),
    );
  }
}

class _LoggedInTaskContent extends ConsumerWidget {
  const _LoggedInTaskContent({
    required this.selectedTask,
    required this.userLocation,
    required this.onTaskTap,
  });

  final TaskModel? selectedTask;
  final LatLng? userLocation;
  final ValueChanged<TaskModel> onTaskTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return tasksAsync.when(
      loading: () => _TaskBody(
        tasks: const [],
        selectedTask: selectedTask,
        userLocation: userLocation,
        onTaskTap: onTaskTap,
        isLoading: true,
      ),
      error: (error, _) => _TaskBody(
        tasks: const [],
        selectedTask: selectedTask,
        userLocation: userLocation,
        onTaskTap: onTaskTap,
        errorMessage: error.toString(),
        onRetry: () => ref.invalidate(tasksProvider),
      ),
      data: (resultValue) => switch (resultValue) {
        result.Success(:final data) => _TaskBody(
          tasks: data,
          selectedTask: selectedTask,
          userLocation: userLocation,
          onTaskTap: onTaskTap,
        ),
        result.Error(:final failure) => _TaskBody(
          tasks: const [],
          selectedTask: selectedTask,
          userLocation: userLocation,
          onTaskTap: onTaskTap,
          errorMessage: failure.message,
          onRetry: () => ref.invalidate(tasksProvider),
        ),
      },
    );
  }
}
class _TaskBody extends StatelessWidget {
  const _TaskBody({
    required this.tasks,
    required this.selectedTask,
    required this.userLocation,
    required this.onTaskTap,
    this.requiresLogin = false,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  final List<TaskModel> tasks;
  final TaskModel? selectedTask;
  final LatLng? userLocation;
  final ValueChanged<TaskModel> onTaskTap;
  final bool requiresLogin;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _TaskMap(
          tasks: requiresLogin ? const [] : tasks,
          selectedTask: selectedTask,
          userLocation: userLocation,
          onTaskTap: onTaskTap,
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.38,
          minChildSize: 0.12,
          maxChildSize: 0.82,
          snap: true,
          snapSizes: const [0.12, 0.38, 0.82],
          builder: (context, scrollController) {
            return _TaskSheet(
              scrollController: scrollController,
              tasks: tasks,
              selectedTask: selectedTask,
              onTaskTap: onTaskTap,
              requiresLogin: requiresLogin,
              isLoading: isLoading,
              errorMessage: errorMessage,
              onRetry: onRetry,
            );
          },
        ),
      ],
    );
  }
}
class _TaskMap extends StatelessWidget {
  const _TaskMap({
    required this.tasks,
    required this.selectedTask,
    required this.userLocation,
    required this.onTaskTap,
  });

  final List<TaskModel> tasks;
  final TaskModel? selectedTask;
  final LatLng? userLocation;
  final ValueChanged<TaskModel> onTaskTap;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: MapPlaces.mataramCenter,
        initialZoom: 10,
        interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.ntbhub.flutter',
        ),
        MarkerLayer(
          markers: [
            ...tasks.map((task) {
              final isSelected = selectedTask?.id == task.id;
              return Marker(
                point: task.location,
                width: isSelected ? 52 : 42,
                height: isSelected ? 52 : 42,
                child: GestureDetector(
                  onTap: () => onTaskTap(task),
                  child: _TaskMarker(task: task, isSelected: isSelected),
                ),
              );
            }),
            if (userLocation != null)
              Marker(
                point: userLocation!,
                width: 44,
                height: 44,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _TaskMarker extends StatelessWidget {
  const _TaskMarker({required this.task, required this.isSelected});

  final TaskModel task;
  final bool isSelected;

  Color get _color => switch (task.status) {
    TaskStatus.pending => AppColors.secondary,
    TaskStatus.inProgress => AppColors.primary,
    TaskStatus.completed => AppColors.success,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.white : Colors.transparent,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: isSelected ? 8 : 4,
          ),
        ],
      ),
      child: Icon(
        Iconsax.task_square,
        color: Colors.white,
        size: isSelected ? 22 : 18,
      ),
    );
  }
}

class _TaskSheet extends StatelessWidget {
  const _TaskSheet({
    required this.scrollController,
    required this.tasks,
    required this.selectedTask,
    required this.onTaskTap,
    this.requiresLogin = false,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  final ScrollController scrollController;
  final List<TaskModel> tasks;
  final TaskModel? selectedTask;
  final ValueChanged<TaskModel> onTaskTap;
  final bool requiresLogin;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Daftar Task',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                if (!requiresLogin)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${tasks.length} task',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _TaskSheetContent(
              scrollController: scrollController,
              tasks: tasks,
              selectedTask: selectedTask,
              onTaskTap: onTaskTap,
              requiresLogin: requiresLogin,
              isLoading: isLoading,
              errorMessage: errorMessage,
              onRetry: onRetry,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskSheetContent extends StatelessWidget {
  const _TaskSheetContent({
    required this.scrollController,
    required this.tasks,
    required this.selectedTask,
    required this.onTaskTap,
    required this.requiresLogin,
    required this.isLoading,
    this.errorMessage,
    this.onRetry,
  });

  final ScrollController scrollController;
  final List<TaskModel> tasks;
  final TaskModel? selectedTask;
  final ValueChanged<TaskModel> onTaskTap;
  final bool requiresLogin;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (requiresLogin) {
      return ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          const Icon(
            Iconsax.lock,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Login untuk melihat task',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Masuk ke akun Anda untuk melihat dan mengelola daftar task.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/login'),
              child: const Text('Masuk Sekarang'),
            ),
          ),
        ],
      );
    }

    if (isLoading) {
      return ListView(
        controller: scrollController,
        children: const [
          SizedBox(height: 48),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (errorMessage != null) {
      return ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Text(errorMessage!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: onRetry,
              child: const Text('Coba Lagi'),
            ),
          ),
        ],
      );
    }

    if (tasks.isEmpty) {
      return ListView(
        controller: scrollController,
        children: const [
          SizedBox(height: 48),
          Center(child: Text('Belum ada task')),
        ],
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: tasks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _TaskListTile(
          task: task,
          isSelected: selectedTask?.id == task.id,
          onTap: () => onTaskTap(task),
        );
      },
    );
  }
}
class _TaskListTile extends StatelessWidget {
  const _TaskListTile({
    required this.task,
    required this.isSelected,
    required this.onTap,
  });

  final TaskModel task;
  final bool isSelected;
  final VoidCallback onTap;

  Color get _statusColor => switch (task.status) {
    TaskStatus.pending => AppColors.secondary,
    TaskStatus.inProgress => AppColors.primary,
    TaskStatus.completed => AppColors.success,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.divider,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.statusLabel,
                        style: TextStyle(
                          color: _statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Iconsax.clock, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatter.formatDate(task.dueDate),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Prioritas ${task.priority}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
