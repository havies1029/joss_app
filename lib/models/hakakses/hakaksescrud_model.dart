class HakaksesCrudModel {
  bool isAdmin;
  String excludeCOB;

  HakaksesCrudModel(
      {required this.isAdmin,
      required this.excludeCOB,
      });

  factory HakaksesCrudModel.fromJson(Map<String, dynamic> data) {
    return HakaksesCrudModel(
        isAdmin: data['is_admin'] ?? false,
        excludeCOB: data['exclude_cob'] as String,
        );
  }

  Map<String, dynamic> toJson() => {       
        'isAdmin': isAdmin,
        'excludeCOB': excludeCOB
      };
}
