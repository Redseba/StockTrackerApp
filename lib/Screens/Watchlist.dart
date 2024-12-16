import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/Stock_Detail.dart';

class Watchlist extends StatefulWidget {
  @override
  _WatchlistState createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  List<String> _savedStocks = [];

  @override
  void initState() {
    super.initState();
    _loadSavedStocks();
  }

  void _loadSavedStocks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedStocks = prefs.getStringList('watchlist') ?? [];
    });
  }

  void _removeFromWatchlist(String stockSymbol) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> savedStocks = prefs.getStringList('watchlist') ?? [];

  if (savedStocks.contains(stockSymbol)) {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Stock'),
        content: const Text('Are you sure you want to remove this stock from your watchlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (shouldDelete ?? false) {
      savedStocks.remove(stockSymbol);
      await prefs.setStringList('watchlist', savedStocks);
      print('Removed from Watchlist: $stockSymbol');
      setState(() {});
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _savedStocks.isEmpty
          ? const Center(child: Text('Your watchlist is empty.'))
          : ListView.builder(
              itemCount: _savedStocks.length,
              itemBuilder: (context, index) {
                final stock = _savedStocks[index];
                return ListTile(
                  title: Text(
                    stock,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFromWatchlist(stock),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StockDetail(symbol: stock),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
