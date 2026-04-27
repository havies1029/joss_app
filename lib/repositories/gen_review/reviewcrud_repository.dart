import 'package:joss_app/apis/gen_review/reviewcrud_api.dart';
import 'package:joss_app/models/gen_review/reviewcrud_model.dart';

class ReviewCrudRepository {

  Future<ReviewCrudModel> getReviewCrud() async {
    final api = ReviewCrudAPI();
    return await api.getReviewCrudAPI(); // tanpa param
  }
}