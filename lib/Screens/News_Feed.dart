import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening URLs
import 'package:proj2/Services/StockApi.dart';  // Your API service

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  late Future<List<Map<String, String>>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _fetchMarketNews();
  }

  Future<List<Map<String, String>>> _fetchMarketNews() async {
    final news = await StockApi().fetchMarketNews(); // Call to your API wrapper
    return news.map((article) {
      return {
        'headline': article['headline'] ?? '',
        'summary': article['summary'] ?? '',
        'url': article['url'] ?? '',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Market News')),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading news'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available'));
          } else {
            final news = snapshot.data!;
            return ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                final article = news[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(article['headline'] ?? 'No Headline'),
                    subtitle: Text(
                      article['summary'] ?? 'No Summary',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      _openUrl(article['url'] ?? '');
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _openUrl(String url) {
    if (url.isNotEmpty) {
      launch(url); // Open the URL in a web browser
    }
  }
}