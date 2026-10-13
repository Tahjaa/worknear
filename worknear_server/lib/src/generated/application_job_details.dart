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
import 'package:serverpod/serverpod.dart' as _is;

abstract class ApplicationJobDetails
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ApplicationJobDetails._({
    this.applicationId,
    this.jobId,
    required this.title,
    required this.description,
    required this.category,
    required this.jobType,
    this.salary,
    this.experienceRequired,
    required this.studentsAllowed,
    required this.companyName,
    required this.status,
    required this.appliedAt,
  });

  factory ApplicationJobDetails({
    int? applicationId,
    int? jobId,
    required String title,
    required String description,
    required String category,
    required String jobType,
    String? salary,
    String? experienceRequired,
    required bool studentsAllowed,
    required String companyName,
    required String status,
    required DateTime appliedAt,
  }) = _ApplicationJobDetailsImpl;

  factory ApplicationJobDetails.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ApplicationJobDetails(
      applicationId: jsonSerialization['applicationId'] as int?,
      jobId: jsonSerialization['jobId'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      jobType: jsonSerialization['jobType'] as String,
      salary: jsonSerialization['salary'] as String?,
      experienceRequired: jsonSerialization['experienceRequired'] as String?,
      studentsAllowed: _is.BoolJsonExtension.fromJson(
        jsonSerialization['studentsAllowed'],
      ),
      companyName: jsonSerialization['companyName'] as String,
      status: jsonSerialization['status'] as String,
      appliedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['appliedAt'],
      ),
    );
  }

  int? applicationId;

  int? jobId;

  String title;

  String description;

  String category;

  String jobType;

  String? salary;

  String? experienceRequired;

  bool studentsAllowed;

  String companyName;

  String status;

  DateTime appliedAt;

  /// Returns a shallow copy of this [ApplicationJobDetails]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ApplicationJobDetails copyWith({
    int? applicationId,
    int? jobId,
    String? title,
    String? description,
    String? category,
    String? jobType,
    String? salary,
    String? experienceRequired,
    bool? studentsAllowed,
    String? companyName,
    String? status,
    DateTime? appliedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApplicationJobDetails',
      if (applicationId != null) 'applicationId': applicationId,
      if (jobId != null) 'jobId': jobId,
      'title': title,
      'description': description,
      'category': category,
      'jobType': jobType,
      if (salary != null) 'salary': salary,
      if (experienceRequired != null) 'experienceRequired': experienceRequired,
      'studentsAllowed': studentsAllowed,
      'companyName': companyName,
      'status': status,
      'appliedAt': appliedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApplicationJobDetails',
      if (applicationId != null) 'applicationId': applicationId,
      if (jobId != null) 'jobId': jobId,
      'title': title,
      'description': description,
      'category': category,
      'jobType': jobType,
      if (salary != null) 'salary': salary,
      if (experienceRequired != null) 'experienceRequired': experienceRequired,
      'studentsAllowed': studentsAllowed,
      'companyName': companyName,
      'status': status,
      'appliedAt': appliedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApplicationJobDetailsImpl extends ApplicationJobDetails {
  _ApplicationJobDetailsImpl({
    int? applicationId,
    int? jobId,
    required String title,
    required String description,
    required String category,
    required String jobType,
    String? salary,
    String? experienceRequired,
    required bool studentsAllowed,
    required String companyName,
    required String status,
    required DateTime appliedAt,
  }) : super._(
         applicationId: applicationId,
         jobId: jobId,
         title: title,
         description: description,
         category: category,
         jobType: jobType,
         salary: salary,
         experienceRequired: experienceRequired,
         studentsAllowed: studentsAllowed,
         companyName: companyName,
         status: status,
         appliedAt: appliedAt,
       );

  /// Returns a shallow copy of this [ApplicationJobDetails]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ApplicationJobDetails copyWith({
    Object? applicationId = _Undefined,
    Object? jobId = _Undefined,
    String? title,
    String? description,
    String? category,
    String? jobType,
    Object? salary = _Undefined,
    Object? experienceRequired = _Undefined,
    bool? studentsAllowed,
    String? companyName,
    String? status,
    DateTime? appliedAt,
  }) {
    return ApplicationJobDetails(
      applicationId: applicationId is int? ? applicationId : this.applicationId,
      jobId: jobId is int? ? jobId : this.jobId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      jobType: jobType ?? this.jobType,
      salary: salary is String? ? salary : this.salary,
      experienceRequired: experienceRequired is String?
          ? experienceRequired
          : this.experienceRequired,
      studentsAllowed: studentsAllowed ?? this.studentsAllowed,
      companyName: companyName ?? this.companyName,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }
}
