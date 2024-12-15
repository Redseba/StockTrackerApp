import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proj2/Services/StockApi.dart';
import 'package:proj2/Screens/Stock_Detail.dart';
import 'package:proj2/Screens/Watchlist.dart';  // Correct path to Watchlist screen
import 'package:proj2/Screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proj2/Screens/News_Feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _searchStocks() async {
    final query = _controller.text;
    if (query.isNotEmpty) {
      final stocks = await StockApi().searchStocks(query);
      setState(() {
        _searchResults = stocks;
      });
    }
  }

  void _addToWatchlist(Map<String, dynamic> stock) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedStocks = prefs.getStringList('watchlist') ?? [];
    String stockSymbol = stock['symbol'];

    if (!savedStocks.contains(stockSymbol)) {
      savedStocks.add(stockSymbol);
      await prefs.setStringList('watchlist', savedStocks);
      print('Added to Watchlist: $stockSymbol');
    } else {
      print('$stockSymbol is already in Watchlist');
    }
  }

  void _logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Stocks')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Watchlist()),  // Navigate to Watchlist screen
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('News Feed'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsFeedScreen()),  // Navigate to News Feed screen
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search for stocks',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: _searchStocks,
              child: const Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final stock = _searchResults[index];
                  final double? percentageChange = stock['dp'];
                  final bool isPositive = (percentageChange ?? 0) > 0;

                  return ListTile(
                    title: Text(
                      stock['description'] ?? stock['symbol'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      stock['symbol'],
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                      onPressed: () => _addToWatchlist(stock),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StockDetail(symbol: stock['symbol']),
                        ),
                      );
                    },
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
