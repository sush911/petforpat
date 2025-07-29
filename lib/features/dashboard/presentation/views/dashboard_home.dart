// features/dashboard/presentation/views/dashboard_home.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_event.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_state.dart';
import 'package:petforpat/features/dashboard/presentation/views/pet_detail_page.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Load initial pets on screen load
    context.read<PetBloc>().add(LoadPetsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String getFullImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return imageUrl;
    }
    return 'http://192.168.10.70:3001$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Dashboard"),
        backgroundColor: Colors.teal,
        elevation: 4,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildCategoryFilter(context),
          Expanded(child: _buildPetList(context)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search pets...",
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.teal.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: (_) => _searchPets(),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            onPressed: _searchPets,
            child: const Text("Go", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _searchPets() {
    context.read<PetBloc>().add(
      LoadPetsEvent(
        search: _searchController.text,
        category: selectedCategory != 'All' ? selectedCategory : null,
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final categories = ['All', 'Dog', 'Cat', 'Bird'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final category = categories[i];
          final isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ChoiceChip(
              label: Text(category,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.teal,
                      fontWeight: FontWeight.w600)),
              selected: isSelected,
              selectedColor: Colors.teal,
              backgroundColor: Colors.teal.shade50,
              onSelected: (_) {
                setState(() {
                  selectedCategory = category;
                });
                _searchPets();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPetList(BuildContext context) {
    return BlocBuilder<PetBloc, PetState>(
      builder: (context, state) {
        if (state is PetLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PetError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        } else if (state is PetLoaded) {
          if (state.pets.isEmpty) {
            return const Center(child: Text("No pets found."));
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<PetBloc>().add(
                LoadPetsEvent(
                  search: _searchController.text,
                  category: selectedCategory != 'All' ? selectedCategory : null,
                  forceRefresh: true,
                ),
              );
              await context.read<PetBloc>().stream.firstWhere(
                    (state) => state is! PetLoading,
              );
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.pets.length,
              itemBuilder: (context, i) {
                final pet = state.pets[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PetDetailPage(petId: pet.id),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                          child: Image.network(
                            getFullImageUrl(pet.imageUrl),
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: Colors.grey.shade300, width: 110, height: 110),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet.name,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.pets, size: 18, color: Colors.teal),
                                    const SizedBox(width: 6),
                                    Text(pet.breed, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 14),
                                    const Icon(Icons.cake, size: 18, color: Colors.teal),
                                    const SizedBox(width: 6),
                                    Text('${pet.age} yrs'),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 18, color: Colors.teal),
                                    const SizedBox(width: 6),
                                    Text(pet.location),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 14),
                          child: Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 18),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
