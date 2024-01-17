import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_portal_app/models/job.dart' as model;
import 'package:uuid/uuid.dart';

class JobMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> postJob(String uid, String companyName, String title,
      String description, double salary) async {
    String response;
    try {
      String jobId = const Uuid().v1(); 
      model.Job job = model.Job(
        jobId: jobId,
        description: description,
        uid: uid,
        companyName: companyName,
        title: title,
        salary: salary,
      );
      //save in jobs collection
      await _firestore.collection('jobs').doc(job.jobId).set(job.toJson());

      // update jobpublisher jobs list
      await _firestore
          .collection('jobPublisher')
          .doc(uid)
          .update({'jobs': FieldValue.arrayUnion([jobId])});
      response = "success";
    } catch (e) {
      response = "An unexpected error occurred during sign-up";
    }
    return response;
  }

  Future<List<model.Job>> getJobsCreatedByCurrentUser() async {
    List<model.Job> userJobs = [];

    try {
      final currentUserUid = _auth.currentUser?.uid;

      if (currentUserUid != null) {
        // Query 'jobs' collection for jobs created by the current user
        QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('jobs')
            .where('uid', isEqualTo: currentUserUid)
            .get();

        // Convert each document to a Job object and add it to the list
        userJobs = snapshot.docs.map((doc) {
          return model.Job.fromJson(doc.data());
        }).toList();
      }
    } catch (e) {
      // Handle errors as needed
      print('Error fetching user jobs: $e');
    }

    return userJobs;
  }

 Future<String> deleteJob(String jobId) async {
  String res = "Something went wrong";
    try {
      await _firestore.collection('jobs').doc(jobId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
 }
}
