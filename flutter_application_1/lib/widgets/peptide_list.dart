import 'package:flutter/material.dart';
import '../data/peptide_data.dart';

class PeptideList extends StatefulWidget {
  const PeptideList({super.key});

  @override
  State<PeptideList> createState() => _PeptideListState();
}

class _PeptideListState extends State<PeptideList> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    final filtered = peptideData.where((p) =>
      p.name.toLowerCase().contains(_search.toLowerCase()) ||
      (p.description.toLowerCase().contains(_search.toLowerCase()))
    ).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Peptide Info", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: "Search peptides...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                ? const Center(child: Text("No peptides found."))
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final peptide = filtered[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ExpansionTile(
                          title: Text(peptide.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(peptide.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('How it Works:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(peptide.mechanism),
                                  const SizedBox(height: 12),
                                  const Text('Functionality:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(peptide.functionality),
                                  if (peptide.dose != null) ...[                                    
                                    const SizedBox(height: 12),
                                    Text('Typical Dose:', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(peptide.dose!),
                                  ],
                                  if (peptide.notes != null) ...[                                    
                                    const SizedBox(height: 12),
                                    Text('Additional Notes:', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(peptide.notes!),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}