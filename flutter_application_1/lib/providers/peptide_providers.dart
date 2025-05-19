import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/peptide_data.dart';

/// Provider for the list of all peptides
final peptideListProvider = Provider<List<PeptideInfo>>((ref) {
  return peptideData;
});

/// Provider for the search query
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for filtered peptides based on search query
final filteredPeptidesProvider = Provider<List<PeptideInfo>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final peptides = ref.watch(peptideListProvider);
  
  if (query.isEmpty) return peptides;
  
  return peptides.where((peptide) {
    final searchLower = query.toLowerCase();
    return peptide.name.toLowerCase().contains(searchLower) ||
           peptide.description.toLowerCase().contains(searchLower);
  }).toList();
});

/// Provider for the selected peptide
final selectedPeptideProvider = StateProvider<PeptideInfo?>((ref) => null);

/// Provider for the theme mode
final darkModeProvider = StateProvider<bool>((ref) => false);