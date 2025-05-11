import 'package:flutter/material.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() {
    return _AnalysisPage();
  }
}

class _AnalysisPage extends State<AnalysisPage> {
  final List<Map<String, String>> mockData = [
    {'day': 'Seg', 'hours': '8h 45min', 'value': '87,50€'},
    {'day': 'Ter', 'hours': '7h 30min', 'value': '75,00€'},
    {'day': 'Qua', 'hours': '9h 00min', 'value': '90,00€'},
    {'day': 'Qui', 'hours': '8h 15min', 'value': '82,50€'},
    {'day': 'Sex', 'hours': '6h 45min', 'value': '67,50€'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Análises Semanais',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: mockData.length,
                itemBuilder: (context, index) {
                  final item = mockData[index];
                  return Card(
                    child: ListTile(
                      title: Text('${item['day']}'),
                      subtitle: Text('${item['hours']}'),
                      trailing: Text('${item['value']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
