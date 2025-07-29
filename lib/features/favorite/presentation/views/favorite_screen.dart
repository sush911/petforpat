import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/views/pet_detail_page.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_cubit.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_state.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_triggerSearch);
    _loadFilteredFavorites();
  }

  @override
  void dispose() {
    _searchController.removeListener(_triggerSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    _loadFilteredFavorites();
  }

  void _loadFilteredFavorites() {
    context.read<FavoriteCubit>().loadFavorites(
      category: selectedCategory != 'All' ? selectedCategory : null,
      search: _searchController.text,
    );
  }

  String getFullImageUrl(String imageUrl) {
    return imageUrl.startsWith('http')
        ? imageUrl
        : 'http://192.168.10.70:3001$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final crossAxisCount = isTablet ? 2 : 1;
    final cardHeight = isTablet ? 180.0 : 110.0;
    final imageWidth = isTablet ? 180.0 : 100.0;

    final Map<String, IconData?> categoryIcons = {
      'All': null,
      'Dog': Icons.pets,
      'Cat': Icons.pets,
      'Bird': Icons.travel_explore,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search favorites...',
                  prefixIcon: Icon(Icons.search, color: Colors.teal.shade700),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Category filter chips
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: categoryIcons.keys.map((category) {
                  final selected = category == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (categoryIcons[category] != null) ...[
                            Icon(categoryIcons[category], size: 18),
                            const SizedBox(width: 4),
                          ],
                          Text(category),
                        ],
                      ),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = category;
                        });
                        _loadFilteredFavorites();
                      },
                      selectedColor: Colors.teal,
                      backgroundColor: Colors.grey.shade200,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const Divider(height: 1),

            // Pet cards
            Expanded(
              child: BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null) {
                    return Center(child: Text(state.error!));
                  }
                  if (state.pets.isEmpty) {
                    return const Center(child: Text('No favorites yet.'));
                  }

                  return RefreshIndicator(
                    color: Colors.teal,
                    onRefresh: () async {
                      await context.read<FavoriteCubit>().loadFavorites(
                        category: selectedCategory != 'All' ? selectedCategory : null,
                        search: _searchController.text,
                      );
                    },
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 12,
                        vertical: isTablet ? 16 : 12,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isTablet ? 4.5 : 3,
                      ),
                      itemCount: state.pets.length,
                      itemBuilder: (_, index) {
                        final pet = state.pets[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PetDetailPage(petId: pet.id),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 3,
                            child: SizedBox(
                              height: cardHeight,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      getFullImageUrl(pet.imageUrl),
                                      width: imageWidth,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: imageWidth,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.error),
                                      ),
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
                                          Text(
                                            pet.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text("${pet.breed} • ${pet.age} yrs",
                                              style: const TextStyle(fontSize: 14)),
                                          const SizedBox(height: 4),
                                          Text(pet.location,
                                              style: const TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove from favorites',
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      context.read<FavoriteCubit>().toggleFavorite(pet);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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


