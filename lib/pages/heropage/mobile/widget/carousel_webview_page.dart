import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/constants.dart';
import '../../../../common/loading_indicator.dart';

class CarouselWebViewPage extends StatefulWidget {
  final Uri url;
  final String title;

  const CarouselWebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<CarouselWebViewPage> createState() => _CarouselWebViewPageState();
}

class _CarouselWebViewPageState extends State<CarouselWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (_) => NavigationDecision.navigate,
        ),
      )
      ..loadRequest(widget.url);
  }

  void _closePage() {
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, __) {
        if (!didPop) return;
      },
      child: Scaffold(
        backgroundColor: primaryBlackColor,
        body: Stack(
          children: [
            _buildGradientBackground(context),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: Stack(
                      children: [
                        WebViewWidget(controller: _controller),
                        if (_isLoading) const Center(child: LoadingIndicator()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientBackground(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(color: primaryBlackColor),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: height * 0.30,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/background_gradient.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        primaryBlackColor,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final horizontalPadding = isMobile(context) ? hPadding : hPadding * 1.5;
    // final title = widget.title.trim().isEmpty ? 'Informasi' : widget.title;

    final title = 'Detail';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: hPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _closePage,
            icon: const Icon(Icons.arrow_back),
            color: primaryLightColor,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: bodyTextStyle(context, fontSize: 22),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              'Claim Is Simple',
              style: headingStyle(
                context,
                fontSize: getResponsiveFont(context, 18),
              ).copyWith(
                fontStyle: FontStyle.italic,
                color: primaryLightColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
