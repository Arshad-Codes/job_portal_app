import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_portal_app/models/job.dart' as model;
import 'package:job_portal_app/models/job_publisher.dart';
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
        
        QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('jobs')
            .where('uid', isEqualTo: currentUserUid)
            .get();

        
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
      await _firestore.collection('jobPublisher').doc(_auth.currentUser!.uid).update({
        'jobs': FieldValue.arrayRemove([jobId])
      });

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
 }

  Future<List<model.Job>> getAllJobs() async {
    List<model.Job> allJobs = [];

    try {
     
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('jobs').get();

      allJobs = snapshot.docs.map((doc) {
        return model.Job.fromJson(doc.data());
      }).toList();
    } catch (e) {

      print('Error fetching all jobs: $e');
    }

    return allJobs;
  }

  Future<List<Map<String, dynamic>>> getAllJobsWithPublishers() async {
    List<Map<String, dynamic>> jobsWithPublishers = [];

    try {
      // Fetch all jobs
      QuerySnapshot<Map<String, dynamic>> jobsSnapshot =
          await _firestore.collection('jobs').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> jobDoc in jobsSnapshot.docs) {
        model.Job job = model.Job.fromJson(jobDoc.data()!);

        // Fetch job publisher details using job's uid
        DocumentSnapshot<Map<String, dynamic>> publisherSnapshot =
            await _firestore.collection('jobPublisher').doc(job.uid).get();

        if (publisherSnapshot.exists) {
          // Create a map to hold job and publisher information
          Map<String, dynamic> jobWithPublisher = {
            'job': job.toJson(),
            'companyName': publisherSnapshot.data()!['companyName'],
            'companyLogo': publisherSnapshot.data()!['companyLogo'],
            'companyDesc': publisherSnapshot.data()!['companyDesc'],
            'email': publisherSnapshot.data()!['email'],
          };

          jobsWithPublishers.add(jobWithPublisher);
        }
      }
    } catch (e) {
  
      print('Error fetching jobs with publishers: $e');
    }

    return jobsWithPublishers;
  }
}



