import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/auth/domain/entities/user_entity.dart'; // Import user entity
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_state.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_event.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_state.dart';
import 'pet_detail_page.dart';

class DashboardHome extends StatefulWidget {
  final UserEntity user;  // Add user here

  const DashboardHome({super.key, required this.user});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  String? _typeFilter;
  String? _searchTerm;

  String get _userId => widget.user.id;  // Access user ID from passed user

  @override
  void initState() {
    super.initState();
    debugPrint('🟢 [initState] Received user ID: $_userId');
    _fetchPets();
  }

  void _fetchPets() {
    final filters = {
      if (_searchTerm != null && _searchTerm!.isNotEmpty) 'search': _searchTerm,
      if (_typeFilter != null) 'type': _typeFilter,
    };

    debugPrint('🔍 [fetchPets] Fetching pets with filters: $filters');
    context.read<DashboardBloc>().add(FetchPets(filters: filters));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileUpdated) {
          debugPrint('🟢 [AuthBloc] User profile updated with ID: ${state.user.id}');
          // Optionally update userId if you want to sync auth changes,
          // but currently using widget.user directly
        } else if (state is AuthInitial || state is AuthError) {
          debugPrint('🔴 [AuthBloc] User logged out or error state: $state');
          // You may want to handle logout here if needed
        }
      },
      child: Scaffold(
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
                  setState(() => _searchTerm = val.trim());
                  debugPrint('🔠 [Search] Search term changed: $_searchTerm');
                },
                onSubmitted: (_) {
                  debugPrint('🔍 [Search] Search submitted: $_searchTerm');
                  _fetchPets();
                },
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
                  debugPrint('🔄 [Refresh] Pull-to-refresh triggered');
                  _fetchPets();
                  await Future.delayed(const Duration(milliseconds: 300));
                },
                child: BlocConsumer<DashboardBloc, DashboardState>(
                  listener: (context, state) {
                    if (state is PetsError) {
                      debugPrint('❌ [DashboardBloc] PetsError: ${state.message}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
                      );
                    } else if (state is PetAdopted) {
                      debugPrint('✅ [DashboardBloc] Adoption confirmed');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Adoption request sent!')),
                      );
                      _fetchPets();
                    }
                  },
                  builder: (context, state) {
                    if (state is PetsLoading) {
                      debugPrint('⏳ [DashboardBloc] Pets are loading...');
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PetsLoaded) {
                      final pets = state.pets;
                      debugPrint('📦 [DashboardBloc] Pets loaded: ${pets.length}');
                      if (pets.isEmpty) return const Center(child: Text('No pets found.'));

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: pets.length,
                        itemBuilder: (ctx, i) {
                          final pet = pets[i];
                          debugPrint('🐶 [DashboardBloc] Showing pet: ${pet.name}, ID: ${pet.id}');
                          return PetCard(
                            pet: pet,
                            onTap: () {
                              if (_userId.isEmpty) {
                                debugPrint('❌ [Navigation] User ID is empty, cannot navigate to details');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please login to view details')),
                                );
                                return;
                              }

                              debugPrint('➡️ [Navigation] Navigating to details of ${pet.name} with userId $_userId');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PetDetailPage(pet: pet, userId: _userId),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      debugPrint('❓ [DashboardBloc] Unexpected state: $state');
                      return const Center(child: Text('Something went wrong.'));
                    }
                  },
                ),
              ),
            )
          ],
        ),
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
        debugPrint('📁 [Filter] Filter selected: $_typeFilter');
        _fetchPets();
      },
      selectedColor: Colors.teal,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
    );
  }
}

// ✅ PetCard must be defined outside the state class
class PetCard extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onTap;

  const PetCard({
    required this.pet,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isAdopted = pet.adopted;

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
                child: Image.network(
                  pet.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 80, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pet.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text('${pet.breed}, ${pet.age} yrs • ${pet.sex}',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text('📍 ${pet.location}', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(isAdopted ? 'Adopted' : 'Available',
                        style: TextStyle(
                          color: isAdopted ? Colors.redAccent : Colors.green,
                          fontWeight: FontWeight.bold,
                        )),
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
