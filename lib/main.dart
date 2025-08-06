import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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

class _PortfolioWebViewState extends State<PortfolioWebView> {
  bool _isLoading = true;
  String _currentUrl = '';
  
  // 포트폴리오 웹사이트 URL (여기에 본인의 포트폴리오 URL을 입력하세요)
  static const String portfolioUrl = 'https://www.ycseng.com';
  
  @override
  void initState() {
    super.initState();
    _loadSavedUrl();
  }
  
  Future<void> _loadSavedUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('portfolio_url') ?? portfolioUrl;
    setState(() {
      _currentUrl = savedUrl;
      _isLoading = false;
    });
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
      });
      
      // URL을 SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('portfolio_url', newUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('포트폴리오'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.web,
                    size: 64,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '포트폴리오 웹사이트',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentUrl,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      _launchExternalUrl(_currentUrl);
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('포트폴리오 열기'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _updatePortfolioUrl,
                    child: const Text('URL 변경'),
                  ),
                ],
              ),
            ),
    );
  }
}
