import 'package:shared_preferences/shared_preferences.dart';

const _defaultApiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:9000',
);

String _apiUrl = _defaultApiUrl;

String get apiUrl => _apiUrl;

Future<void> muatApiUrl() async {
  final preferences = await SharedPreferences.getInstance();
  _apiUrl = preferences.getString('api_url') ?? _defaultApiUrl;
}

Future<void> simpanApiUrl(String url) async {
  final preferences = await SharedPreferences.getInstance();
  await preferences.setString('api_url', url);
  _apiUrl = url;
}

bool urlApiValid(String value) {
  final uri = Uri.tryParse(value.trim());
  return uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty &&
      uri.query.isEmpty &&
      uri.fragment.isEmpty &&
      (uri.path.isEmpty || uri.path == '/');
}

const batasWaktu = Duration(seconds: 10);
