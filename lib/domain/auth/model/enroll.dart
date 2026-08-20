class Enroll {
  int? programId;

  Enroll({this.programId});

  factory Enroll.fromJson(Map<String, dynamic> json) => Enroll(
        programId: json['program_id'],
      );

  Map<String, dynamic> toJson() => {
        'program_id': programId,
      };
}
