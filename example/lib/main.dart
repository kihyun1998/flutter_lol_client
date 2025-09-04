import 'package:flutter/material.dart';
import 'package:flutter_lol_client/flutter_lol_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'League Client Example',
      home: LeagueClientExample(),
    );
  }
}

class LeagueClientExample extends StatefulWidget {
  @override
  _LeagueClientExampleState createState() => _LeagueClientExampleState();
}

class _LeagueClientExampleState extends State<LeagueClientExample> {
  String result = '버튼을 눌러서 확인하세요';
  bool isLoading = false;

  Future<void> checkLeague() async {
    setState(() {
      isLoading = true;
      result = '확인 중...';
    });

    try {
      bool isRunning = await LeagueDetector.isLeagueRunning();
      
      if (isRunning) {
        String installPath = await LeagueDetector.getLeagueInstallationPath();
        LcuConnection connection = await LcuScanner.scanForClient();
        
        setState(() {
          result = '✅ 롤 실행중!\n'
                  '설치경로: $installPath\n'
                  'LCU API: ${connection.baseUrl}';
        });
      } else {
        setState(() {
          result = '❌ 롤이 실행중이 아닙니다';
        });
      }
    } catch (e) {
      setState(() {
        result = '❌ 오류: ${e.toString()}';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('League Client Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : checkLeague,
              child: Text(isLoading ? '확인 중...' : '롤 클라이언트 확인'),
            ),
          ],
        ),
      ),
    );
  }
}
