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

abstract class Company
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Company._({
    this.id,
    this.authUserId,
    this.authUser,
    required this.name,
    this.description,
    this.category,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory Company({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    required String name,
    String? description,
    String? category,
    String? address,
    double? latitude,
    double? longitude,
  }) = _CompanyImpl;

  factory Company.fromJson(Map<String, dynamic> jsonSerialization) {
    return Company(
      id: jsonSerialization['id'] as int?,
      authUserId: jsonSerialization['authUserId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['authUserId'],
            ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i3sgrwir.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      category: jsonSerialization['category'] as String?,
      address: jsonSerialization['address'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue? authUserId;

  _iacc.AuthUser? authUser;

  String name;

  String? description;

  String? category;

  String? address;

  double? latitude;

  double? longitude;

  /// Returns a shallow copy of this [Company]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Company copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    String? name,
    String? description,
    String? category,
    String? address,
    double? latitude,
    double? longitude,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Company',
      if (id != null) 'id': id,
      if (authUserId != null) 'authUserId': authUserId?.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Company',
      if (id != null) 'id': id,
      if (authUserId != null) 'authUserId': authUserId?.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CompanyImpl extends Company {
  _CompanyImpl({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    required String name,
    String? description,
    String? category,
    String? address,
    double? latitude,
    double? longitude,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         name: name,
         description: description,
         category: category,
         address: address,
         latitude: latitude,
         longitude: longitude,
       );

  /// Returns a shallow copy of this [Company]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Company copyWith({
    Object? id = _Undefined,
    Object? authUserId = _Undefined,
    Object? authUser = _Undefined,
    String? name,
    Object? description = _Undefined,
    Object? category = _Undefined,
    Object? address = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
  }) {
    return Company(
      id: id is int? ? id : this.id,
      authUserId: authUserId is _isc.UuidValue? ? authUserId : this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      category: category is String? ? category : this.category,
      address: address is String? ? address : this.address,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
    );
  }
}
