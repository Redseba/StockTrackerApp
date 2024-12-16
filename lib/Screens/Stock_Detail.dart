import 'package:flutter/material.dart';
import 'package:proj2/Services/StockApi.dart';

class StockDetail extends StatefulWidget {
  final String symbol;

  const StockDetail({required this.symbol, super.key});

  @override
  StockDetailState createState() => StockDetailState();
}

class StockDetailState extends State<StockDetail> {
  Map<String, dynamic> _stockDetails = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStockDetails();
  }

  Future<void> _loadStockDetails() async {
    try {
      final details = await StockApi().getStockDetail(widget.symbol);
      setState(() {
        _stockDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load stock details";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.symbol)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.symbol)),
        body: Center(child: Text(_errorMessage!)),
      );
    }

return Scaffold(
  appBar: AppBar(title: Text(widget.symbol)),
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        Text('Stock: ${widget.symbol}'),
        Text('Current Price: \$${_stockDetails['c']?.toString() ?? 'N/A'}'),
        Text('High Price: \$${_stockDetails['h']?.toString() ?? 'N/A'}'),
        Text('Low Price: \$${_stockDetails['l']?.toString() ?? 'N/A'}'),
        Text('Open Price: \$${_stockDetails['o']?.toString() ?? 'N/A'}'),
        Text('Previous Close Price: \$${_stockDetails['pc']?.toString() ?? 'N/A'}'),
        Text('Percentage Change: \$${_stockDetails['dp']?.toString() ?? 'N/A'}'),
      ],
    ),
  ),
);

  }
}
