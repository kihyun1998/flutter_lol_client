import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lol_client/flutter_lol_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'League Client Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: LeagueClientExample(),
    );
  }
}

class LeagueClientExample extends StatefulWidget {
  const LeagueClientExample({super.key});

  @override
  _LeagueClientExampleState createState() => _LeagueClientExampleState();
}

class _LeagueClientExampleState extends State<LeagueClientExample> {
  bool isLoading = false;
  bool isConnected = false;
  String? errorMessage;

  // Connection info
  LcuConnection? connection;
  String? installPath;

  // Summoner info
  Summoner? summoner;

  Future<void> connectToLeague() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      isConnected = false;
      summoner = null;
    });

    LcuClient? client;

    try {
      // Check if League is running
      bool isRunning = await LeagueDetector.isLeagueRunning();

      if (!isRunning) {
        setState(() {
          errorMessage = '롤 클라이언트가 실행되지 않았습니다.\n롤을 실행하고 다시 시도해주세요.';
        });
        return;
      }

      // Get installation path
      installPath = await LeagueDetector.getLeagueInstallationPath();

      // Connect to League client directly
      client = await LcuClient.connect();
      connection = client.connection;
      final currentSummoner = await client.summoner.getCurrentSummoner();

      setState(() {
        isConnected = true;
        summoner = currentSummoner;
      });
    } catch (e) {
      setState(() {
        errorMessage = '연결 실패: ${e.toString()}';
      });
    } finally {
      client?.close();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refreshSummonerInfo() async {
    if (!isConnected || connection == null) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    LcuClient? client;

    try {
      client = LcuClient.create(connection!);
      final currentSummoner = await client.summoner.getCurrentSummoner();

      setState(() {
        summoner = currentSummoner;
      });
    } catch (e) {
      setState(() {
        errorMessage = '소환사 정보 업데이트 실패: ${e.toString()}';
      });
    } finally {
      client?.close();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('League Client Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildConnectionSection(),
            SizedBox(height: 24),
            if (isConnected && summoner != null) _buildSummonerSection(),
            if (errorMessage != null) _buildErrorSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isConnected ? Icons.wifi : Icons.wifi_off,
                  color: isConnected ? Colors.green : Colors.grey,
                ),
                SizedBox(width: 8),
                Text('연결 상태', style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            SizedBox(height: 16),

            if (isConnected && connection != null) ...[
              _buildInfoRow('상태', '✅ 연결됨', Colors.green),
              _buildInfoRow('API URL', connection!.baseUrl, Colors.blue),
              if (installPath != null)
                _buildInfoRow('설치 경로', installPath!, Colors.grey[700]!),
            ] else if (!isConnected && !isLoading) ...[
              _buildInfoRow('상태', '❌ 연결 안됨', Colors.red),
              Text(
                '롤 클라이언트에 연결하려면 아래 버튼을 눌러주세요.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],

            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : connectToLeague,
                    icon: isLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.refresh),
                    label: Text(isLoading ? '연결 중...' : '롤 클라이언트 연결'),
                  ),
                ),
                if (isConnected) ...[
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : refreshSummonerInfo,
                    icon: Icon(Icons.person_search),
                    label: Text('정보 새로고침'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummonerSection() {
    final sum = summoner!;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    sum.summonerLevel.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sum.displayName,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '레벨 ${sum.summonerLevel}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),

            Text(
              '경험치 정보',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            LinearProgressIndicator(
              value: sum.precisePercentToNextLevel / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${sum.xpSinceLastLevel} XP'),
                Text('${sum.percentCompleteForNextLevel}%'),
                Text('${sum.totalXpForCurrentLevel} XP'),
              ],
            ),
            Text(
              '다음 레벨까지 ${sum.xpUntilNextLevel} XP 남음',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),

            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),

            Text(
              '계정 정보',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            _buildInfoRow(
              '소환사 ID',
              sum.summonerId.toString(),
              Colors.grey[700]!,
            ),
            _buildInfoRow('계정 ID', sum.accountId.toString(), Colors.grey[700]!),
            _buildInfoRow(
              '프로필 아이콘',
              sum.profileIconId.toString(),
              Colors.grey[700]!,
            ),
            _buildInfoRow(
              'PUUID',
              '${sum.puuid.substring(0, 16)}...',
              Colors.grey[700]!,
            ),

            if (sum.hasNamingRestrictions) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange[700], size: 16),
                    SizedBox(width: 8),
                    Text(
                      '이름 제한 사항이 있는 계정입니다',
                      style: TextStyle(color: Colors.orange[700]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error, color: Colors.red[700]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '오류',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _copyErrorToClipboard(),
                  icon: Icon(Icons.copy, color: Colors.red[700]),
                  tooltip: '오류 메시지 복사',
                ),
              ],
            ),
            SizedBox(height: 8),
            SelectableText(
              errorMessage!,
              style: TextStyle(color: Colors.red[700]),
            ),
            SizedBox(height: 8),
            Text(
              '위 텍스트를 선택해서 복사하거나 복사 버튼을 눌러주세요.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyErrorToClipboard() {
    if (errorMessage != null) {
      Clipboard.setData(ClipboardData(text: errorMessage!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check, color: Colors.white),
              SizedBox(width: 8),
              Text('오류 메시지가 클립보드에 복사되었습니다'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: valueColor)),
          ),
        ],
      ),
    );
  }
}
