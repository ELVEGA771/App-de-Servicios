import 'package:flutter/material.dart';

class AdminViewDetailScreen extends StatelessWidget {
  final String title;
  final Future<List<dynamic>> futureData;

  const AdminViewDetailScreen({
    super.key,
    required this.title,
    required this.futureData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<dynamic>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          if (data.isEmpty) return const Center(child: Text('No data'));

          // Get columns from the first item keys
          final columns = (data.first as Map<String, dynamic>).keys.toList();

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: columns
                    .map((col) => DataColumn(
                          label: Text(
                            col.toUpperCase().replaceAll('_', ' '),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
                rows: data.map((row) {
                  return DataRow(
                    cells: columns.map((col) {
                      final value = row[col];
                      return DataCell(Text(value?.toString() ?? ''));
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
