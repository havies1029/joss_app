abstract class PolisTanggalEvent {}

class PolisMulaiChanged extends PolisTanggalEvent {
  final DateTime mulai;
  PolisMulaiChanged(this.mulai);
}
