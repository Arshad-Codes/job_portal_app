import 'package:flutter/material.dart';
import 'package:job_portal_app/models/job.dart';

class JobDetails extends StatelessWidget {
  final Job job;
  final String companyName;
  final String companyLogo;
  final String companyDescription;
  final String companyEmail;

  const JobDetails({
    Key? key,
    required this.job,
    required this.companyName,
    required this.companyLogo,
    required this.companyDescription,
    required this.companyEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50.0),
          CircleAvatar(
            backgroundImage: NetworkImage(companyLogo),
            radius: 36.0,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            job.title,
            style: const TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16 / 2),
          Text(
            "Salary: \$${job.salary}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 16 / 2),
          Text(
            "Company: $companyName",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 1.7 * 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16 / 2),
                Text(
                  job.description,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 2 * 16),
                const Text(
                  "About The Company",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16 / 2),
                Text(
                  companyDescription,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 200.0),
        ],
      ),
    );
  }
}
