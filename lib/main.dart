import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:scanner/entry.dart';
import 'package:scanner/sheet.dart';

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "myhack-ieee",
  "private_key_id": "0f69c76b57e3540246047de59dba345a297e6e9e",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDEpIgxixCh3Ejc\nxsIOVbEy4ylaFhxCChiDboLJ+zXt2s+xmzomausS3FYgTC4+7LIKsosxcQrPniFJ\nU0s6gGhovHbFlFkK6a5gwEyDcY5Y/gawwWKi3WLLeZSE4mKt7OnJTsdLbMc3vmPz\nSMM8hgYTvDiQVoIk91OnrLK1imPnqSUQp/wSFzW/9rlA8L/wF4M5ZGNACBnKdBxy\ntmiCfSGmTELs7Sak0AJ+3sJuLmKqHcp3Zup03eXN3+0hBe1ybCRQ5gBp+MwoDiA1\nQLl5Kfehq+n+PazDzU82C0mW9NtrhKQnwnuHDM0AdlaqqTbKVe6zR29r/DH/4i2t\noCsIX17RAgMBAAECggEABv9DyV+Fa/0GqrR320K5V3I12nrG7qKlVKfuB3nk5V3P\n3iYD37IWQ0mL1wJe8uZBP5gy08ON+u1Jie5o0uAW1wM9xrIMqRK/nbm5/0NfKVOA\nsXFwLRNrnInq+v+DO2UevIcNGGX6gMVJkTKZn+G0/abI7Hnnj6EtXN4MTeFqxKd0\nC3XDE9R/29mL7RhdAdsTtBA6qDdXawUlUOJVHggdzUgA+UDEsytRoqmOwx+X6NN0\n9VZgLu8zqdEGW4FWscSgzteCzYvAGLJH0cWq3lqz1P4Dg4p2wVzUstUS4rpG1dsG\nqLKETbEturHmS+eXl0VJ1d62E3i4WY/EoKFQCzwJ8QKBgQD/uyykj95+/B8ZfeYJ\nNA7nLhTzLdrEYY17nCQhQpRuXyLhT+Tq4IEDivYSNrow8ItxdjBkYZ0WhV6lavPk\nlAGCNymSHR627V8sg2ye8y9nR+i3q8lgizSrmNkZVgR3BcOdNlM83oCoNea/CNQL\nY3qeTuvX3BsvrkUMOk/S7TuEDwKBgQDE2XR6BgAaZ3mt9mK+ZRS7wRvDc+D4D0LN\n1+1koUFrHF60d4RJYtMUQGb+vgBgOWvzC2K06nvN2qcGOdYTEP0DM5vBnV4S/BGx\n0pkxWsYR68hpCjk0hz304tHV0beTXhW37xwkumNexHRCP0PhUT5uWACz3UtK9dPH\nY7tpnDqPHwKBgCk2vzEeRptsgo6XLbWaADTdxl6Sq0ku96BOP7xkgItxJavuNlRs\nLh6mDJZO3573hWGZzJ7A5JI2mFRMclYKTFvyC+8SZlrQ0p/X5m+PfbpFaon/U4sN\npEVrcsGUjU+pTCdQFAYhTdbOKQvsnk/fjmlpCrVVMcRzb4lS9H5n4UmdAoGAJMCk\n6pNsOYHQShaSYRHmSRfI4zkja60Nv/jsrbkdya3GUNNvs3PsDP/pOu6mi1CtQveB\nOl39N3X3cUYjHfQyCQL9tax3//toIlc7mudjy7zF8jaib5hAjRQ8MTuylqUeUPUn\nwAO8wdjUC/pb5hmRGnD70JkkkZ5MKBIKz7EHjekCgYAH6E1YFDP6G78121etc+hI\nJ0tpu0EpWaDo3mcX5reyfnJM+HW/mT7s4xUXzL5rjhYQ7pRs2sTwQ7lJRd7pFBqd\nqYr8c/f54mdUM11QLw9QggRXvOP2FtS21k07AO/dxbydLfDuFrZaBLfNCRytBNNb\nZrI74Q4254qKBuUO2zERTA==\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@myhack-ieee.iam.gserviceaccount.com",
  "client_id": "115645287422807609938",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40myhack-ieee.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

// TIN Spreadsheet ID
// const _spreadsheetId = '1eXuhbU1g_hJRDqlRDtAHUXTd0GF-87X5Is38MuqZTPY';

// Leetcode Workshop
const _spreadsheetId = '1z8peC3yn1ShrHM-BNho8jzISKUj74yYp5cVaOvg9pR8';

final gsheets = GSheets(_credentials);

void main() async {
  final spreadSheet = await gsheets.spreadsheet(_spreadsheetId);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(SpreadsheetProvider(spreadsheet: spreadSheet, child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
          primarySwatch: const MaterialColor(
        0XFF2B7BBC,
        <int, Color>{
          50: Color(0xFFE3F2FD),
          100: Color(0xFFBBDEFB),
          200: Color(0xFF90CAF9),
          300: Color(0xFF64B5F6),
          400: Color(0xFF42A5F5),
          500: Color(0XFF2B7BBC),
          600: Color(0xFF1E88E5),
          700: Color(0xFF1976D2),
          800: Color(0xFF1565C0),
          900: Color(0xFF0D47A1),
        },
      )),
      home: const UsernameEntryScreen(),
    );
  }
}
