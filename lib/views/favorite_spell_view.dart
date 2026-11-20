import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spell_model.dart';
import '../services/notification_service.dart';

class FavoriteSpellView extends StatelessWidget {
  const FavoriteSpellView({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<SpellModel> box = Hive.box<SpellModel>('favorite_spells');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Spell'),
      ),
      body: ValueListenableBuilder<Box<SpellModel>>(
        valueListenable: box.listenable(),
        builder: (context, favoriteBox, _) {
          final favoriteSpells = favoriteBox.values.toList();

          if (favoriteSpells.isEmpty) {
            return const Center(
              child: Text(
                'No favorite spells yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: favoriteSpells.length,
            itemBuilder: (context, index) {
              final spell = favoriteSpells[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete favorite',
                    onPressed: () async {
                      await favoriteBox.delete(spell.spell);
                      await NotificationService().showDeleteNotification(spell.spell);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
