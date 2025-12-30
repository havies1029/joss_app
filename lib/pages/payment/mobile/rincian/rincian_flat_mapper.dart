import '../../../../models/payment/dndetailsppa_model.dart';
import '../../../../models/payment/dnheadercob_model.dart';

class RincianFlatItem {
  final String dn1Id;
  final String cobId;
  final String cobNama;
  final String noPolis;
  final String objectDesc;
  final String currSimbol;
  final double dnOs;
  final DateTime polisMulai;
  final DateTime polisAkhir;

  RincianFlatItem.fromDetail(
      DnHeaderCobModel header,
      DnDetailSppaModel d,
      ) :
        dn1Id = d.dn1Id,
        cobId = header.cobId,
        cobNama = header.cobNama,
        noPolis = d.noPolis,
        objectDesc = d.objectDesc,
        currSimbol = d.currSimbol,
        dnOs = d.dnOs,
        polisMulai = d.polisMulai,
        polisAkhir = d.polisAkhir;
}
