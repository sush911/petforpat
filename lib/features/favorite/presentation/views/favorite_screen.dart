import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/views/pet_detail_page.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_cubit.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_state.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<FavoriteCubit>()..loadFavorites(), // Use existing cubit instance
      child: Scaffold(
        appBar: AppBar(title: const Text('Favorites'), backgroundColor: Colors.teal),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state.loading) return const Center(child: CircularProgressIndicator());
            if (state.error != null) return Center(child: Text(state.error!));
            if (state.pets.isEmpty) return const Center(child: Text('No favorites yet.'));
            final pets = state.pets;
            final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

            return RefreshIndicator(
              onRefresh: () => context.read<FavoriteCubit>().loadFavorites(),
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 2 : 1,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: isTablet ? 4.5 : 3,
                ),
                itemCount: pets.length,
                itemBuilder: (_, i) {
                  final pet = pets[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PetDetailPage(petId: pet.id)),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                            child: Image.network(
                              pet.imageUrl.startsWith('http') ? pet.imageUrl : 'http://192.168.10.70:3001${pet.imageUrl}',
                              width: isTablet ? 150 : 100,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: Colors.grey.shade300, child: const Icon(Icons.error)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pet.name,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                                  const SizedBox(height: 4),
                                  Text('${pet.breed} • ${pet.age} yrs', style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text(pet.location, style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Remove from favorites',
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => context.read<FavoriteCubit>().toggleFavorite(pet),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
