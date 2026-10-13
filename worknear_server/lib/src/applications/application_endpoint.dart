
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

class ApplicationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // ------------------------------------------------------------
  // JOB SEEKER: APPLY FOR A JOB
  // ------------------------------------------------------------

  Future<Application> applyForJob(
    Session session,
    int jobId,
  ) async {
    final authUserId = session.authenticated?.authUserId;

    if (authUserId == null) {
      throw Exception(
        'You must be logged in to apply for a job.',
      );
    }

    final job = await Job.db.findById(
      session,
      jobId,
    );

    if (job == null) {
      throw Exception('Job not found.');
    }

    // Prevent applications to closed or inactive jobs.
    if (!job.isActive) {
      throw Exception(
        'This job is no longer accepting applications.',
      );
    }

    // Prevent duplicate applications.
    final existingApplications = await Application.db.find(
      session,
      where: (t) =>
          t.jobId.equals(jobId) &
          t.authUserId.equals(authUserId),
      limit: 1,
    );

    if (existingApplications.isNotEmpty) {
      throw Exception(
        'You have already applied for this job.',
      );
    }

    final application = Application(
      jobId: jobId,
      authUserId: authUserId,
      status: 'Applied',
      appliedAt: DateTime.now(),
    );

    return await Application.db.insertRow(
      session,
      application,
    );
  }

  // ------------------------------------------------------------
  // JOB SEEKER: MY APPLICATIONS
  // ------------------------------------------------------------

  Future<List<Application>> getMyApplications(
    Session session,
  ) async {
    final authUserId = session.authenticated?.authUserId;

    if (authUserId == null) {
      throw Exception(
        'You must be logged in.',
      );
    }

    return await Application.db.find(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      orderBy: (t) => t.appliedAt.desc(),
    );
  }

  // ------------------------------------------------------------
  // EMPLOYER: CHECK JOB OWNERSHIP
  // ------------------------------------------------------------

  Future<Job> _getEmployerJob(
    Session session,
    int jobId,
  ) async {
    final authUserId = session.authenticated?.authUserId;

    if (authUserId == null) {
      throw Exception(
        'You must be logged in.',
      );
    }

    final job = await Job.db.findById(
      session,
      jobId,
    );

    if (job == null) {
      throw Exception(
        'Job not found.',
      );
    }

    final companies = await Company.db.find(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      limit: 1,
    );

    if (companies.isEmpty) {
      throw Exception(
        'You do not have a company profile.',
      );
    }

    final company = companies.first;

    if (job.companyId != company.id) {
      throw Exception(
        'You do not have permission to manage this job.',
      );
    }

    return job;
  }

  // ------------------------------------------------------------
  // EMPLOYER: GET APPLICANTS FOR A JOB
  // ------------------------------------------------------------

  Future<List<Application>> getApplicantsForJob(
    Session session,
    int jobId,
  ) async {
    await _getEmployerJob(
      session,
      jobId,
    );

    return await Application.db.find(
      session,
      where: (t) => t.jobId.equals(jobId),
      orderBy: (t) => t.appliedAt.desc(),
    );
  }

  // ------------------------------------------------------------
  // EMPLOYER: UPDATE APPLICATION STATUS
  // ------------------------------------------------------------

  Future<Application> updateApplicationStatus(
    Session session,
    int applicationId,
    String status,
  ) async {
    const allowedStatuses = [
      'Applied',
      'Shortlisted',
      'Rejected',
      'Hired',
    ];

    if (!allowedStatuses.contains(status)) {
      throw Exception(
        'Invalid application status.',
      );
    }

    final application = await Application.db.findById(
      session,
      applicationId,
    );

    if (application == null) {
      throw Exception(
        'Application not found.',
      );
    }

    // Ensure the employer owns the associated job.
    await _getEmployerJob(
      session,
      application.jobId,
    );

    application.status = status;

    return await Application.db.updateRow(
      session,
      application,
    );
  }
}