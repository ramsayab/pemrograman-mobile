import 'package:flutter/material.dart';

import '../models/kegiatan.dart';
import '../utils/format.dart';

class FormKegiatanPage extends StatefulWidget {
  const FormKegiatanPage({super.key, this.initial});
  final Kegiatan? initial;
  @override
  State<FormKegiatanPage> createState() => _FormKegiatanPageState();
}

class _FormKegiatanPageState extends State<FormKegiatanPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController title;
  late final TextEditingController amount;
  late String category;
  late KegiatanType type;
  late DateTime date;
  late bool done;

  @override
  void initState() {
    super.initState();
    final item = widget.initial;
    title = TextEditingController(text: item?.title);
    amount = TextEditingController(
      text: item == null || item.amount == 0
          ? ''
          : item.amount.toStringAsFixed(0),
    );
    category = item?.category ?? 'Kuliah';
    type = item?.type ?? KegiatanType.none;
    date = item?.date ?? DateTime.now();
    done = item?.done ?? false;
  }

  @override
  void dispose() {
    title.dispose();
    amount.dispose();
    super.dispose();
  }

  void save() {
    if (!formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Kegiatan(
        id: widget.initial?.id,
        title: title.text.trim(),
        category: category,
        date: date,
        amount: double.tryParse(amount.text.replaceAll('.', '')) ?? 0,
        type: type,
        done: done,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.initial == null ? 'Tambah aktivitas' : 'Ubah aktivitas',
      ),
    ),
    body: Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: title,
            decoration: const InputDecoration(
              labelText: 'Nama aktivitas',
              prefixIcon: Icon(Icons.edit_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Nama aktivitas wajib diisi'
                : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: category,
            decoration: const InputDecoration(
              labelText: 'Kategori',
              border: OutlineInputBorder(),
            ),
            items:
                [
                      'Kuliah',
                      'Harian',
                      'Makan',
                      'Proyek kelompok',
                      'Nongkrong',
                      'Kerja paruh waktu',
                    ]
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
            onChanged: (value) => setState(() => category = value!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<KegiatanType>(
            initialValue: type,
            decoration: const InputDecoration(
              labelText: 'Jenis keuangan',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: KegiatanType.none,
                child: Text('Tidak ada'),
              ),
              DropdownMenuItem(
                value: KegiatanType.income,
                child: Text('Pemasukan'),
              ),
              DropdownMenuItem(
                value: KegiatanType.expense,
                child: Text('Pengeluaran'),
              ),
            ],
            onChanged: (value) => setState(() => type = value!),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nominal (opsional)',
              prefixText: 'Rp ',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value != null &&
                    value.isNotEmpty &&
                    double.tryParse(value.replaceAll('.', '')) == null
                ? 'Nominal tidak valid'
                : null,
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Tanggal'),
            subtitle: Text(formatLongDate(date)),
            trailing: TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                  initialDate: date,
                );
                if (picked != null) setState(() => date = picked);
              },
              child: const Text('Pilih'),
            ),
          ),
          if (widget.initial != null)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sudah selesai'),
              value: done,
              onChanged: (value) => setState(() => done = value),
            ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save_outlined),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                widget.initial == null
                    ? 'Simpan aktivitas'
                    : 'Simpan perubahan',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
