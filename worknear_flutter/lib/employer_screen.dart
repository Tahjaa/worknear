
import 'package:flutter/material.dart';
import 'package:worknear_client/worknear_client.dart';

import 'client.dart';

class EmployerScreen extends StatefulWidget {
  const EmployerScreen({super.key});

  @override
  State<EmployerScreen> createState() => _EmployerScreenState();
}

class _EmployerScreenState extends State<EmployerScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _experienceController = TextEditingController();

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

  String? _selectedCategory;
  String? _selectedJobType = 'Part-time';

  bool studentsAllowed = true;
  bool isPosting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _salaryController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> postJob() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null ||
        _selectedJobType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category and job type.'),
        ),
      );
      return;
    }

    setState(() {
      isPosting = true;
    });

    try {
      final job = await client.job.createJob(
        Job(
          companyId: 1,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory!,
          jobType: _selectedJobType!,
          salary: _salaryController.text.trim().isEmpty
              ? null
              : _salaryController.text.trim(),
          experienceRequired:
              _experienceController.text.trim().isEmpty
                  ? null
                  : _experienceController.text.trim(),
          studentsAllowed: studentsAllowed,
          latitude: 27.8974,
          longitude: 78.0880,
          createdAt: DateTime.now(),
          isActive: true,
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${job.title} posted successfully!'),
        ),
      );

      _titleController.clear();
      _descriptionController.clear();
      _salaryController.clear();
      _experienceController.clear();

      setState(() {
        _selectedCategory = null;
        _selectedJobType = 'Part-time';
        studentsAllowed = true;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not post job: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post a Job',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a Job Listing',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Find the right person for your job.',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Job title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Job title',
                  hintText: 'e.g. Café Assistant',
                  prefixIcon: Icon(Icons.work_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Job description',
                  hintText:
                      'Describe the work and responsibilities...',
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                // value: _selectedCategory,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Job category',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Job type dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedJobType,
                // value: _selectedJobType,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Job type',
                  prefixIcon: Icon(Icons.schedule_outlined),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Part-time',
                    child: Text('Part-time'),
                  ),
                  DropdownMenuItem(
                    value: 'Full-time',
                    child: Text('Full-time'),
                  ),
                  DropdownMenuItem(
                    value: 'Internship',
                    child: Text('Internship'),
                  ),
                  DropdownMenuItem(
                    value: 'Contract',
                    child: Text('Contract'),
                  ),
                  DropdownMenuItem(
                    value: 'Temporary',
                    child: Text('Temporary'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedJobType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a job type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Salary
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  labelText: 'Salary',
                  hintText: 'e.g. ₹8,000/month',
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Experience
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: 'Experience required',
                  hintText: 'e.g. No experience required',
                  prefixIcon: Icon(Icons.school_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              // Students allowed
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Open to students',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Allow students to apply for this job',
                ),
                value: studentsAllowed,
                onChanged: (value) {
                  setState(() {
                    studentsAllowed = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Post button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isPosting ? null : postJob,
                  icon: isPosting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.add_business),
                  label: Text(
                    isPosting ? 'Posting...' : 'Post Job',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
