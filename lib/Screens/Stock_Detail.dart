import 'package:flutter/material.dart';
import 'package:proj2/Services/StockApi.dart';

class StockDetail extends StatefulWidget {
  final String symbol;

  const StockDetail({Key? key, required this.symbol}) : super(key: key);

  @override
  _StockDetailState createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  late Future<Map<String, dynamic>> _stockDetails;

  @override
  void initState() {
    super.initState();
    // Fetch stock details when the screen is initialized
    _stockDetails = StockApi().getStockDetail(widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _stockDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No stock details available'));
          } else {
            final stock = snapshot.data!;

            // Extract the details from the response
            final double? price = stock['c'];
            final double? change = stock['dp'];
            final double? high = stock['h'];
            final double? low = stock['l'];
            final double? open = stock['o'];
            final double? previousClose = stock['pc'];

            // Determine the change percentage color
            final isPositive = (change ?? 0) > 0;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Price: \$${price?.toStringAsFixed(2) ?? 'N/A'}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Change: ${change?.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'High: \$${high?.toStringAsFixed(2) ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Low: \$${low?.toStringAsFixed(2) ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Open: \$${open?.toStringAsFixed(2) ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Previous Close: \$${previousClose?.toStringAsFixed(2) ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
