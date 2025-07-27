import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_state.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_event.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_state.dart';

class DashboardHome extends StatefulWidget {
  final void Function(PetEntity pet) onPetTap;
  const DashboardHome({required this.onPetTap, super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  String? _typeFilter;
  String? _searchTerm;

  void _fetchPets() {
    final filters = {
      if (_searchTerm != null && _searchTerm!.isNotEmpty) 'search': _searchTerm,
      if (_typeFilter != null) 'type': _typeFilter,
    };

    // 🔍 Debug print for filter tracking
    print('🔎 Fetching pets with filters: $filters');

    context.read<DashboardBloc>().add(FetchPets(filters: filters));
  }

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('🐾 Find Your New Friend'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 3,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search pets by name',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchTerm = val.trim();
                });
              },
              onSubmitted: (_) => _fetchPets(),
              textInputAction: TextInputAction.search,
            ),
          ),
          SizedBox(
            height: 56,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('Dog', Icons.pets),
                const SizedBox(width: 10),
                _buildFilterChip('Cat', Icons.pets_outlined),
                const SizedBox(width: 10),
                _buildFilterChip('Bird', Icons.flutter_dash),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _fetchPets();
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: BlocConsumer<DashboardBloc, DashboardState>(
                listener: (context, state) {
                  if (state is PetsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  } else if (state is PetAdopted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Adoption request sent!')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PetsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PetsLoaded) {
                    final pets = state.pets;

                    // 🐶 Debug print for pet count
                    print('🐶 Loaded pets count: ${pets.length}');

                    if (pets.isEmpty) {
                      return const Center(child: Text('No pets found.'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: pets.length,
                      itemBuilder: (ctx, i) {
                        final pet = pets[i];
                        return PetCard(
                          pet: pet,
                          onTap: () => widget.onPetTap(pet),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Something went wrong.'));
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String type, IconData icon) {
    final selected = _typeFilter == type;
    return ChoiceChip(
      avatar: Icon(icon, color: selected ? Colors.white : Colors.teal),
      label: Text(type),
      selected: selected,
      onSelected: (sel) {
        setState(() => _typeFilter = sel ? type : null);
        _fetchPets();
      },
      selectedColor: Colors.teal,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
    );
  }
}

class PetCard extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onTap;
  const PetCard({required this.pet, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final isAdopted = pet.adopted;
    final authState = context.watch<AuthBloc>().state;
    final userId = authState is AuthProfileUpdated ? authState.user.id : '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/default_profile.png',
                  image: pet.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (_, __, ___) => const Icon(
                    Icons.pets,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.breed}, ${pet.age} yrs • ${pet.sex}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${pet.location}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      pet.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.volunteer_activism),
                          label: Text(isAdopted ? 'Adopted' : 'Adopt'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAdopted ? Colors.grey : Colors.teal,
                          ),
                          onPressed: isAdopted
                              ? null
                              : () {
                            if (userId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please login to adopt')),
                              );
                              return;
                            }
                            context.read<DashboardBloc>().add(
                              AdoptRequested(
                                userId: userId,
                                petId: pet.id,
                                filters: {'type': pet.type},
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('❤️ Favorite feature coming soon!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
