import 'package:flutter/material.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/resources/utils.dart';
import 'package:job_portal_app/widgets/apply_button.dart';
import 'package:job_portal_app/widgets/job_details.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
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
            child: JobDetails(
              job: job,
              companyDescription: companyDescription,
              companyName: companyName,
              companyEmail: companyEmail,
              companyLogo: companyLogo,
            ),
          ),
          ApplyButton(onPressed: () => _applyForJob(context)),
        ],
      ),
    );
  }

  _applyForJob(BuildContext context) async {
    String email = Uri.encodeComponent(companyEmail);
    String subject = Uri.encodeComponent(
      'Application for ${job.title} at $companyName',
    );
    String body = Uri.encodeComponent(
        'Dear $companyName,\n\nI am interested in the position of ${job.title} and would like to apply for the job. \n\nSincerely,\n[Your Name]');
    print(subject);
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (await launchUrl(mail)) {
      snackBarMessage(context, "opened the gmail app");
    } else {
      snackBarMessage(context, "opened the gmail app failed");
    }
  }
}
