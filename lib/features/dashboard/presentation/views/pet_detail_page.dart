import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';
import 'package:petforpat/features/adoption/presentation/views/adoption_screen.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_event.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_state.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_cubit.dart';
import 'package:petforpat/features/favorite/presentation/views/favorite_screen.dart';

class PetDetailPage extends StatefulWidget {
  final String petId;

  const PetDetailPage({super.key, required this.petId});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  bool isFavorite = false;

  String getFullImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return imageUrl;
    }
    return 'http://192.168.10.69:3001$imageUrl';
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required bool isTablet,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.teal, size: isTablet ? 32 : 24),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isTablet ? 20 : 16,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: isTablet ? 18 : 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final imageHeight = isTablet ? 400.0 : 280.0;
    final sidePadding = isTablet ? 32.0 : 20.0;
    final buttonPadding = isTablet
        ? const EdgeInsets.symmetric(horizontal: 36, vertical: 18)
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 14);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
          sl<PetDetailBloc>()..add(LoadPetDetailEvent(widget.petId)),
        ),
        BlocProvider.value(
          value: context.read<FavoriteCubit>(),
        ),
      ],
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
                // We don’t have pet info here, better not navigate without pet details.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please open a pet detail to adopt!',
                    ),
                  ),
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

              return FutureBuilder<bool>(
                future: context.read<FavoriteCubit>().isFavorite(pet.id),
                builder: (context, snapshot) {
                  isFavorite = snapshot.data ?? false;

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(sidePadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Hero(
                          tag: pet.imageUrl,
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                getFullImageUrl(pet.imageUrl),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.error, size: 50),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isTablet ? 32 : 24),
                        Center(
                          child: Text(
                            pet.name,
                            style: TextStyle(
                              fontSize: isTablet ? 36 : 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        SizedBox(height: isTablet ? 28 : 20),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isTablet ? 24 : 16),
                            child: Column(
                              children: [
                                _buildInfoTile(
                                  icon: Icons.pets,
                                  title: "Breed",
                                  value: pet.breed,
                                  isTablet: isTablet,
                                ),
                                _buildInfoTile(
                                  icon: Icons.cake,
                                  title: "Age",
                                  value: '${pet.age} years',
                                  isTablet: isTablet,
                                ),
                                _buildInfoTile(
                                  icon: Icons.male,
                                  title: "Sex",
                                  value: pet.sex,
                                  isTablet: isTablet,
                                ),
                                _buildInfoTile(
                                  icon: Icons.location_on,
                                  title: "Location",
                                  value: pet.location,
                                  isTablet: isTablet,
                                ),
                                _buildInfoTile(
                                  icon: Icons.phone,
                                  title: "Owner Contact",
                                  value: pet.ownerPhoneNumber,
                                  isTablet: isTablet,
                                ),
                                const Divider(height: 30),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "About",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isTablet ? 22 : 18,
                                    ),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 14 : 10),
                                Text(
                                  pet.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: isTablet ? 18 : 14),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isTablet ? 36 : 30),

                        /// Favorite and Adopt Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: buttonPadding,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                await context
                                    .read<FavoriteCubit>()
                                    .toggleFavorite(pet);
                                final newStatus = await context
                                    .read<FavoriteCubit>()
                                    .isFavorite(pet.id);
                                setState(() {
                                  isFavorite = newStatus;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? "Added to Favorites!"
                                          : "Removed from Favorites!",
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.white,
                              ),
                              label: const Text("Favorite"),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: buttonPadding,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AdoptionScreen(
                                      petId: pet.id,
                                      petName: pet.name,
                                      petType: pet.type, // or pet.petType if that's the field
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.pets),
                              label: const Text("Adopt"),
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 28 : 20),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}


