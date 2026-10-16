class Regrenew1FormModel {
  final bool isUbah;
  final String notePerubahan;
  final String polis1Id;
  final String regrenew1Id;

  // Alias transisi untuk halaman yang belum dipindahkan ke ID baru.
  String get sppa1Id => regrenew1Id.isNotEmpty ? regrenew1Id : polis1Id;

  Regrenew1FormModel({
    required this.isUbah,
    required this.notePerubahan,
    String? polis1Id,
    String? sppa1Id,
    this.regrenew1Id = '',
  }) : polis1Id = polis1Id ?? sppa1Id ?? '';

  factory Regrenew1FormModel.fromJson(Map<String, dynamic> data) {
    return Regrenew1FormModel(
      isUbah: data['isUbah'] ?? false,
      notePerubahan: data['notePerubahan'] ?? '',
      polis1Id: (data['polis1Id'] ?? data['sppa1Id'] ?? '').toString(),
      regrenew1Id: data['regrenew1Id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'isUbah': isUbah,
        'notePerubahan': notePerubahan,
        'polis1Id': polis1Id,
        'regrenew1Id': regrenew1Id,
      };

  Regrenew1FormModel copyWith({
    bool? isUbah,
    String? notePerubahan,
    String? polis1Id,
    String? sppa1Id,
    String? regrenew1Id,
  }) {
    return Regrenew1FormModel(
      isUbah: isUbah ?? this.isUbah,
      notePerubahan: notePerubahan ?? this.notePerubahan,
      polis1Id: polis1Id ?? sppa1Id ?? this.polis1Id,
      regrenew1Id: regrenew1Id ?? this.regrenew1Id,
    );
  }
}
