import 'package:flutter/material.dart';


import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/widgets/apply_button.dart';
import 'package:job_portal_app/widgets/job_details.dart';

class JobView extends StatelessWidget {
  final Job job;
  final String companyName;
  final String companyLogo;
  final String companyDescription;
  final String companyEmail;

  const JobView({
    Key? key,
    required this.job,
    required this.companyName,
    required this.companyDescription,
    required this.companyEmail,
    required this.companyLogo,

  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 900 * 0.85,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 1.5 * 16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(3, 0),
                blurRadius: 8.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: JobDetails(job: job,
          companyDescription: companyDescription,
          companyName: companyName,
          companyEmail: companyEmail,
          companyLogo: companyLogo,),
        ),
        const ApplyButton(),
      ],
    );
  }
}
