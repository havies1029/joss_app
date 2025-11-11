import 'package:joss_app/blocs/reusable_connection_flow/reusable_connection_flow_state.dart';
import 'package:joss_app/blocs/reusable_connection_flow/base_connection_flow.dart';

class CalmvConnectionFlow extends BaseConnectionFlow<ReusableConnectionFlowState> {
  CalmvConnectionFlow() : super(const ReusableConnectionFlowState());

  @override
  ReusableConnectionFlowState createInitialState() =>
      const ReusableConnectionFlowState();

  void markForm1Valid(bool value) {
    emit(state.copyWith(isForm1Valid: value));
  }

  void markForm1Saving() {
    emit(state.copyWith(isForm1Saving: true, isForm1Saved: false));
  }

  void markForm1Saved(String id) {
    emit(state.copyWith(
      isForm1Saving: false,
      isForm1Saved: true,
      isForm1Valid: true,
      activeId: id,
    ));
  }

  void onForm2Completed(List<String> premi) {
    moveTo("form3", data: premi);
  }
}
