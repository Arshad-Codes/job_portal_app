import 'package:flutter/material.dart';
import 'package:job_portal_app/models/job.dart' as model;
import 'package:job_portal_app/models/job_publisher.dart';
import 'package:job_portal_app/pages/job_view.dart';
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
        backgroundColor: Color.fromRGBO(72, 143, 177, 1),
        title: Text(
          'Job List',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
            child: Container(
              child: ListView.builder(
                itemCount: displayedJobs.length,
                itemBuilder: (context, index) {
                  return _buildJobCard(displayedJobs[index]);
                },
              ),
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
    String companyDesc = jobWithPublisher['companyDesc'] ?? '';
    String email = jobWithPublisher['email'] ?? '';

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Color.fromRGBO(68, 95, 133, 1),
      child: ListTile(
        onTap: () {
          // Navigate to JobDetails page with required data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobView(
                job: job,
                companyName: companyName,
                companyLogo: companyLogo,
                companyDescription: companyDesc,
                companyEmail: email,
              ),
            ),
          );
        },
        contentPadding: EdgeInsets.all(16),
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(companyLogo),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(
                          174, 236, 245, 1), // Change the color as needed
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Company: $companyName',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(
                          174, 236, 245, 1), // Change the color as needed
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Salary: \$${job.salary.toString()}',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(
                    174, 236, 245, 1), // Change the color as needed
              ),
            ),
          ],
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
