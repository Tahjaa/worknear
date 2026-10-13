/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:worknear_client/src/protocol/application.dart' as _ihrth50s;
import 'package:worknear_client/src/protocol/application_job_details.dart'
    as _i0uxu3fe;
import 'package:worknear_client/src/protocol/job.dart' as _i4sust17;
import 'application.dart' as _ice4s91e;
import 'application_job_details.dart' as _i5sg0f1u;
import 'company.dart' as _i6pnc270;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'job.dart' as _iozmmds3;
export 'application.dart';
export 'application_job_details.dart';
export 'company.dart';
export 'greetings/greeting.dart';
export 'job.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ice4s91e.Application) {
      return _ice4s91e.Application.fromJson(data) as T;
    }
    if (t == _i5sg0f1u.ApplicationJobDetails) {
      return _i5sg0f1u.ApplicationJobDetails.fromJson(data) as T;
    }
    if (t == _i6pnc270.Company) {
      return _i6pnc270.Company.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _iozmmds3.Job) {
      return _iozmmds3.Job.fromJson(data) as T;
    }
    if (t == _isc.getType<_ice4s91e.Application?>()) {
      return (data != null ? _ice4s91e.Application.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5sg0f1u.ApplicationJobDetails?>()) {
      return (data != null
              ? _i5sg0f1u.ApplicationJobDetails.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i6pnc270.Company?>()) {
      return (data != null ? _i6pnc270.Company.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iozmmds3.Job?>()) {
      return (data != null ? _iozmmds3.Job.fromJson(data) : null) as T;
    }
    if (t == List<_ihrth50s.Application>) {
      return (data as List)
              .map((e) => deserialize<_ihrth50s.Application>(e))
              .toList()
          as T;
    }
    if (t == List<_i4sust17.Job>) {
      return (data as List).map((e) => deserialize<_i4sust17.Job>(e)).toList()
          as T;
    }
    if (t == List<_i0uxu3fe.ApplicationJobDetails>) {
      return (data as List)
              .map((e) => deserialize<_i0uxu3fe.ApplicationJobDetails>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ice4s91e.Application => 'Application',
      _i5sg0f1u.ApplicationJobDetails => 'ApplicationJobDetails',
      _i6pnc270.Company => 'Company',
      _izw8z7ou.Greeting => 'Greeting',
      _iozmmds3.Job => 'Job',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('worknear.', '');
    }

    switch (data) {
      case _ice4s91e.Application():
        return 'Application';
      case _i5sg0f1u.ApplicationJobDetails():
        return 'ApplicationJobDetails';
      case _i6pnc270.Company():
        return 'Company';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _iozmmds3.Job():
        return 'Job';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Application') {
      return deserialize<_ice4s91e.Application>(data['data']);
    }
    if (dataClassName == 'ApplicationJobDetails') {
      return deserialize<_i5sg0f1u.ApplicationJobDetails>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i6pnc270.Company>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'Job') {
      return deserialize<_iozmmds3.Job>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('worknear', this);
    _iacc.Protocol().registerHostProtocol('worknear', this);
  }

  @override
  String getModuleName() => 'worknear';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
