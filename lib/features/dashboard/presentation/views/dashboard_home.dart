import 'package:flutter/material.dart';

class DashboardHome extends StatefulWidget {
  final VoidCallback? onPetTap;

  const DashboardHome({super.key, this.onPetTap});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final List<Map<String, String>> pets = const [
    {
      'name': 'Biralo',
      'location': 'Kathmandu',
      'image': 'assets/images/catA.jpg',
      'type': 'Cat'
    },
    {
      'name': 'Khaire',
      'location': 'Pokhara',
      'image': 'assets/images/dogA.jpg',
      'type': 'Dog'
    },
    {
      'name': 'Fluffy',
      'location': 'Lalitpur',
      'image': 'assets/images/catB.jpg',
      'type': 'Cat'
    },
    {
      'name': 'Buddy',
      'location': 'Bhaktapur',
      'image': 'assets/images/dogB.jpg',
      'type': 'Dog'
    },
  ];

  final List<String> categories = const ['Cat', 'Dog'];
  String selectedCategory = '';
  String searchQuery = '';

  List<Map<String, String>> get filteredPets {
    return pets.where((pet) {
      final matchesCategory = selectedCategory.isEmpty ||
          pet['type'] == selectedCategory;
      final matchesSearch = searchQuery.isEmpty ||
          pet['name']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          pet['location']!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery
        .of(context)
        .size
        .width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Adoption',
          style: TextStyle(fontFamily: 'Robotoo'),),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildCategories(),
                  const SizedBox(height: 16),
                  Text(
                    'Available Pets (${filteredPets.length})',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      color: Colors.purple[800],
                      fontFamily: 'Robotoo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: filteredPets.isEmpty
                        ? _buildEmptyState()
                        : isTablet
                        ? _buildPetGrid()
                        : _buildPetList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => setState(() => searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Search notification...',
        prefixIcon: const Icon(Icons.search, color: Colors.teal),
        filled: true,
        fillColor: Colors.orangeAccent[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Wrap(
      spacing: 8,
      children: categories.map((category) =>
          ChoiceChip(
            label: Text(category, style: const TextStyle(color: Colors.white)),
            selected: selectedCategory == category,
            selectedColor: Colors.purple,
            backgroundColor: Colors.teal[300],
            onSelected: (_) =>
                setState(() {
                  selectedCategory =
                  selectedCategory == category ? '' : category;
                }),
          )).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 60,
            color: Colors.orange[400],
          ),
          const SizedBox(height: 8),
          Text(
            'No notification found',
            style: TextStyle(
              color: Colors.purple[800],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredPets.length,
      itemBuilder: (context, index) => _buildPetCard(filteredPets[index]),
    );
  }

  Widget _buildPetList() {
    return ListView.builder(
      itemCount: filteredPets.length,
      itemBuilder: (context, index) => _buildPetCard(filteredPets[index]),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.amber[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          widget.onPetTap?.call(); // Switch to PetScreen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected ${pet['name']}'),
              backgroundColor: Colors.teal,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            pet['image']!,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.orange[100],
                child: Icon(
                  pet['type'] == 'Cat' ? Icons.pets : Icons.pets_outlined,
                  color: Colors.purple[800],
                  size: 40,
                ),
              );
            },
          ),
        ),
        title: Text(
          pet['name']!,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.purple,
          ),
        ),
        subtitle: Text(
          pet['location']!,
          style: const TextStyle(
            fontFamily: 'Robotoo',
            fontSize: 14,
            color: Colors.teal,
          ),
        ),
        trailing: Chip(
          label: Text(pet['type']!),
          backgroundColor: Colors.orange[200],
        ),
      ),
    );
  }
}
