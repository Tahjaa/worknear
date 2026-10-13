
import 'package:flutter/material.dart';
import 'package:worknear_client/worknear_client.dart';

import 'client.dart';
import 'applicants_screen.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  late Future<List<Job>> _jobs;
  bool _actionInProgress = false;

  static const List<String> _categories = [
    'Retail',
    'Café and Restaurant',
    'Tutoring',
    'Delivery',
    'Customer Service',
    'Office and Administration',
    'Technology',
    'Internship',
    'Healthcare',
    'Other',
  ];

  static const List<String> _jobTypes = [
    'Part-time',
    'Full-time',
    'Internship',
    'Contract',
    'Temporary',
  ];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _loadJobs() {
    _jobs = client.job.getMyJobs();
  }

  Future<void> _refreshJobs() async {
    setState(_loadJobs);
    await _jobs;
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    return '$day/$month/${localDate.year}';
  }

  Future<void> _editJob(Job job) async {
    if (job.id == null || !job.isActive) return;

    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: job.title);
    final descriptionController =
        TextEditingController(text: job.description);
    final salaryController =
        TextEditingController(text: job.salary ?? '');
    final experienceController =
        TextEditingController(text: job.experienceRequired ?? '');

    final categories = [..._categories];
    if (!categories.contains(job.category)) {
      categories.add(job.category);
    }

    final jobTypes = [..._jobTypes];
    if (!jobTypes.contains(job.jobType)) {
      jobTypes.add(job.jobType);
    }

    String selectedCategory = job.category;
    String selectedJobType = job.jobType;
    bool studentsAllowed = job.studentsAllowed;

    try {
      final shouldSave = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Edit Job'),
                content: SizedBox(
                  width: 480,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Job title',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Enter a job title'
                                    : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'Job description',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Enter a description'
                                    : null,
                          ),
                          const SizedBox(height: 14),
                          DropdownButtonFormField<String>(
                            initialValue: selectedCategory,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Job category',
                              border: OutlineInputBorder(),
                            ),
                            items: categories
                                .map(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setDialogState(
                                  () => selectedCategory = value,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          DropdownButtonFormField<String>(
                            initialValue: selectedJobType,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Job type',
                              border: OutlineInputBorder(),
                            ),
                            items: jobTypes
                                .map(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setDialogState(
                                  () => selectedJobType = value,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: salaryController,
                            decoration: const InputDecoration(
                              labelText: 'Salary',
                              hintText: 'e.g. ₹8,000/month',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: experienceController,
                            decoration: const InputDecoration(
                              labelText: 'Experience required',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Open to students'),
                            value: studentsAllowed,
                            onChanged: (value) {
                              setDialogState(
                                () => studentsAllowed = value,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(dialogContext, true);
                      }
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (shouldSave != true || !mounted) return;

      setState(() => _actionInProgress = true);

      final updatedJob = Job(
        id: job.id,
        companyId: job.companyId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory,
        jobType: selectedJobType,
        salary: salaryController.text.trim().isEmpty
            ? null
            : salaryController.text.trim(),
        experienceRequired:
            experienceController.text.trim().isEmpty
                ? null
                : experienceController.text.trim(),
        studentsAllowed: studentsAllowed,
        latitude: job.latitude,
        longitude: job.longitude,
        createdAt: job.createdAt,
        isActive: job.isActive,
      );

      await client.job.updateJob(updatedJob);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job updated successfully.')),
      );

      await _refreshJobs();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update job: $e')),
      );
    } finally {
      titleController.dispose();
      descriptionController.dispose();
      salaryController.dispose();
      experienceController.dispose();

      if (mounted) {
        setState(() => _actionInProgress = false);
      }
    }
  }

  Future<void> _closeJob(Job job) async {
    if (job.id == null || !job.isActive) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Close this job?'),
        content: Text(
          '“${job.title}” will no longer appear among active jobs. '
          'Existing applications will remain available.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Close Job'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _actionInProgress = true);

    try {
      await client.job.closeJob(job.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job closed successfully.')),
      );

      await _refreshJobs();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not close job: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _actionInProgress = false);
      }
    }
  }

  // Reopen a closed job after employer confirmation.
  Future<void> _reopenJob(Job job) async {
    if (job.id == null || job.isActive || _actionInProgress) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reopen this job?'),
        content: Text(
          '“${job.title}” will become active again and appear '
          'among available jobs. Existing applications and their '
          'statuses will be retained.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.refresh),
            label: const Text('Reopen Job'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _actionInProgress = true);

    try {
      await client.job.reopenJob(job.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job reopened successfully.'),
        ),
      );

      await _refreshJobs();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not reopen job: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _actionInProgress = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Job Postings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh jobs',
            onPressed: _actionInProgress ? null : _refreshJobs,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Job>>(
            future: _jobs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off_outlined,
                          size: 52,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Could not load your jobs.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _refreshJobs,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final jobs = snapshot.data ?? [];
              final activeCount =
                  jobs.where((job) => job.isActive).length;
              final closedCount = jobs.length - activeCount;

              if (jobs.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _refreshJobs,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      const SizedBox(height: 150),
                      Icon(
                        Icons.work_outline,
                        size: 70,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'No job postings yet',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Post a job to start receiving applications.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refreshJobs,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Your job listings',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _CountTag(
                          label: 'Active: $activeCount',
                          color: Colors.green,
                        ),
                        _CountTag(
                          label: 'Closed: $closedCount',
                          color: theme.colorScheme.outline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...jobs.map((job) {
                      final experience =
                          job.experienceRequired?.trim();
                      final description = job.description.trim();

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        theme.colorScheme.primaryContainer,
                                    child: Icon(
                                      Icons.work_outline,
                                      color: theme.colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          job.title,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            _JobTag(label: job.category),
                                            _JobTag(label: job.jobType),
                                            _CountTag(
                                              label: job.isActive
                                                  ? 'Active'
                                                  : 'Closed',
                                              color: job.isActive
                                                  ? Colors.green
                                                  : theme.colorScheme.outline,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Divider(
                                color: theme.colorScheme.outlineVariant,
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(
                                icon: Icons.currency_rupee,
                                label: 'Salary',
                                value: job.salary == null ||
                                        job.salary!.trim().isEmpty
                                    ? 'Not specified'
                                    : job.salary!,
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(
                                icon: Icons.school_outlined,
                                label: 'Experience',
                                value: experience == null ||
                                        experience.isEmpty
                                    ? 'Not specified'
                                    : experience,
                              ),
                              const SizedBox(height: 10),
                              _InfoRow(
                                icon: job.studentsAllowed
                                    ? Icons.check_circle_outline
                                    : Icons.block_outlined,
                                label: 'Student eligibility',
                                value: job.studentsAllowed
                                    ? 'Students can apply'
                                    : 'Students are not eligible',
                              ),
                              const SizedBox(height: 10),
                              _InfoRow(
                                icon: Icons.calendar_today_outlined,
                                label: 'Posted',
                                value: _formatDate(job.createdAt),
                              ),
                              if (description.isNotEmpty) ...[
                                const SizedBox(height: 14),
                                Text(
                                  'Description',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  description,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                              const SizedBox(height: 18),

                              // Active jobs can be edited or closed.
                              if (job.isActive) ...[
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _actionInProgress
                                        ? null
                                        : () => _editJob(job),
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text('Edit Job'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _actionInProgress
                                        ? null
                                        : () => _closeJob(job),
                                    icon: const Icon(Icons.close),
                                    label: const Text('Close Job'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          theme.colorScheme.error,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ] else ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme
                                        .surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.lock_outline, size: 20),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'This posting is closed. '
                                          'You can reopen it below.',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: _actionInProgress
                                        ? null
                                        : () => _reopenJob(job),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Reopen Job'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],

                              // Existing applicants remain accessible.
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: _actionInProgress
                                      ? null
                                      : () {
                                          if (job.id == null) return;

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ApplicantsScreen(
                                                jobId: job.id!,
                                                jobTitle: job.title,
                                              ),
                                            ),
                                          );
                                        },
                                  icon: const Icon(Icons.people_outline),
                                  label: const Text('View Applicants'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
          if (_actionInProgress)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black12,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 19,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _JobTag extends StatelessWidget {
  const _JobTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CountTag extends StatelessWidget {
  const _CountTag({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
