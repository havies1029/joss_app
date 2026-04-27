class ReviewCrudModel {
  double nilai;
  int totalReview;
  double skala;

  ReviewCrudModel({
    required this.nilai,
    required this.totalReview,
    required this.skala,
  });

  factory ReviewCrudModel.fromJson(Map<String, dynamic> data) {
    return ReviewCrudModel(
      nilai: double.tryParse(data['nilai']?.toString() ?? '') ?? 0,
      totalReview: int.tryParse(data['totalReview']?.toString() ?? '') ?? 0,
      skala: double.tryParse(data['skala']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'nilai': nilai,
    'totalReview': totalReview,
    'skala': skala,
  };
}