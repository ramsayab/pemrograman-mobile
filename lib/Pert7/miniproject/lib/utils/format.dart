String formatMoney(double value) =>
    'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(?=(\d{3})+(?!\d))'), (match) => '.')}';

String formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

String formatLongDate(DateTime date) =>
    '${date.day} ${['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'][date.month - 1]} ${date.year}';

bool sameDay(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
