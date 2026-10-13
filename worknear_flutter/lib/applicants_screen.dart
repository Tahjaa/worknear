
import 'package:flutter/material.dart';
import 'package:worknear_client/worknear_client.dart';

import 'client.dart';

class ApplicantsScreen extends StatefulWidget {
  const ApplicantsScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  final int jobId;
  final String jobTitle;

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  late Future<List<Application>> _applications;

  final Set<int> _updatingApplicationIds = {};

  static const List<String> _statuses = [
    'All',
    'Applied',
    'Shortlisted',
    'Rejected',
    'Hired',
  ];

  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  void _loadApplications() {
    _applications = client.application.getApplicantsForJob(
      widget.jobId,
    );
  }

  Future<void> _refreshApplications() async {
    setState(() {
      _loadApplications();
    });

    await _applications;
  }

  Future<void> _changeStatus(
    Application application,
    String status,
  ) async {
    final applicationId = application.id;

    if (applicationId == null ||
        _updatingApplicationIds.contains(applicationId)) {
      return;
    }

    setState(() {
      _updatingApplicationIds.add(applicationId);
    });

    try {
      await client.application.updateApplicationStatus(
        applicationId,
        status,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Application marked as $status.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update application: $e'),
        ),
      );
    } finally {
      if (mounted) {
        try {
          await _refreshApplications();
        } catch (_) {
          // FutureBuilder displays the refresh error.
        }

        if (mounted) {
          setState(() {
            _updatingApplicationIds.remove(applicationId);
          });
        }
      }
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Shortlisted':
        return Colors.orange;
      case 'Hired':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Applied':
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }

  int _countForStatus(
    List<Application> applications,
    String status,
  ) {
    if (status == 'All') {
      return applications.length;
    }

    return applications
        .where((application) => application.status == status)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Applicants',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh applicants',
            onPressed: _refreshApplications,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Application>>(
        future: _applications,
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
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Could not load applicants:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _refreshApplications,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final applications = snapshot.data ?? [];

          final filteredApplications = _selectedStatus == 'All'
              ? applications
              : applications
                  .where(
                    (application) =>
                        application.status == _selectedStatus,
                  )
                  .toList();

          return RefreshIndicator(
            onRefresh: _refreshApplications,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  widget.jobTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${applications.length} applicant'
                  '${applications.length == 1 ? '' : 's'} in total',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),

                // Status filter heading.
                const Text(
                  'Filter applicants',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Horizontally scrollable status filters.
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _statuses.map((status) {
                      final isSelected = _selectedStatus == status;
                      final count = _countForStatus(
                        applications,
                        status,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          showCheckmark: false,
                          label: Text('$status ($count)'),
                          selectedColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          onSelected: (_) {
                            setState(() {
                              _selectedStatus = status;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  _selectedStatus == 'All'
                      ? 'All applicants'
                      : '$_selectedStatus applicants',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                if (filteredApplications.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 48,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          applications.isEmpty
                              ? Icons.people_outline
                              : Icons.filter_list_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          applications.isEmpty
                              ? 'No applicants yet.'
                              : 'No $_selectedStatus applicants.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          applications.isEmpty
                              ? 'Applications for this job will appear here.'
                              : 'Try another status filter to see candidates.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (_selectedStatus != 'All') ...[
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedStatus = 'All';
                              });
                            },
                            child: const Text('Show all applicants'),
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  ...filteredApplications.map((application) {
                    final status = application.status;
                    final applicationId = application.id;

                    final isUpdating = applicationId != null &&
                        _updatingApplicationIds.contains(
                          applicationId,
                        );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  child: Icon(Icons.person_outline),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Job Applicant',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Application #$applicationId',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _statusColor(status)
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: _statusColor(status),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Applied on '
                              '${application.appliedAt.toLocal().day}/'
                              '${application.appliedAt.toLocal().month}/'
                              '${application.appliedAt.toLocal().year}',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              initialValue: status,
                              decoration: InputDecoration(
                                labelText: isUpdating
                                    ? 'Saving status...'
                                    : 'Application status',
                                border: const OutlineInputBorder(),
                                suffixIcon: isUpdating
                                    ? const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Applied',
                                  child: Text('Applied'),
                                ),
                                DropdownMenuItem(
                                  value: 'Shortlisted',
                                  child: Text('Shortlisted'),
                                ),
                                DropdownMenuItem(
                                  value: 'Rejected',
                                  child: Text('Rejected'),
                                ),
                                DropdownMenuItem(
                                  value: 'Hired',
                                  child: Text('Hired'),
                                ),
                              ],
                              onChanged: isUpdating
                                  ? null
                                  : (value) {
                                      if (value == null ||
                                          value == status) {
                                        return;
                                      }

                                      _changeStatus(
                                        application,
                                        value,
                                      );
                                    },
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
    );
  }
}
