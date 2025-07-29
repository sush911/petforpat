import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';
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
    context.read<PetBloc>().add(LoadPetsEvent());
    _searchController.addListener(_triggerSearch); // Listen as user types
  }

  @override
  void dispose() {
    _searchController.removeListener(_triggerSearch);
    _searchController.dispose();
    super.dispose();
  }

  String getFullImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http')) return imageUrl;
    return 'http://192.168.10.70:3001$imageUrl';
  }

  void _triggerSearch() {
    context.read<PetBloc>().add(
      LoadPetsEvent(
        search: _searchController.text,
        category: selectedCategory != 'All' ? selectedCategory : null,
      ),
    );
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
      'Bird': Icons.travel_explore, // Replace with bird icon if you have one
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Dashboard'),
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
                  hintText: 'Search pets...',
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

            // Category chips with icons
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
                        _triggerSearch();
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

            Expanded(
              child: BlocBuilder<PetBloc, PetState>(
                builder: (context, state) {
                  if (state is PetLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is PetError) {
                    return Center(
                      child: Text(state.message, style: const TextStyle(color: Colors.red)),
                    );
                  }
                  if (state is PetLoaded) {
                    if (state.pets.isEmpty) {
                      return const Center(child: Text("No pets found."));
                    }

                    return RefreshIndicator(
                      color: Colors.teal,
                      onRefresh: () async {
                        context.read<PetBloc>().add(LoadPetsEvent(
                          search: _searchController.text,
                          category: selectedCategory != 'All' ? selectedCategory : null,
                          forceRefresh: true,
                        ));
                        await context.read<PetBloc>().stream.firstWhere((s) => s is! PetLoading);
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
                                PageRouteBuilder(
                                  pageBuilder: (_, anim1, __) => FadeTransition(
                                    opacity: anim1,
                                    child: PetDetailPage(petId: pet.id),
                                  ),
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
                                            Text(pet.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal,
                                                )),
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
                                    const Padding(
                                      padding: EdgeInsets.only(right: 12),
                                      child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
