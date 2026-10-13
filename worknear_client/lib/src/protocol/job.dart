/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class Job
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Job._({
    this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.category,
    required this.jobType,
    this.salary,
    this.experienceRequired,
    required this.studentsAllowed,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.isActive,
  });

  factory Job({
    int? id,
    required int companyId,
    required String title,
    required String description,
    required String category,
    required String jobType,
    String? salary,
    String? experienceRequired,
    required bool studentsAllowed,
    double? latitude,
    double? longitude,
    required DateTime createdAt,
    required bool isActive,
  }) = _JobImpl;

  factory Job.fromJson(Map<String, dynamic> jsonSerialization) {
    return Job(
      id: jsonSerialization['id'] as int?,
      companyId: jsonSerialization['companyId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      jobType: jsonSerialization['jobType'] as String,
      salary: jsonSerialization['salary'] as String?,
      experienceRequired: jsonSerialization['experienceRequired'] as String?,
      studentsAllowed: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['studentsAllowed'],
      ),
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int companyId;

  String title;

  String description;

  String category;

  String jobType;

  String? salary;

  String? experienceRequired;

  bool studentsAllowed;

  double? latitude;

  double? longitude;

  DateTime createdAt;

  bool isActive;

  /// Returns a shallow copy of this [Job]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Job copyWith({
    int? id,
    int? companyId,
    String? title,
    String? description,
    String? category,
    String? jobType,
    String? salary,
    String? experienceRequired,
    bool? studentsAllowed,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Job',
      if (id != null) 'id': id,
      'companyId': companyId,
      'title': title,
      'description': description,
      'category': category,
      'jobType': jobType,
      if (salary != null) 'salary': salary,
      if (experienceRequired != null) 'experienceRequired': experienceRequired,
      'studentsAllowed': studentsAllowed,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'createdAt': createdAt.toJson(),
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Job',
      if (id != null) 'id': id,
      'companyId': companyId,
      'title': title,
      'description': description,
      'category': category,
      'jobType': jobType,
      if (salary != null) 'salary': salary,
      if (experienceRequired != null) 'experienceRequired': experienceRequired,
      'studentsAllowed': studentsAllowed,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'createdAt': createdAt.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JobImpl extends Job {
  _JobImpl({
    int? id,
    required int companyId,
    required String title,
    required String description,
    required String category,
    required String jobType,
    String? salary,
    String? experienceRequired,
    required bool studentsAllowed,
    double? latitude,
    double? longitude,
    required DateTime createdAt,
    required bool isActive,
  }) : super._(
         id: id,
         companyId: companyId,
         title: title,
         description: description,
         category: category,
         jobType: jobType,
         salary: salary,
         experienceRequired: experienceRequired,
         studentsAllowed: studentsAllowed,
         latitude: latitude,
         longitude: longitude,
         createdAt: createdAt,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [Job]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Job copyWith({
    Object? id = _Undefined,
    int? companyId,
    String? title,
    String? description,
    String? category,
    String? jobType,
    Object? salary = _Undefined,
    Object? experienceRequired = _Undefined,
    bool? studentsAllowed,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Job(
      id: id is int? ? id : this.id,
      companyId: companyId ?? this.companyId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      jobType: jobType ?? this.jobType,
      salary: salary is String? ? salary : this.salary,
      experienceRequired: experienceRequired is String?
          ? experienceRequired
          : this.experienceRequired,
      studentsAllowed: studentsAllowed ?? this.studentsAllowed,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
