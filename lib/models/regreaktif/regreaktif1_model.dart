class Regreaktif1Model {
  final bool isUbah;
  final String notePerubahan;
  final String polis1Id;
  final String regreaktif1Id;

  // Alias transisi untuk halaman yang belum dipindahkan ke ID baru.
  String get sppa1Id => regreaktif1Id.isNotEmpty ? regreaktif1Id : polis1Id;

  Regreaktif1Model({
    required this.isUbah,
    required this.notePerubahan,
    String? polis1Id,
    String? sppa1Id,
    this.regreaktif1Id = '',
  }) : polis1Id = polis1Id ?? sppa1Id ?? '';

  factory Regreaktif1Model.fromJson(Map<String, dynamic> data) {
    return Regreaktif1Model(
      isUbah: data['isUbah'] ?? false,
      notePerubahan: data['notePerubahan'] ?? '',
      polis1Id: (data['polis1Id'] ?? data['sppa1Id'] ?? '').toString(),
      regreaktif1Id: data['regreaktif1Id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'isUbah': isUbah,
        'notePerubahan': notePerubahan,
        'polis1Id': polis1Id,
        'regreaktif1Id': regreaktif1Id,
      };

  Regreaktif1Model copyWith({
    bool? isUbah,
    String? notePerubahan,
    String? polis1Id,
    String? sppa1Id,
    String? regreaktif1Id,
  }) {
    return Regreaktif1Model(
      isUbah: isUbah ?? this.isUbah,
      notePerubahan: notePerubahan ?? this.notePerubahan,
      polis1Id: polis1Id ?? sppa1Id ?? this.polis1Id,
      regreaktif1Id: regreaktif1Id ?? this.regreaktif1Id,
    );
  }
}
