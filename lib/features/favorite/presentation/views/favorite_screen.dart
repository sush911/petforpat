import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/views/pet_detail_page.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_cubit.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_state.dart';
import 'package:petforpat/app/theme/theme_cubit.dart';

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

  void _triggerSearch() => _loadFilteredFavorites();

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
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        actions: [
          IconButton(
            tooltip: isDark ? 'Light Mode' : 'Dark Mode',
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () => themeCubit.toggleTheme(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search favorites...',
                  prefixIcon: Icon(Icons.search, color: Colors.teal.shade700),
                  filled: true,
                  fillColor: Colors.teal.shade50.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Category Chips
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
                      backgroundColor: Colors.grey.shade300,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.teal.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const Divider(),

            // Pet Cards
            Expanded(
              child: BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  if (state.loading) return const Center(child: CircularProgressIndicator());
                  if (state.error != null) return Center(child: Text(state.error!));
                  if (state.pets.isEmpty) return const Center(child: Text('No favorites yet.'));

                  return RefreshIndicator(
                    onRefresh: () async => _loadFilteredFavorites(),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: isTablet ? 1.4 : 0.95,
                      ),
                      itemCount: state.pets.length,
                      itemBuilder: (_, index) {
                        final pet = state.pets[index];
                        final imageTag = 'petImage_${pet.id}';

                        return Hero(
                          tag: imageTag,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PetDetailPage(petId: pet.id),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isDark ? Colors.tealAccent : Colors.teal.shade400,
                                    width: 1.5,
                                  ),
                                  color: Theme.of(context).cardColor.withOpacity(0.92),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                      child: Stack(
                                        children: [
                                          Image.network(
                                            getFullImageUrl(pet.imageUrl),
                                            height: isTablet ? 180 : 160,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              height: 160,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.error),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                                              child: Container(color: Colors.black12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pet.name,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal.shade800,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.pets, size: 16, color: Colors.teal),
                                              const SizedBox(width: 4),
                                              Text("${pet.breed} • ${pet.age} yrs"),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(pet.location, overflow: TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              tooltip: 'Remove from favorites',
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () {
                                                context.read<FavoriteCubit>().toggleFavorite(pet);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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

