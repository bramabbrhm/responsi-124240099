import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spell_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'books_view.dart';
import 'favorite_spell_view.dart';
import 'login_view.dart';

class SpellView extends StatefulWidget {
  const SpellView({super.key});

  @override
  State<SpellView> createState() => _SpellViewState();
}

class _SpellViewState extends State<SpellView> {
  late Future<List<SpellModel>> _spellsFuture;

  @override
  void initState() {
    super.initState();
    _spellsFuture = ApiService().fetchSpells();
  }

  void _logout() async {
    await StorageService.clearLoginSession();
    Get.offAll(() => const LoginView());
    Get.snackbar(
      "Success!",
      "Logged out Successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Box<SpellModel> box = Hive.box<SpellModel>('favorite_spells');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Spells Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<List<SpellModel>>(
        future: _spellsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _spellsFuture = ApiService().fetchSpells();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No spells found.'));
          }

          final spells = snapshot.data!;

          return ValueListenableBuilder<Box<SpellModel>>(
            valueListenable: box.listenable(),
            builder: (context, favoriteBox, _) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: spells.length,
                itemBuilder: (context, index) {
                  final spell = spells[index];
                  final isFavorite = favoriteBox.containsKey(spell.spell);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.book, color: Colors.deepPurple),
                      ),
                      title: Text(
                        spell.spell,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(spell.use),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        tooltip: isFavorite
                            ? 'Remove from favorite'
                            : 'Add to favorite',
                        onPressed: () {
                          if (!isFavorite) {
                            favoriteBox.put(spell.spell, spell);
                            Get.snackbar(
                              "Add!",
                              "${spell.spell} successfully added to fav list!",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } else {
                            favoriteBox.delete(spell.spell);
                            Get.snackbar(
                              "Remove!",
                              "${spell.spell} removed from fav list!",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const FavoriteSpellView());
        },
        backgroundColor: const Color(0xFFE8DEF8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tooltip: 'Favorite Spells',
        child: const Icon(Icons.favorite, color: Colors.red),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.offAll(() => const BooksView());
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Books',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef SpellsView = SpellView;
