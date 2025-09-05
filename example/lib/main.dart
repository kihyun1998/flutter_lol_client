import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/connection_status_badge.dart';
import 'panels/left_panel.dart';
import 'panels/right_panel.dart';
import 'services/lcu_service.dart';
import 'services/result_formatter_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoL Client API Tester',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF1E88E5),
              brightness: Brightness.dark,
            ).copyWith(
              surface: const Color(0xFF1A1A1A),
              surfaceContainerHighest: const Color(0xFF2D2D2D),
              primary: const Color(0xFF1E88E5),
              secondary: const Color(0xFF26A69A),
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2D2D2D),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black26,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF2D2D2D),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = '';
  bool isLoading = false;
  String connectionStatus = 'Not Connected';
  bool isConnected = false;
  final TextEditingController _summonerIdController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final LcuService _lcuService = LcuService.instance;
  final ResultFormatterService _formatter = ResultFormatterService.instance;

  Future<void> testConnectionOnly() async {
    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Testing connection');
      connectionStatus = 'Connecting...';
    });

    try {
      final connection = await _lcuService.testConnection();

      setState(() {
        isConnected = true;
        connectionStatus = 'Connected (${connection.host}:${connection.port})';
        result = _formatter.formatConnectionResult({
          'host': connection.host,
          'port': connection.port,
          'protocol': connection.protocol,
          'baseUrl': connection.baseUrl,
        });
      });
    } catch (e) {
      setState(() {
        isConnected = false;
        connectionStatus = 'Connection Failed';
        result = _formatter.formatConnectionError(e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> testGetCurrentSummoner() async {
    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Getting current summoner');
    });

    try {
      final summonerResult = await _lcuService.getCurrentSummoner();
      
      setState(() {
        if (summonerResult['success']) {
          result = _formatter.formatSummonerResult(summonerResult);
        } else {
          result = _formatter.formatApiError('Get current summoner', summonerResult['error']);
        }
      });
    } catch (e) {
      setState(() {
        result = _formatter.formatApiError('Get current summoner', e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> testGetSummonerById() async {
    final summonerId = _summonerIdController.text.trim();
    if (summonerId.isEmpty) {
      setState(() {
        result = _formatter.formatValidationError('Please enter a summoner ID');
      });
      return;
    }

    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Getting summoner by ID: $summonerId');
    });

    try {
      final parsedId = int.parse(summonerId);
      final summonerResult = await _lcuService.getSummonerById(parsedId);
      
      setState(() {
        if (summonerResult['success']) {
          result = _formatter.formatSummonerResult(summonerResult, summonerId: summonerId);
        } else {
          result = _formatter.formatApiError('Get summoner by ID', summonerResult['error']);
        }
      });
    } catch (e) {
      setState(() {
        result = _formatter.formatApiError('Get summoner by ID', e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void copyResult() {
    if (result.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: result));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text('📋 Result copied to clipboard'),
            ],
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void clearResult() {
    setState(() {
      result = '';
    });
  }

  @override
  void dispose() {
    _summonerIdController.dispose();
    _scrollController.dispose();
    _lcuService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.gamepad, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('LoL Client API Tester'),
            const Spacer(),
            ConnectionStatusBadge(
              isConnected: isConnected,
              status: connectionStatus,
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Left Panel - Controls
          LeftPanel(
            onTestConnection: testConnectionOnly,
            onGetCurrentSummoner: testGetCurrentSummoner,
            onGetSummonerById: testGetSummonerById,
            summonerIdController: _summonerIdController,
            isLoading: isLoading,
          ),

          // Right Panel - Results
          RightPanel(
            result: result,
            scrollController: _scrollController,
            onClearResult: clearResult,
            onCopyResult: copyResult,
          ),
        ],
      ),
    );
  }
}
