import 'dart:convert';
import 'dart:typed_data';

class DownloadFileInfoModel {
  Uint8List? datafile;
  String? tipefile;
  String? ukuran;
  String? namafile;
  String? mimetype;

  DownloadFileInfoModel(
      {this.datafile,
      this.tipefile,
      this.mimetype,
      this.namafile,
      this.ukuran});

  factory DownloadFileInfoModel.fromJson(Map<String, dynamic> data) {
    return DownloadFileInfoModel(
      datafile: data['datafile'] != null ? Uint8List.fromList(utf8.encode(data['datafile'].toString())):null,
      tipefile: data['tipefile'],
      ukuran: data['ukuran'],
      namafile: data['namafile'],
      mimetype: data['mimetype'],
    );
  }

  Map<String, dynamic> toJson() =>
		{'datafile': datafile,
		'tipefile': tipefile,
		'ukuran': ukuran,
		'namafile': namafile,
		'mimetype': mimetype,};

}
