import 'package:flutter/material.dart';
import 'package:worknear_client/worknear_client.dart';

import 'client.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({
    super.key,
    required this.job,
  });

  final Job job;

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool isApplying = false;
  bool hasApplied = false;

  @override
  void initState() {
    super.initState();
    _checkApplicationStatus();
  }

  Future<void> _checkApplicationStatus() async {
    if (widget.job.id == null) return;

    try {
      final applications =
          await client.application.getMyApplications();

      if (!mounted) return;

      setState(() {
        hasApplied = applications.any(
          (application) => application.jobId == widget.job.id,
        );
      });
    } catch (_) {
      // Keep the details screen usable if the status check fails.
    }
  }

  Future<void> applyForJob() async {
    if (widget.job.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This job cannot be applied to right now.'),
        ),
      );
      return;
    }

    if (isApplying || hasApplied) return;

    setState(() {
      isApplying = true;
    });

    try {
      final applications =
          await client.application.getMyApplications();

      final alreadyApplied = applications.any(
        (application) => application.jobId == widget.job.id,
      );

      if (alreadyApplied) {
        if (!mounted) return;

        setState(() {
          hasApplied = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have already applied for this job.'),
          ),
        );
        return;
      }

      await client.application.applyForJob(widget.job.id!);

      if (!mounted) return;

      setState(() {
        hasApplied = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not apply: $e'),
        ),
      );

      await _checkApplicationStatus();
    } finally {
      if (mounted) {
        setState(() {
          isApplying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final theme = Theme.of(context);
    final salary = job.salary?.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: isApplying || hasApplied
                  ? null
                  : applyForJob,
              icon: isApplying
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(
                      hasApplied
                          ? Icons.check_circle_outline
                          : Icons.send_outlined,
                    ),
              label: Text(
                isApplying
                    ? 'Checking application...'
                    : hasApplied
                        ? 'Already Applied'
                        : 'Apply for this Job',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // JOB HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor:
                      theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.work_outline,
                    size: 30,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Company #${job.companyId}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // SALARY HIGHLIGHT
            Card(
              elevation: 0,
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      size: 30,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Salary',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color:
                                  theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            salary == null || salary.isEmpty
                                ? 'Not specified'
                                : salary,
                            style:
                                theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // JOB OVERVIEW
            const _SectionTitle(title: 'Job Overview'),
            const SizedBox(height: 12),
            _DetailTile(
              icon: Icons.schedule_outlined,
              title: 'Job type',
              value: job.jobType,
            ),
            _DetailTile(
              icon: Icons.category_outlined,
              title: 'Category',
              value: job.category,
            ),
            _DetailTile(
              icon: Icons.school_outlined,
              title: 'Student eligibility',
              value: job.studentsAllowed
                  ? 'Students welcome'
                  : 'Students not allowed',
            ),
            _DetailTile(
              icon: Icons.workspace_premium_outlined,
              title: 'Experience required',
              value: job.experienceRequired?.trim().isNotEmpty == true
                  ? job.experienceRequired!
                  : 'Not specified',
            ),
            const SizedBox(height: 24),

            // DESCRIPTION
            const _SectionTitle(title: 'Job Description'),
            const SizedBox(height: 10),
            Text(
              job.description.trim().isNotEmpty
                  ? job.description
                  : 'No job description provided.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // LOCATION
            const _SectionTitle(title: 'Location'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      job.latitude != null && job.longitude != null
                          ? 'Location coordinates are available.'
                          : 'Location has not been provided.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
