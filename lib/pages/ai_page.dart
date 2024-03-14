import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  String _searchText = '';
  List<dynamic> _recipes = [];

  Future<void> _fetchRecipes(String query) async {
    const String apiKey =
        '8db9d6850c104be19f2355ed0ae20a4f'; // Replace with your Spoonacular API key
    final String url =
        'https://api.spoonacular.com/recipes/search?query=$query&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _recipes = json.decode(response.body)['results'];
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<void> _showRecipeDetails(String recipeId) async {
    const String apiKey = '8db9d6850c104be19f2355ed0ae20a4f';
    final String url =
        'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> recipeInfo = json.decode(response.body);
      final String fullRecipe = _stripHtmlTags(recipeInfo['instructions']);
      final String imageUrl = recipeInfo['image'];

      _showBottomSheet(fullRecipe, imageUrl);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }

  String _stripHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  void _showBottomSheet(String fullRecipe, String imageUrl) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16.0),
                Text(
                  fullRecipe,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Please ask us !"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              onSubmitted: (value) {
                _fetchRecipes(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search your recipe here ...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: _recipes.isNotEmpty
                  ? ListView.builder(
                      itemCount: _recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _recipes[index];
                        return ListTile(
                          title: Text(recipe['title']),
                          subtitle: Text(recipe['sourceUrl']),
                          onTap: () {
                            _showRecipeDetails(recipe['id'].toString());
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text('No recipes found'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
