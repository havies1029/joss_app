// Digunakan saat compile di web
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

void registerWebViewFactory(String viewType, Object Function(int viewId) factory) {

  debugPrint("registerWebViewFactory called for viewType: $viewType");

  // akses langsung ke platformViewRegistry
  // ignore: undefined_prefixed_name
  ui_web.platformViewRegistry.registerViewFactory(viewType, factory);
}
