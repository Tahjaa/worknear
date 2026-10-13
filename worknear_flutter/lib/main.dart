import 'package:flutter/material.dart';
import 'package:worknear_client/worknear_client.dart';

import 'client.dart';
import 'employer_screen.dart';
import 'job_details_screen.dart';
import 'login_screen.dart';
import 'my_applications_screen.dart';
import 'my_jobs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const WorkNearApp());
}

class WorkNearApp extends StatelessWidget {
  const WorkNearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WorkNear',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// HOME SCREEN

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final GlobalKey<_JobListState> _jobListKey =
      GlobalKey<_JobListState>();

  Future<void> _openEmployerScreen(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );

    if (!mounted) return;
    _jobListKey.currentState?.refreshJobs();
  }

  void onNavigationTap(int index) {
    if (index == 1) {
      _showEmployerMenu();
      return;
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MyApplicationsScreen(),
        ),
      );
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  void _showEmployerMenu() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Employer',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.add_business),
                  ),
                  title: const Text(
                    'Post a Job',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Create a new job listing'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openEmployerScreen(const EmployerScreen());
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.work_outline),
                  ),
                  title: const Text(
                    'My Jobs',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Manage jobs and view applicants',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openEmployerScreen(const MyJobsScreen());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WorkNear',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _jobListKey.currentState?.refreshJobs();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh jobs',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find work.',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Find it nearby.',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your location',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
            const SizedBox(height: 16),
            JobList(key: _jobListKey),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onNavigationTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_business_outlined),
            selectedIcon: Icon(Icons.add_business),
            label: 'Employer',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// JOB LIST, SEARCH AND FILTERS

class JobList extends StatefulWidget {
  const JobList({super.key});

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  late Future<List<Job>> _jobs;

  final TextEditingController _searchController =
      TextEditingController();

  String _selectedType = 'All';
  String _selectedCategory = 'All categories';
  int _minimumSalary = 0;

