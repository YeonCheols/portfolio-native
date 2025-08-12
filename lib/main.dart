import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

void main() {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const PortfolioWebView(),
    );
  }
}

class PortfolioWebView extends StatefulWidget {
  const PortfolioWebView({super.key});

  @override
  State<PortfolioWebView> createState() => _PortfolioWebViewState();
}

class _PortfolioWebViewState extends State<PortfolioWebView> with WidgetsBindingObserver {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _currentUrl = '';
  WebViewController? _webViewController;
  
  // 포트폴리오 웹사이트 URL
  static const String portfolioUrl = 'https://www.ycseng.com';
  
  @override
  void initState() {
    super.initState();
    // 앱 생명주기 관찰자 등록
    WidgetsBinding.instance.addObserver(this);
    _loadSavedUrl();
  }

  @override
  void dispose() {
    // 앱 생명주기 관찰자 해제
    WidgetsBinding.instance.removeObserver(this);
    // WebView 컨트롤러 정리
    _webViewController?.clearCache();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
        // 앱이 백그라운드로 갈 때
        print('App paused - cleaning up WebView');
        _webViewController?.clearCache();
        break;
      case AppLifecycleState.detached:
        // 앱이 완전히 종료될 때
        print('App detached - final cleanup');
        _webViewController?.clearCache();
        break;
      case AppLifecycleState.resumed:
        // 앱이 포그라운드로 돌아올 때
        print('App resumed');
        break;
      case AppLifecycleState.inactive:
        // 앱이 비활성화될 때
        print('App inactive');
        break;
      case AppLifecycleState.hidden:
        // 앱이 숨겨질 때
        print('App hidden');
        break;
    }
  }
  
  Future<void> _loadSavedUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUrl = prefs.getString('portfolio_url') ?? portfolioUrl;
      setState(() {
        _currentUrl = savedUrl;
        _hasError = false;
        _errorMessage = '';
      });
      
      print('Initializing WebView with URL: $savedUrl');
      
      // WebView 컨트롤러 초기화
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              print('Loading progress: $progress%');
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
              setState(() {
                _isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              print('WebView error: ${error.description}');
              print('Error code: ${error.errorCode}');
              // 모든 오류 무시하고 계속 진행
              print('Error ignored, continuing...');
              return;
            },
            onNavigationRequest: (NavigationRequest request) {
              print('Navigation request: ${request.url}');
              return NavigationDecision.navigate;
            },
          ),
        );
      
      // iOS에서 추가 설정
      if (Platform.isIOS) {
        _webViewController!.setUserAgent('Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1');
      }
      // macOS에서 추가 설정
      if (Platform.isMacOS) {
        _webViewController!.setUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
      }
      
      print('WebView controller created, loading URL...');
      
      // URL 로드
      await _webViewController!.loadRequest(Uri.parse(_currentUrl));
      print('URL load request completed');
      
    } catch (e) {
      print('Error initializing WebView: $e');
      print('Error type: ${e.runtimeType}');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load: $e';
      });
    }
  }
  
  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
  
  Future<void> _updatePortfolioUrl() async {
    final textController = TextEditingController(text: _currentUrl);
    final newUrl = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('포트폴리오 URL 변경'),
          content: TextField(
            decoration: const InputDecoration(
              labelText: '포트폴리오 웹사이트 URL',
              hintText: 'https://www.ycseng.com',
            ),
            controller: textController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(textController.text);
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
    
    if (newUrl != null && newUrl.isNotEmpty) {
      setState(() {
        _currentUrl = newUrl;
        _isLoading = true;
        _hasError = false;
      });
      
      // URL을 SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('portfolio_url', newUrl);
      
      // 새로운 URL로 웹뷰 로드
      try {
        await _webViewController!.loadRequest(Uri.parse(newUrl));
      } catch (e) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load new URL: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('성연철 포트폴리오'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_webViewController != null) {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                _webViewController!.reload();
              }
            },
            tooltip: '새로고침',
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () {
              _launchExternalUrl(_currentUrl);
            },
            tooltip: '새 탭에서 열기',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _updatePortfolioUrl,
            tooltip: 'URL 설정',
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_hasError && _webViewController != null)
            WebViewWidget(controller: _webViewController!),
          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '웹뷰 로딩 오류',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_webViewController != null) {
                        setState(() {
                          _isLoading = true;
                          _hasError = false;
                        });
                        _webViewController!.reload();
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('다시 시도'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      _launchExternalUrl(_currentUrl);
                    },
                    child: const Text('외부 브라우저에서 열기'),
                  ),
                ],
              ),
            ),
          if (_isLoading && !_hasError)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
