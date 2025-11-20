class DownloadFileInfo64Model {
  String? datafile64;
  String? tipefile;
  String? ukuran;
  String? namafile;
  String? mimetype;

  DownloadFileInfo64Model(
      {this.datafile64,
      this.tipefile,
      this.mimetype,
      this.namafile,
      this.ukuran});

  factory DownloadFileInfo64Model.fromJson(Map<String, dynamic> data) {
    return DownloadFileInfo64Model(
      datafile64: data['datafile64'],
      tipefile: data['tipefile'],
      ukuran: data['ukuran'],
      namafile: data['namafile'],
      mimetype: data['mimetype'],
    );
  }

  Map<String, dynamic> toJson() =>
		{'datafile64': datafile64,
		'tipefile': tipefile,
		'ukuran': ukuran,
		'namafile': namafile,
		'mimetype': mimetype,};

}