  final List<String> _categories = const [
    'All categories',
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

  final Map<String, int> _salaryOptions = const {
    'Any salary': 0,
    '₹5,000+': 5000,
    '₹8,000+': 8000,
    '₹10,000+': 10000,
    '₹15,000+': 15000,
    '₹20,000+': 20000,
  };

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadJobs() {
    _jobs = client.job.getJobs();
  }

  Future<void> refreshJobs() async {
    setState(_loadJobs);
    await _jobs;
  }

  String _normalizeType(String value) {
    return value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[_\s]+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
  }

  bool _matchesType(Job job) {
    final type = _normalizeType(job.jobType);

    if (_selectedType == 'Full-time') {
      return type.contains('full-time') || type == 'fulltime';
    }

    if (_selectedType == 'Part-time') {
      return type.contains('part-time') || type == 'parttime';
    }

    return true;
  }

  bool _matchesCategory(Job job) {
    if (_selectedCategory == 'All categories') {
      return true;
    }

    return job.category.trim().toLowerCase() ==
        _selectedCategory.trim().toLowerCase();
  }

  int? _salaryAmount(Job job) {
    final salary = job.salary;
    if (salary == null || salary.trim().isEmpty) {
      return null;
    }

    // Read the first numeric amount, supporting values such as
    // "₹8,000", "8000 per month", or "₹8,000 - ₹10,000".
    final match = RegExp(r'\d[\d,]*').firstMatch(salary);

    if (match == null) {
      return null;
    }

    return int.tryParse(match.group(0)!.replaceAll(',', ''));
  }

  bool _matchesSalary(Job job) {
    if (_minimumSalary == 0) {
      return true;
    }

    final amount = _salaryAmount(job);

    // Exclude jobs without a readable salary when a minimum is selected.
    return amount != null && amount >= _minimumSalary;
  }

  void _clearFilters() {
    _searchController.clear();

    setState(() {
      _selectedType = 'All';
      _selectedCategory = 'All categories';
      _minimumSalary = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Search jobs, companies...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear search',
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // JOB TYPE FILTER
        Wrap(
          spacing: 8,
          children: ['All', 'Full-time', 'Part-time'].map((type) {
            return ChoiceChip(
              label: Text(type),
              selected: _selectedType == type,
              onSelected: (_) {
                setState(() => _selectedType = type);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),

        // CATEGORY FILTER
        DropdownButtonFormField<String>(
          initialValue: _selectedCategory,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Job category',
            prefixIcon: const Icon(Icons.category_outlined),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedCategory = value);
          },
        ),
        const SizedBox(height: 12),

        // MINIMUM SALARY FILTER
        DropdownButtonFormField<int>(
          initialValue: _minimumSalary,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Minimum salary',
            prefixIcon: const Icon(Icons.currency_rupee),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: _salaryOptions.entries.map((option) {
            return DropdownMenuItem<int>(
              value: option.value,
              child: Text(option.key),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _minimumSalary = value);
          },
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Nearby Jobs',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('Clear filters'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        FutureBuilder<List<Job>>(
          future: _jobs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Could not load jobs:\n${snapshot.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: refreshJobs,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              );
            }

            final allJobs = snapshot.data ?? [];
            final query = _searchController.text.trim().toLowerCase();

            final jobs = allJobs.where((job) {
              final matchesSearch =
                  query.isEmpty ||
                  job.title.toLowerCase().contains(query) ||
                  'company ${job.companyId}'.contains(query) ||
                  job.companyId.toString() == query;

              return matchesSearch &&
                  _matchesType(job) &&
                  _matchesCategory(job) &&
                  _matchesSalary(job);
            }).toList();

            if (jobs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 44,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    const Text('No matching jobs found.'),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _clearFilters,
                      child: const Text('Clear search and filters'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: refreshJobs,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ),
                ...jobs.map((job) => _JobCard(job: job)),
              ],
            );
          },
        ),
      ],
    );
  }
}

// JOB CARD


class _JobCard extends StatelessWidget {
  const _JobCard({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final experience = job.experienceRequired?.trim();
    final salary = job.salary?.trim();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 0.7,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobDetailsScreen(job: job),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // JOB TITLE AND ICON
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.work_outline,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Company #${job.companyId}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // CATEGORY AND JOB TYPE
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _JobTag(
                    icon: Icons.category_outlined,
                    label: job.category,
                  ),
                  _JobTag(
                    icon: Icons.schedule_outlined,
                    label: job.jobType,
                  ),
                ],
              ),

              const SizedBox(height: 14),
              Divider(color: theme.colorScheme.outlineVariant),
              const SizedBox(height: 10),

              // SALARY
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.currency_rupee,
                    size: 21,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      salary == null || salary.isEmpty
                          ? 'Salary not specified'
                          : salary,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // EXPERIENCE
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.workspace_premium_outlined,
                    size: 19,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Experience: ${experience == null || experience.isEmpty ? 'Not specified' : experience}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // STUDENT ELIGIBILITY
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    job.studentsAllowed
                        ? Icons.school_outlined
                        : Icons.info_outline,
                    size: 19,
                    color: job.studentsAllowed
                        ? Colors.green.shade700
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      job.studentsAllowed
                          ? 'Students can apply'
                          : 'Students are not eligible',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // LOCATION STATUS
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 19,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      job.latitude != null && job.longitude != null
                          ? 'Location coordinates available'
                          : 'Location not provided',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(
                    'View details',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JobTag extends StatelessWidget {
  const _JobTag({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// class _JobCard extends StatelessWidget {
//   const _JobCard({required this.job});

//   final Job job;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 1,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => JobDetailsScreen(job: job),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const CircleAvatar(
//                 radius: 25,
//                 child: Icon(Icons.work_outline),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       job.title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Company #${job.companyId}',
//                       style: TextStyle(color: Colors.grey.shade700),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.location_on_outlined,
//                           size: 16,
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             job.latitude != null &&
//                                     job.longitude != null
//                                 ? 'Location available'
//                                 : 'Location not provided',
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.currency_rupee,
//                           size: 16,
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             job.salary ?? 'Salary not specified',
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${job.category} • ${job.jobType}',
//                       style: TextStyle(
//                         color: Colors.grey.shade700,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.chevron_right),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }