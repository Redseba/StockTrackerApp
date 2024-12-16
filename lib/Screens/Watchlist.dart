import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Stock_Detail.dart';

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

  void _removeFromWatchlist(String stock) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedStocks.remove(stock);
    });
    prefs.setStringList('watchlist', _savedStocks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Navigate back to Home
        ),
      ),
      body: _savedStocks.isEmpty
          ? Center(child: Text('Your watchlist is empty.'))
          : ListView.builder(
              itemCount: _savedStocks.length,
              itemBuilder: (context, index) {
                final stock = _savedStocks[index];
                return ListTile(
                  title: Text(stock),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
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
