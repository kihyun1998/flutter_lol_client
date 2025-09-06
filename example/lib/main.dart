import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/connection_status_badge.dart';
import 'panels/left_panel.dart';
import 'panels/right_panel.dart';
import 'services/lcu_service.dart';
import 'services/result_formatter_service.dart';
import 'models/api_category.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LCU API Wrapper - flutter_lol_client',
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
  ApiCategoryType selectedCategory = ApiCategoryType.getCurrentSummoner;
  final TextEditingController _summonerIdController = TextEditingController();
  final TextEditingController _puuidController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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

  Future<void> testGetSummonerByPuuid() async {
    final puuid = _puuidController.text.trim();
    if (puuid.isEmpty) {
      setState(() {
        result = _formatter.formatValidationError('Please enter a PUUID');
      });
      return;
    }

    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Getting summoner by PUUID: $puuid');
    });

    try {
      final summonerResult = await _lcuService.getSummonerByPuuid(puuid);
      
      setState(() {
        if (summonerResult['success']) {
          result = _formatter.formatSummonerResult(summonerResult, puuid: puuid);
        } else {
          result = _formatter.formatApiError('Get summoner by PUUID', summonerResult['error']);
        }
      });
    } catch (e) {
      setState(() {
        result = _formatter.formatApiError('Get summoner by PUUID', e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> testGetCurrentSummonerJwt() async {
    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Getting current summoner JWT');
    });

    try {
      final jwtResult = await _lcuService.getCurrentSummonerJwt();
      
      setState(() {
        if (jwtResult['success']) {
          result = _formatter.formatGenericResult('Current Summoner JWT', jwtResult);
        } else {
          result = _formatter.formatApiError('Get current summoner JWT', jwtResult['error']);
        }
      });
    } catch (e) {
      setState(() {
        result = _formatter.formatApiError('Get current summoner JWT', e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> testGetCurrentSummonerProfilePrivacy() async {
    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Getting current summoner profile privacy');
    });

    try {
      final privacyResult = await _lcuService.getCurrentSummonerProfilePrivacy();
      
      setState(() {
        if (privacyResult['success']) {
          result = _formatter.formatGenericResult('Current Summoner Profile Privacy', privacyResult);
        } else {
          result = _formatter.formatApiError('Get current summoner profile privacy', privacyResult['error']);
        }
      });
    } catch (e) {
      setState(() {
        result = _formatter.formatApiError('Get current summoner profile privacy', e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> testCheckNameAvailability() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        result = _formatter.formatValidationError('Please enter a summoner name');
      });
      return;
    }

    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Checking name availability: $name');
    });

    try {
      final availabilityResult = await _lcuService.checkNameAvailability(name);
      
      setState(() {
        if (availabilityResult['success']) {
          result = _formatter.formatGenericResult('Name Availability Check', availabilityResult);
        } else {
          result = _formatter.formatApiError('Check name availability', availabilityResult['error']);
        }
      });
    } catch (e) {
      setState(() {
        result = _formatter.formatApiError('Check name availability', e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> testGetCurrentSummonerIds() async {
    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Getting current summoner IDs');
    });

    try {
      final idsResult = await _lcuService.getCurrentSummonerIds();
      
      setState(() {
        if (idsResult['success']) {
          result = _formatter.formatApiResult('Current Summoner IDs', idsResult['data']);
        } else {
          result = _formatter.formatApiError('Get current summoner IDs', idsResult['error']);
        }
      });
    } catch (e) {
      setState(() {
        result = _formatter.formatApiError('Get current summoner IDs', e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> testGetCurrentSummonerRerollPoints() async {
    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Getting current summoner reroll points');
    });

    try {
      final rerollResult = await _lcuService.getCurrentSummonerRerollPoints();
      
      setState(() {
        if (rerollResult['success']) {
          result = _formatter.formatApiResult('Current Summoner Reroll Points', rerollResult['data']);
        } else {
          result = _formatter.formatApiError('Get current summoner reroll points', rerollResult['error']);
        }
      });
    } catch (e) {
      setState(() {
        result = _formatter.formatApiError('Get current summoner reroll points', e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> testGetCurrentSummonerProfile() async {
    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Getting current summoner profile');
    });

    try {
      final profileResult = await _lcuService.getCurrentSummonerProfile();
      
      setState(() {
        if (profileResult['success']) {
          result = _formatter.formatApiResult('Current Summoner Profile', profileResult['data']);
        } else {
          result = _formatter.formatApiError('Get current summoner profile', profileResult['error']);
        }
      });
    } catch (e) {
      setState(() {
        result = _formatter.formatApiError('Get current summoner profile', e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> testGetSummonerServiceStatus() async {
    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Getting summoner service status');
    });

    try {
      final statusResult = await _lcuService.getSummonerServiceStatus();
      
      setState(() {
        if (statusResult['success']) {
          result = _formatter.formatApiResult('Summoner Service Status', statusResult['data']);
        } else {
          result = _formatter.formatApiError('Get summoner service status', statusResult['error']);
        }
      });
    } catch (e) {
      setState(() {
        result = _formatter.formatApiError('Get summoner service status', e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> testGetCurrentSummonerAutofill() async {
    setState(() {
      isLoading = true;
      result = _formatter.formatLoadingMessage('Getting current summoner autofill');
    });

    try {
      final autofillResult = await _lcuService.getCurrentSummonerAutofill();
      
      setState(() {
        if (autofillResult['success']) {
          result = _formatter.formatApiResult('Current Summoner Autofill', autofillResult['data']);
        } else {
          result = _formatter.formatApiError('Get current summoner autofill', autofillResult['error']);
        }
      });
    } catch (e) {
      setState(() {
        result = _formatter.formatApiError('Get current summoner autofill', e.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onCategoryChanged(ApiCategoryType? category) {
    if (category != null) {
      setState(() {
        selectedCategory = category;
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
            const Text('LCU API Wrapper'),
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
            selectedCategory: selectedCategory,
            onCategoryChanged: onCategoryChanged,
            onGetCurrentSummoner: testGetCurrentSummoner,
            onGetSummonerById: testGetSummonerById,
            onGetSummonerByPuuid: testGetSummonerByPuuid,
            onGetCurrentSummonerIds: testGetCurrentSummonerIds,
            onGetCurrentSummonerRerollPoints: testGetCurrentSummonerRerollPoints,
            onGetCurrentSummonerProfile: testGetCurrentSummonerProfile,
            onGetCurrentSummonerJwt: testGetCurrentSummonerJwt,
            onGetCurrentSummonerPrivacy: testGetCurrentSummonerProfilePrivacy,
            onCheckNameAvailability: testCheckNameAvailability,
            onGetSummonerServiceStatus: testGetSummonerServiceStatus,
            onGetCurrentSummonerAutofill: testGetCurrentSummonerAutofill,
            summonerIdController: _summonerIdController,
            puuidController: _puuidController,
            nameController: _nameController,
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
