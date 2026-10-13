
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

class JobEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // Find the company belonging to the logged-in employer.
  Future<Company?> _getMyCompany(Session session) async {
    final authUserId = session.authenticated?.authUserId;

    if (authUserId == null) {
      throw Exception('You must be logged in.');
    }

    final companies = await Company.db.find(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      limit: 1,
    );

    return companies.isEmpty ? null : companies.first;
  }

  // Get only active jobs for the applicant Home screen.
  Future<List<Job>> getJobs(Session session) async {
    return await Job.db.find(
      session,
      where: (t) => t.isActive.equals(true),
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  // Create a job for the logged-in employer.
  Future<Job> createJob(Session session, Job job) async {
    final company = await _getMyCompany(session);

    if (company == null || company.id == null) {
      throw Exception(
        'Your employer company could not be found. '
        'Please set up your company profile first.',
      );
    }

    // Always associate the job with the logged-in employer's company.
    job.companyId = company.id!;

    return await Job.db.insertRow(session, job);
  }

  // Get all jobs (active and closed) for the logged-in employer.
  Future<List<Job>> getMyJobs(Session session) async {
    final company = await _getMyCompany(session);

    if (company == null || company.id == null) {
      return [];
    }

    return await Job.db.find(
      session,
      where: (t) => t.companyId.equals(company.id!),
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  // Edit an active job owned by the logged-in employer.
  Future<Job> updateJob(Session session, Job updatedJob) async {
    final company = await _getMyCompany(session);

    if (company == null || company.id == null) {
      throw Exception('Your employer company could not be found.');
    }

    final jobId = updatedJob.id;

    if (jobId == null) {
      throw Exception('A valid job ID is required.');
    }

    final existingJob = await Job.db.findById(session, jobId);

    if (existingJob == null ||
        existingJob.companyId != company.id) {
      throw Exception(
        'Job not found or you do not own this job.',
      );
    }

    if (!existingJob.isActive) {
      throw Exception('Closed jobs cannot be edited.');
    }

    // Preserve the original company and posting date.
    updatedJob.companyId = existingJob.companyId;
    updatedJob.createdAt = existingJob.createdAt;

    return await Job.db.updateRow(session, updatedJob);
  }

  // Close a job without deleting its existing applications.
  Future<Job> closeJob(Session session, int jobId) async {
    final company = await _getMyCompany(session);

    if (company == null || company.id == null) {
      throw Exception('Your employer company could not be found.');
    }

    final job = await Job.db.findById(session, jobId);

    if (job == null || job.companyId != company.id) {
      throw Exception(
        'Job not found or you do not own this job.',
      );
    }

    if (!job.isActive) {
      return job;
    }

    job.isActive = false;

    return await Job.db.updateRow(session, job);
  }

  // Reopen a closed job owned by the logged-in employer.
  Future<Job> reopenJob(Session session, int jobId) async {
    final company = await _getMyCompany(session);

    if (company == null || company.id == null) {
      throw Exception('Your employer company could not be found.');
    }

    final job = await Job.db.findById(session, jobId);

    if (job == null || job.companyId != company.id) {
      throw Exception(
        'Job not found or you do not own this job.',
      );
    }

    // If already active, return it without changing anything.
    if (job.isActive) {
      return job;
    }

    // Reactivate the existing posting.
    job.isActive = true;

    return await Job.db.updateRow(session, job);
  }

  // Get job and company details for the logged-in applicant's applications.
  Future<List<ApplicationJobDetails>> getMyApplicationJobDetails(
    Session session,
  ) async {
    final authUserId = session.authenticated?.authUserId;

    if (authUserId == null) {
      throw Exception('You must be logged in.');
    }

    final applications = await Application.db.find(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      orderBy: (t) => t.appliedAt.desc(),
    );

    final results = <ApplicationJobDetails>[];

    for (final application in applications) {
      final job = await Job.db.findById(
        session,
        application.jobId,
      );

      if (job == null) {
        continue;
      }

      final company = await Company.db.findById(
        session,
        job.companyId,
      );

      final companyName =
          company != null && company.name.trim().isNotEmpty
              ? company.name
              : 'Company name unavailable';

      results.add(
        ApplicationJobDetails(
          applicationId: application.id,
          jobId: job.id,
          title: job.title,
          description: job.description,
          category: job.category,
          jobType: job.jobType,
          salary: job.salary,
          experienceRequired: job.experienceRequired,
          studentsAllowed: job.studentsAllowed,
          companyName: companyName,
          status: application.status,
          appliedAt: application.appliedAt,
        ),
      );
    }

    return results;
  }
}
