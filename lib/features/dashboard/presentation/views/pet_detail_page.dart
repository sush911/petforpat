import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_state.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_event.dart';

class PetDetailPage extends StatelessWidget {
  final PetEntity pet;
  final String? userId;

  const PetDetailPage({super.key, required this.pet, this.userId});

  @override
  Widget build(BuildContext context) {
    final isAdopted = pet.adopted;

    debugPrint('🐾 Opening detail page for pet: ${pet.name}');
    debugPrint('👤 Received userId: $userId');

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: pet.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                pet.imageUrl,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 100),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pet.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${pet.breed}, ${pet.age} yrs old • ${pet.sex}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            '📍 ${pet.location}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Text(
            pet.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.volunteer_activism),
                  label: Text(isAdopted ? 'Already Adopted' : 'Adopt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAdopted ? Colors.grey : Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: isAdopted
                      ? null
                      : () {
                    final effectiveUserId = userId ?? _getUserIdFromBloc(context);

                    if (effectiveUserId == null || effectiveUserId.isEmpty) {
                      debugPrint('❌ [Adopt] No userId found — user must log in');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('❌ Please login to adopt this pet')),
                      );
                      return;
                    }

                    debugPrint('✅ [Adopt] User $effectiveUserId is adopting ${pet.name}');

                    context.read<DashboardBloc>().add(
                      AdoptRequested(
                        userId: effectiveUserId,
                        petId: pet.id,
                        filters: {'type': pet.type},
                      ),
                    );

                    Navigator.pop(context);
                  },

                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('❤️ Added to favorites (not yet implemented)')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Tries to read the userId directly from AuthBloc if not passed
  String? _getUserIdFromBloc(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthProfileUpdated) {
      debugPrint('🧠 Fallback: Extracted user ID from AuthBloc: ${authState.user.id}');
      return authState.user.id;
    }
    debugPrint('⚠️ Fallback failed: No user found in AuthBloc');
    return null;
  }
}
