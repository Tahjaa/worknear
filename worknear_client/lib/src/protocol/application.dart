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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:worknear_client/src/protocol/protocol.dart' as _i3sgrwir;

abstract class Application
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Application._({
    this.id,
    required this.jobId,
    required this.authUserId,
    this.authUser,
    required this.status,
    required this.appliedAt,
  });

  factory Application({
    int? id,
    required int jobId,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String status,
    required DateTime appliedAt,
  }) = _ApplicationImpl;

  factory Application.fromJson(Map<String, dynamic> jsonSerialization) {
    return Application(
      id: jsonSerialization['id'] as int?,
      jobId: jsonSerialization['jobId'] as int,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i3sgrwir.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      status: jsonSerialization['status'] as String,
      appliedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['appliedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int jobId;

  _isc.UuidValue authUserId;

  _iacc.AuthUser? authUser;

  String status;

  DateTime appliedAt;

  /// Returns a shallow copy of this [Application]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Application copyWith({
    int? id,
    int? jobId,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    String? status,
    DateTime? appliedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Application',
      if (id != null) 'id': id,
      'jobId': jobId,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'status': status,
      'appliedAt': appliedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Application',
      if (id != null) 'id': id,
      'jobId': jobId,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'status': status,
      'appliedAt': appliedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApplicationImpl extends Application {
  _ApplicationImpl({
    int? id,
    required int jobId,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String status,
    required DateTime appliedAt,
  }) : super._(
         id: id,
         jobId: jobId,
         authUserId: authUserId,
         authUser: authUser,
         status: status,
         appliedAt: appliedAt,
       );

  /// Returns a shallow copy of this [Application]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Application copyWith({
    Object? id = _Undefined,
    int? jobId,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? status,
    DateTime? appliedAt,
  }) {
    return Application(
      id: id is int? ? id : this.id,
      jobId: jobId ?? this.jobId,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }
}
