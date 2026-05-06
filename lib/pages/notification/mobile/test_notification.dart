import 'dart:async';
import 'package:flutter/foundation.dart';

class NotifModel {
  final String eventDesc;
  final String eventNama;
  final String notifeventId;
  final String notifType;
  bool isRead;

  NotifModel({
    required this.eventDesc,
    required this.eventNama,
    required this.notifeventId,
    required this.notifType,
    this.isRead = false,
  });
}

class NotifDummyHelper {
  static final ValueNotifier<int> unreadNotifier = ValueNotifier<int>(0);

  static final List<NotifModel> _items = List.generate(12, (index) {
    final number = index + 1;

    return NotifModel(
      eventDesc: number % 2 == 0
          ? 'Perbaharui aplikasi Anda untuk mendapatkan performa dan keamanan yang lebih baik. Notifikasi nomor $number.'
          : 'Dapatkan promo dan informasi terbaru untuk produk asuransi pilihan Anda. Notifikasi nomor $number.',
      eventNama: number % 2 == 0
          ? 'Update aplikasi versi 1.$number tersedia'
          : 'Promo spesial untuk Anda #$number',
      notifeventId: number.toString().padLeft(5, '0'),
      notifType: number % 3 == 0 ? 'REMINDER' : 'EVENT',
      isRead: false,
    );
  });

  static void _refreshUnreadCount() {
    unreadNotifier.value = _items.where((e) => !e.isRead).length;
  }

  static Future<void> init() async {
    _refreshUnreadCount();
  }

  static Future<List<NotifModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _refreshUnreadCount();
    return _items;
  }

  static Future<int> getUnreadCount() async {
    await Future.delayed(const Duration(milliseconds: 150));
    _refreshUnreadCount();
    return unreadNotifier.value;
  }

  static Future<void> markAsRead({
    required String notifType,
    required String notifId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final index = _items.indexWhere(
          (e) => e.notifType == notifType && e.notifeventId == notifId,
    );

    if (index != -1) {
      _items[index].isRead = true;
      _refreshUnreadCount();
    }
  }

  static Future<void> markManyAsRead(List<NotifModel> items) async {
    await Future.delayed(const Duration(milliseconds: 150));

    for (final item in items) {
      final index = _items.indexWhere(
            (e) =>
        e.notifType == item.notifType &&
            e.notifeventId == item.notifeventId,
      );

      if (index != -1) {
        _items[index].isRead = true;
      }
    }

    _refreshUnreadCount();
  }
}