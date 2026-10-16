class Regendors1FormModel {
  String notePerubahan;
  String regendors1Id;
  final String polis1Id;

  // Alias transisi untuk halaman yang belum dipindahkan ke ID baru.
  String get sppa1Id => regendors1Id.isNotEmpty ? regendors1Id : polis1Id;

  Regendors1FormModel({
    required this.notePerubahan,
    this.regendors1Id = '',
    String? polis1Id,
    String? sppa1Id,
  }) : polis1Id = polis1Id ?? sppa1Id ?? '';

  Regendors1FormModel copyWith({
    String? notePerubahan,
    String? regendors1Id,
    String? polis1Id,
    String? sppa1Id,
  }) {
    return Regendors1FormModel(
      notePerubahan: notePerubahan ?? this.notePerubahan,
      regendors1Id: regendors1Id ?? this.regendors1Id,
      polis1Id: polis1Id ?? sppa1Id ?? this.polis1Id,
    );
  }

  factory Regendors1FormModel.fromJson(Map<String, dynamic> data) {
    return Regendors1FormModel(
      notePerubahan: data['notePerubahan'] ?? '',
      regendors1Id: data['regendors1Id'] ?? '',
      polis1Id: (data['polis1Id'] ?? data['sppa1Id'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'notePerubahan': notePerubahan,
        'regendors1Id': regendors1Id,
        'polis1Id': polis1Id,
      };
}
