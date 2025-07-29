// features/dashboard/presentation/views/pet_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';
import 'package:petforpat/features/adoption/presentation/views/adoption.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_event.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_state.dart';
import 'package:petforpat/features/favorite/presentation/views/favorite_screen.dart';

class PetDetailPage extends StatelessWidget {
  final String petId;

  const PetDetailPage({super.key, required this.petId});

  String getFullImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return imageUrl;
    }
    return 'http://192.168.10.70:3001$imageUrl';
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PetDetailBloc>()..add(LoadPetDetailEvent(petId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pet Details"),
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              tooltip: "Favorites",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoriteScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.pets),
              tooltip: "Adoption",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdoptionScreen()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<PetDetailBloc, PetDetailState>(
          builder: (context, state) {
            if (state is PetDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PetDetailError) {
              return Center(child: Text("Error: ${state.message}"));
            } else if (state is PetDetailLoaded) {
              final pet = state.pet;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        getFullImageUrl(pet.imageUrl),
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: double.infinity,
                          height: 240,
                          color: Colors.grey.shade300,
                          child: const Center(child: Icon(Icons.error)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        pet.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(Icons.pets, "Breed", pet.breed),
                    _buildInfoRow(Icons.cake, "Age", '${pet.age} years'),
                    _buildInfoRow(Icons.location_on, "Location", pet.location),
                    _buildInfoRow(Icons.info_outline, "Description", pet.description),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () {
                            // TODO: Implement favorite logic or event
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Added to Favorites!")),
                            );
                          },
                          icon: const Icon(Icons.favorite_border),
                          label: const Text("Favorite"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AdoptionScreen()),
                            );
                          },
                          icon: const Icon(Icons.pets),
                          label: const Text("Adopt"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
