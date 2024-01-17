import 'package:cloud_firestore/cloud_firestore.dart';

class JobPublisher {
  final String uid;
  final String companyName;
  final String companyDesc;
  final String email;
  final String companyLogo;
  final List jobs;

  JobPublisher({
    required this.uid,
    required this.companyName,
    required this.companyDesc,
    required this.email,
    required this.companyLogo,
    required this.jobs,
  });

  static JobPublisher fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return JobPublisher(
      companyName: snapshot["companyName"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      companyLogo: snapshot["companyLogo"],
      companyDesc: snapshot["companyDesc"],
      jobs: snapshot["jobs"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "companyName": companyName,
      "companyDesc": companyDesc,
      "email": email,
      "companyLogo": companyLogo,
      "jobs": jobs,
    };
  }
}
