const apiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:8000',
);

/// Batas waktu tunggu setiap permintaan ke server.
const batasWaktu = Duration(seconds: 10);