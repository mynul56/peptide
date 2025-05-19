import 'package:flutter/material.dart';
import '../data/peptide_data.dart';

class PeptideInfoCard extends StatefulWidget {
  const PeptideInfoCard({super.key});

  @override
  State<PeptideInfoCard> createState() => _PeptideInfoCardState();
}

class _PeptideInfoCardState extends State<PeptideInfoCard> {
  String? selectedPeptide;
  PeptideInfo? peptideInfo;

  void _onPeptideSelected(String name) {
    setState(() {
      selectedPeptide = name;
      peptideInfo = peptideData.firstWhere((p) => p.name == name);
    });
  }

  Widget _buildInfoRow(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF32BACF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Geist",
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontFamily: "Geist",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE3E9F5))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.format_list_bulleted, color: Color(0xFF32BACF)),
                SizedBox(width: 7),
                Text(
                  'Peptide Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Geist",
                  ),
                )
              ],
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: selectedPeptide,
              decoration: InputDecoration(
                labelText: 'Select a Peptide',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: peptideData.map((peptide) => DropdownMenuItem(
                value: peptide.name,
                child: Text(peptide.name),
              )).toList(),
              onChanged: (value) => value != null ? _onPeptideSelected(value) : null,
            ),
            if (peptideInfo != null) ...[              
              const SizedBox(height: 20),
              _buildInfoRow(Icons.medical_services_outlined, 'Mechanism', peptideInfo!.mechanism),
              _buildInfoRow(Icons.science_outlined, 'Functionality', peptideInfo!.functionality),
              if (peptideInfo!.dose != null) _buildInfoRow(Icons.timer_outlined, 'Dose', peptideInfo!.dose!),
              if (peptideInfo!.notes != null) _buildInfoRow(Icons.note_outlined, 'Notes', peptideInfo!.notes!),
            ]
          ],
        ),
      ),
    );
  }
}