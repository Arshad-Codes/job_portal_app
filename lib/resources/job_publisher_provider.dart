import 'package:flutter/material.dart';
import 'package:job_portal_app/models/job_publisher.dart';
import 'package:job_portal_app/resources/auth.dart';

class JobPublisherProvider with ChangeNotifier {
  JobPublisher? _jobPublisher;
  final _auth = Auth();
  
  JobPublisher? getJobPublisher() {
    return _jobPublisher;
  }

  Future<void> refreshJobPublisher() async {
    JobPublisher jobPublisher = await _auth.getJobPublisherDetails();
    _jobPublisher = jobPublisher;
    notifyListeners();

  }
}
