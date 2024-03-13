import 'package:flutter/material.dart';
import 'package:recepie_radar/models/recipe.dart';
import 'package:recepie_radar/pages/recipe_page.dart';
import 'package:recepie_radar/services/data_sevice.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _mealTypeFilter = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RecipeBook"),
        centerTitle: true,
      ),
      body: SafeArea(child: _buildUI()),
    );
  }

  Widget _buildUI() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [_recipeTypeButtons(), _recipesList()],
      ),
    );
  }

  Widget _recipeTypeButtons() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.05,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: FilledButton(
                onPressed: () {
                  setState(() {
                    _mealTypeFilter = "snack";
                  });
                },
                child: const Text("🥕snack")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: FilledButton(
                onPressed: () {
                  setState(() {
                    _mealTypeFilter = "breakfast";
                  });
                },
                child: const Text("🍳breakfast")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: FilledButton(
                onPressed: () {
                  setState(() {
                    _mealTypeFilter = "lunch";
                  });
                },
                child: const Text("🥗lunch")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: FilledButton(
                onPressed: () {
                  setState(() {
                    _mealTypeFilter = "dinner";
                  });
                },
                child: const Text("🥘dinner")),
          )
        ],
      ),
    );
  }

  Widget _recipesList() {
    return Expanded(
        child: FutureBuilder(
      future: DataService().getRecipes(_mealTypeFilter),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("unable to load data"),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Recipe recipe = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RecipePage(
                      recipe: recipe,
                    );
                  }));
                },
                contentPadding: const EdgeInsets.only(top: 20.0),
                isThreeLine: true,
                subtitle:
                    Text("${recipe.cuisine}\nDifficulty: ${recipe.difficulty}"),
                leading: Image.network(recipe.image),
                title: Text(recipe.name),
                trailing: Text(
                  "${recipe.rating.toString()}⭐",
                  style: const TextStyle(fontSize: 15),
                ),
              );
            });
      },
    ));
  }
}
