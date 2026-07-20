import 'webview_platform_initializer_stub.dart'
    if (dart.library.js_util) 'webview_platform_initializer_web.dart'
    as platform;

void initializeWebViewPlatform() => platform.initializeWebViewPlatform();
