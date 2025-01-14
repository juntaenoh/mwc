import 'package:flutter/material.dart';

class DataListPage extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  DataListPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weight Data List"),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          double? diff = index == 0 ? null : data[index]['weight'] - data[index - 1]['weight'];

          return ListTile(
            title: Text("Type: ${data[index]['weightType']}"),
            subtitle: Text(
                "Date: ${data[index]['measuredDate']} Time: ${data[index]['measuredTime']}\nWeight: ${data[index]['weight']}kg Difference: ${diff != null ? diff.toStringAsFixed(2) : 'N/A'}kg"),
          );
        },
      ),
    );
  }
}
