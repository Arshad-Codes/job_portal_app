class Job {
  final String jobId;
  final String title;
  final String description;
  final double salary;
  final String uid; // id of user who created this job
  final String companyName;
  Job({
    required this.jobId,
    required this.title,
    required this.description,
    required this.salary,
    required this.uid,
    required this.companyName,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobId':jobId,
      'title': title,
      'description': description,
      'salary': salary,
      'uid': uid,
      'companyName':companyName
    };
  }

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobId: json['jobId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      salary:
          (json['salary'] as num).toDouble(), 
      uid: json['uid'] as String,
      companyName: json['companyName'] as String,
    );
  }
}
