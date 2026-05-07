
class NotifReadModel {
  String notifType;
  String notifId;

  NotifReadModel({required this.notifType, required this.notifId});

  factory NotifReadModel.fromJson(Map<String, dynamic> data) {
    return NotifReadModel(
        notifType: data['notifType']??'',
        notifId: data['notifId']??'',
    );

  }

  Map<String, dynamic> toJson() =>
      {'notifType': notifType,
        'notifId': notifId
      };
}
