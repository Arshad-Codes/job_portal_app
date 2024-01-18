import 'package:flutter/material.dart';
import 'package:job_portal_app/models/job.dart' as model;
import 'package:job_portal_app/models/job_publisher.dart';
import 'package:job_portal_app/pages/login_page.dart';
import 'package:job_portal_app/resources/auth.dart';
import 'package:job_portal_app/resources/job_methods.dart';
import 'package:job_portal_app/resources/job_publisher_provider.dart';
import 'package:job_portal_app/resources/utils.dart';
import 'package:provider/provider.dart';

class JobCrudPage extends StatefulWidget {
  const JobCrudPage({Key? key}) : super(key: key);

  @override
  _JobCrudPageState createState() => _JobCrudPageState();
}

class _JobCrudPageState extends State<JobCrudPage> {
  List<model.Job> jobs = [];

  @override
  void initState() {
    super.initState();
    dataReload();
  }

  dataReload() async {
    JobPublisherProvider _jobPublisherProvider =
        Provider.of(context, listen: false);
    await _jobPublisherProvider.refreshJobPublisher();

    // Fetch jobs created by the current user
    List<model.Job> userJobs = await JobMethods().getJobsCreatedByCurrentUser();

    // Update the state with the fetched jobs
    setState(() {
      jobs = userJobs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Choose a suitable color
        title: Text(
          'My Job List',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          _buildUserDetails(),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Perform sign-out action
              await Auth().signOutUser();
              // Navigate back to the login page or any other desired page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                jobs[index].title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text('Salary: \$${jobs[index].salary.toString()}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteJob(jobs[index].jobId);
                    },
                    color: Colors.red, // Choose a suitable color
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddJobDialog(context);
        },
        label: Text('Add Job'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue, // Choose a suitable color
      ),
    );
  }

  Widget _buildUserDetails() {
    final JobPublisherProvider jobPublisherProvider =
        Provider.of<JobPublisherProvider>(context);

    final JobPublisher? currentuser = jobPublisherProvider.getJobPublisher();

    return currentuser == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(currentuser.companyLogo),
                  radius: 20,
                ),
                SizedBox(width: 8.0),
                Text(
                  currentuser.companyName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
  }

  Future<void> _showAddJobDialog(BuildContext context) async {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _salaryController = TextEditingController();
    final JobPublisher? currentuser =
        Provider.of<JobPublisherProvider>(context, listen: false)
            .getJobPublisher();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Job',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _salaryController,
                  decoration: InputDecoration(labelText: 'Salary'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (currentuser == null) {
                      snackBarMessage(context, "There is no user signed in");
                    } else {
                      addJob(
                        currentuser.uid,
                        currentuser.companyName,
                        _titleController.text,
                        _descriptionController.text,
                        (double.tryParse(_salaryController.text) ?? 0.0),
                      );

                      // Reload data after adding a job
                      dataReload();
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Choose a suitable color
                  ),
                  child: Text('Add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addJob(String uid, String companyName, String title, String description,
      double salary) async {
    if (uid.isEmpty ||
        companyName.isEmpty ||
        title.isEmpty ||
        description.isEmpty) {
      snackBarMessage(context, "Please fill all the fields");
    } else {
      try {
        String response = await JobMethods()
            .postJob(uid, companyName, title, description, salary);
        if (response != "success") {
          snackBarMessage(context, response);
        } else {
          Navigator.of(context).pop();
        }
      } catch (err) {
        snackBarMessage(context, err.toString());
      }
    }
  }

  void _deleteJob(String jobId) async {
    try {
      String response = await JobMethods().deleteJob(jobId);
      if (response != "success") {
        snackBarMessage(context, response);
      } else {
        // Reload data after deleting a job
        dataReload();
      }
    } catch (err) {
      snackBarMessage(context, err.toString());
    }
  }
}
