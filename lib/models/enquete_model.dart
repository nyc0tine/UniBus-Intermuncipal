class EnqueteModel {
  final String userId;
  final String status;
  final DateTime data;

  EnqueteModel({
    required this.userId,
    required this.status,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'status': status,
      'data': data.toIso8601String(),
    };
  }
}
