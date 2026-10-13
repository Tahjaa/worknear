/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:worknear_server/src/generated/protocol.dart' as _i9tdibu4;

abstract class Application
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String status,
    required DateTime appliedAt,
  }) = _ApplicationImpl;

  factory Application.fromJson(Map<String, dynamic> jsonSerialization) {
    return Application(
      id: jsonSerialization['id'] as int?,
      jobId: jsonSerialization['jobId'] as int,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i9tdibu4.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      status: jsonSerialization['status'] as String,
      appliedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['appliedAt'],
      ),
    );
  }

  static final t = ApplicationTable();

  static const db = ApplicationRepository._();

  @override
  int? id;

  int jobId;

  _is.UuidValue authUserId;

  _iacs.AuthUser? authUser;

  String status;

  DateTime appliedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Application]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Application copyWith({
    int? id,
    int? jobId,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
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

  static ApplicationInclude include({_iacs.AuthUserInclude? authUser}) {
    return ApplicationInclude._(authUser: authUser);
  }

  static ApplicationIncludeList includeList({
    _is.WhereExpressionBuilder<ApplicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    ApplicationInclude? include,
  }) {
    return ApplicationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApplicationImpl extends Application {
  _ApplicationImpl({
    int? id,
    required int jobId,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
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
  @_is.useResult
  @override
  Application copyWith({
    Object? id = _Undefined,
    int? jobId,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? status,
    DateTime? appliedAt,
  }) {
    return Application(
      id: id is int? ? id : this.id,
      jobId: jobId ?? this.jobId,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }
}

class ApplicationUpdateTable extends _is.UpdateTable<ApplicationTable> {
  ApplicationUpdateTable(super.table);

  _is.ColumnValue<int, int> jobId(int value) => _is.ColumnValue(
    table.jobId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> appliedAt(DateTime value) =>
      _is.ColumnValue(
        table.appliedAt,
        value,
      );
}

class ApplicationTable extends _is.Table<int?> {
  ApplicationTable({super.tableRelation}) : super(tableName: 'application') {
    updateTable = ApplicationUpdateTable(this);
    jobId = _is.ColumnInt(
      'jobId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    appliedAt = _is.ColumnDateTime(
      'appliedAt',
      this,
    );
  }

  late final ApplicationUpdateTable updateTable;

  late final _is.ColumnInt jobId;

  late final _is.ColumnUuid authUserId;

  _iacs.AuthUserTable? _authUser;

  late final _is.ColumnString status;

  late final _is.ColumnDateTime appliedAt;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: Application.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    jobId,
    authUserId,
    status,
    appliedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class ApplicationInclude extends _is.IncludeObject {
  ApplicationInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<int?> get table => Application.t;
}

class ApplicationIncludeList extends _is.IncludeList {
  ApplicationIncludeList._({
    _is.WhereExpressionBuilder<ApplicationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Application.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Application.t;
}

class ApplicationRepository {
  const ApplicationRepository._();

  final attachRow = const ApplicationAttachRowRepository._();

  /// Returns a list of [Application]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Application>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApplicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    _is.Transaction? transaction,
    ApplicationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Application>(
      where: where?.call(Application.t),
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Application] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Application?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApplicationTable>? where,
    int? offset,
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    _is.Transaction? transaction,
    ApplicationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Application>(
      where: where?.call(Application.t),
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Application] by its [id] or null if no such row exists.
  Future<Application?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ApplicationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Application>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Application]s in the list and returns the inserted rows.
  ///
  /// The returned [Application]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Application>> insert(
    _is.DatabaseSession session,
    List<Application> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Application>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Application] and returns the inserted row.
  ///
  /// The returned [Application] will have its `id` field set.
  Future<Application> insertRow(
    _is.DatabaseSession session,
    Application row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Application>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Application]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Application]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Application>> upsert(
    _is.DatabaseSession session,
    List<Application> rows, {
    required _is.ColumnSelections<ApplicationTable> conflictColumns,
    _is.ColumnSelections<ApplicationTable>? updateColumns,
    _is.WhereExpressionBuilder<ApplicationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Application>(
      rows,
      conflictColumns: conflictColumns(Application.t),
      updateColumns: updateColumns?.call(Application.t),
      updateWhere: updateWhere?.call(Application.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Application] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Application] will have its `id` field set.
  Future<Application?> upsertRow(
    _is.DatabaseSession session,
    Application row, {
    required _is.ColumnSelections<ApplicationTable> conflictColumns,
    _is.ColumnSelections<ApplicationTable>? updateColumns,
    _is.WhereExpressionBuilder<ApplicationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Application>(
      row,
      conflictColumns: conflictColumns(Application.t),
      updateColumns: updateColumns?.call(Application.t),
      updateWhere: updateWhere?.call(Application.t),
      transaction: transaction,
    );
  }

  /// Updates all [Application]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Application>> update(
    _is.DatabaseSession session,
    List<Application> rows, {
    _is.ColumnSelections<ApplicationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Application>(
      rows,
      columns: columns?.call(Application.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Application]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Application> updateRow(
    _is.DatabaseSession session,
    Application row, {
    _is.ColumnSelections<ApplicationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Application>(
      row,
      columns: columns?.call(Application.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Application] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Application?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ApplicationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Application>(
      id,
      columnValues: columnValues(Application.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Application]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Application>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ApplicationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ApplicationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Application>(
      columnValues: columnValues(Application.t.updateTable),
      where: where(Application.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Application]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Application>> delete(
    _is.DatabaseSession session,
    List<Application> rows, {
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Application>(
      rows,
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Application].
  Future<Application> deleteRow(
    _is.DatabaseSession session,
    Application row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Application>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Application>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ApplicationTable> where,
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Application>(
      where: where(Application.t),
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApplicationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Application>(
      where: where?.call(Application.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Application] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ApplicationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Application>(
      where: where(Application.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ApplicationAttachRowRepository {
  const ApplicationAttachRowRepository._();

  /// Creates a relation between the given [Application] and [AuthUser]
  /// by setting the [Application]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    Application application,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (application.id == null) {
      throw ArgumentError.notNull('application.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $application = application.copyWith(authUserId: authUser.id);
    await session.db.updateRow<Application>(
      $application,
      columns: [Application.t.authUserId],
      transaction: transaction,
    );
  }
}
