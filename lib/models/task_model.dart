import 'package:latlong2/latlong.dart';

import '../core/helpers/json_field_helper.dart';
import 'map_place_model.dart';

enum TaskStatus { pending, inProgress, completed }

class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.dueDate,
    required this.priority,
  });

  final String id;
  final String title;
  final String description;
  final LatLng location;
  final TaskStatus status;
  final DateTime dueDate;
  final String priority;

  String get statusLabel => switch (status) {
    TaskStatus.pending => 'Pending',
    TaskStatus.inProgress => 'In Progress',
    TaskStatus.completed => 'Selesai',
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final locationMap = JsonFieldHelper.readMap(json, ['location', 'coordinates']);
    final latitude = JsonFieldHelper.readDouble(json, [
          'latitude',
          'lat',
        ]) ??
        JsonFieldHelper.readDouble(locationMap ?? const {}, ['latitude', 'lat']) ??
        MapPlaces.mataramCenter.latitude;
    final longitude = JsonFieldHelper.readDouble(json, [
          'longitude',
          'lng',
          'lon',
        ]) ??
        JsonFieldHelper.readDouble(locationMap ?? const {}, [
          'longitude',
          'lng',
          'lon',
        ]) ??
        MapPlaces.mataramCenter.longitude;

    return TaskModel(
      id: JsonFieldHelper.readString(json, ['id', '_id']) ?? '',
      title: JsonFieldHelper.readString(json, ['title', 'name', 'taskTitle']) ??
          'Task',
      description: JsonFieldHelper.readString(json, [
            'description',
            'detail',
            'notes',
            'content',
          ]) ??
          '',
      location: LatLng(latitude, longitude),
      status: _parseStatus(
        JsonFieldHelper.readString(json, ['status', 'taskStatus', 'state']),
      ),
      dueDate: JsonFieldHelper.readDateTime(json, [
            'dueDate',
            'due_date',
            'deadline',
            'endDate',
            'end_date',
          ]) ??
          DateTime.now(),
      priority: _parsePriority(
        JsonFieldHelper.readString(json, ['priority', 'priorityLevel']),
      ),
    );
  }

  static TaskStatus _parseStatus(String? raw) {
    final value = (raw ?? '').toLowerCase().replaceAll(' ', '_');
    return switch (value) {
      'in_progress' || 'inprogress' || 'ongoing' || 'active' =>
        TaskStatus.inProgress,
      'completed' || 'complete' || 'done' || 'finished' => TaskStatus.completed,
      _ => TaskStatus.pending,
    };
  }

  static String _parsePriority(String? raw) {
    final value = (raw ?? '').toUpperCase();
    return switch (value) {
      'HIGH' || 'TINGGI' || 'URGENT' => 'Tinggi',
      'LOW' || 'RENDAH' => 'Rendah',
      'MEDIUM' || 'SEDANG' || 'NORMAL' => 'Sedang',
      _ when raw != null && raw.isNotEmpty => raw,
      _ => 'Sedang',
    };
  }
}
