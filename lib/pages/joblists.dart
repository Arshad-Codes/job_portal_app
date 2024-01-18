import 'package:flutter/material.dart';
import 'package:job_portal_app/models/job.dart' as model;
import 'package:job_portal_app/models/job_publisher.dart';
import 'package:job_portal_app/pages/login_page.dart';
import 'package:job_portal_app/resources/auth.dart';
import 'package:job_portal_app/resources/job_methods.dart';
import 'package:job_portal_app/resources/job_publisher_provider.dart';
import 'package:job_portal_app/resources/utils.dart';
import 'package:provider/provider.dart';

class JobList extends StatefulWidget {
  const JobList({Key? key}) : super(key: key);

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  List<Map<String, dynamic>> allJobs = [];
  List<Map<String, dynamic>> displayedJobs = [];

  @override
  void initState() {
    super.initState();
    dataReload();
  }

  dataReload() async {
       // Fetch all jobs
    List<Map<String, dynamic>> fetchedJobs =
        await JobMethods().getAllJobsWithPublishers();

    setState(() {
      allJobs = fetchedJobs;
      displayedJobs = List.from(allJobs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Job List',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                labelText: 'Search Jobs',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedJobs.length,
              itemBuilder: (context, index) {
                return _buildJobCard(displayedJobs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }



Widget _buildJobCard(Map<String, dynamic> jobWithPublisher) {
    model.Job job = model.Job.fromJson(jobWithPublisher['job']);
    String companyName = jobWithPublisher['companyName'] ?? 'N/A';
    String companyLogo = jobWithPublisher['companyLogo'] ?? '';

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          job.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text('Salary: \$${job.salary.toString()}'),
            SizedBox(height: 8),
            Text('Company: $companyName'),
          ],
        ),
        trailing: CircleAvatar(
          radius: 30,
          backgroundImage:NetworkImage(companyLogo),
        ),
      ),
    );
  }


  void onSearchTextChanged(String query) {
    setState(() {
      displayedJobs = allJobs
          .where((jobWithPublisher) => jobWithPublisher['job']['title']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }
}
