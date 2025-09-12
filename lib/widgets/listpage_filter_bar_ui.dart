import 'package:flutter/material.dart';

class ListPageFilterBarUIWidget extends StatelessWidget {
  final TextEditingController searchController;
  final IconButton searchButton;
  const ListPageFilterBarUIWidget({super.key, required this.searchController, required this.searchButton});

  @override
  Widget build(BuildContext context) {
    return getFilterBarUI();
  }

  Widget getFilterBarUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(        
        // Add padding around the search bar
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        // Use a Material design search bar
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintText: 'Search...',
            // Add a clear button to the search bar
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => searchController.clear(),
                ),
                searchButton,                
              ],
            ),
            // Add a search icon or button to the search bar
            prefixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Perform the search here
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}
