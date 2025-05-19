import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorForm extends StatefulWidget {
  final void Function(double unitsToDraw, int dosesPerVial)? onCalculate;
  final void Function(Map<String, dynamic> historyEntry)? onHistoryUsed;

  const CalculatorForm({
    Key? key,
    this.onCalculate,
    this.onHistoryUsed,
  }) : super(key: key);

  @override
  State<CalculatorForm> createState() => _CalculatorFormState();
}

class _CalculatorFormState extends State<CalculatorForm> {
  final _vialController = TextEditingController();
  final _diluentController = TextEditingController();
  final _doseController = TextEditingController();
  String _doseUnit = "mcg";
  double? _lastUnits;
  int? _lastDoses;
  double? _remainingAmount;
  String? _errorMessage;

  @override
  void dispose() {
    _vialController.dispose();
    _diluentController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  Future<void> _saveToHistory(String input, String result) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('calc_history') ?? [];
    final entry = "input=$input&result=$result";
    history.add(entry);
    await prefs.setStringList('calc_history', history);
  }

  void _showResultCardPopup(double units, int doses, double? remainingAmount) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).cardColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: _ResultCard(
              units: units,
              doses: doses,
              remainingAmount: remainingAmount,
            ),
          ),
        ),
      ),
    );
  }

  void _doCalculate() {
    final vialText = _vialController.text.trim();
    final diluentText = _diluentController.text.trim();
    final doseText = _doseController.text.trim();

    if (vialText.isEmpty || diluentText.isEmpty || doseText.isEmpty) {
      setState(() {
        _lastUnits = null;
        _lastDoses = null;
      });
      return;
    }

    final vialMg = double.tryParse(vialText);
    final diluentMl = double.tryParse(diluentText);
    double? desiredDose = double.tryParse(doseText);

    if (vialMg == null || diluentMl == null || desiredDose == null) {
      setState(() {
        _errorMessage = "Please enter valid numbers";
        _lastUnits = null;
        _lastDoses = null;
        _remainingAmount = null;
      });
      return;
    }

    if (vialMg <= 0 || vialMg > 1000) {
      setState(() {
        _errorMessage = "Vial strength must be between 0 and 1000 mg";
        _lastUnits = null;
        _lastDoses = null;
        _remainingAmount = null;
      });
      return;
    }

    if (diluentMl <= 0 || diluentMl > 100) {
      setState(() {
        _errorMessage = "Diluent amount must be between 0 and 100 ml";
        _lastUnits = null;
        _lastDoses = null;
        _remainingAmount = null;
      });
      return;
    }

    if (desiredDose <= 0) {
      setState(() {
        _errorMessage = "Desired dose must be greater than 0";
        _lastUnits = null;
        _lastDoses = null;
        _remainingAmount = null;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    // Convert mcg to mg if needed
    if (_doseUnit == "mcg") {
      desiredDose = desiredDose / 1000;
    }

    // Calculation logic
    final mgPerML = vialMg / diluentMl;
    final mlDose = desiredDose / mgPerML;
    final units = mlDose * 100;
    final dosesAvailable = (vialMg / desiredDose).floor();

    // Calculate remaining amount
    final totalDoseInMg = vialMg;
    final usedDoseInMg = desiredDose * dosesAvailable;
    final remainingInMg = totalDoseInMg - usedDoseInMg;

    setState(() {
      _lastUnits = units;
      _lastDoses = dosesAvailable;
      _remainingAmount = remainingInMg;
    });

    widget.onCalculate?.call(units, dosesAvailable);

    // Save calculation to history
    final inputSummary =
        'Vial: $vialMg mg, Diluent: $diluentMl ml, Dose: $doseText $_doseUnit';
    final resultSummary =
        'Units: ${units.toStringAsFixed(2)}, Doses: $dosesAvailable';
    _saveToHistory(inputSummary, resultSummary);

    // Show result popup
    _showResultCardPopup(units, dosesAvailable, remainingInMg);
  }

  void _useHistoryEntry(Map<String, dynamic> entry) {
    final input = entry['input'] ?? "";
    final vialReg = RegExp(r'Vial: ([\d\.]+) mg');
    final diluentReg = RegExp(r'Diluent: ([\d\.]+) ml');
    final doseReg = RegExp(r'Dose: ([\d\.]+) (mcg|mg)');

    final vialMatch = vialReg.firstMatch(input);
    final diluentMatch = diluentReg.firstMatch(input);
    final doseMatch = doseReg.firstMatch(input);

    if (vialMatch != null) {
      _vialController.text = vialMatch.group(1) ?? '';
    }
    if (diluentMatch != null) {
      _diluentController.text = diluentMatch.group(1) ?? '';
    }
    if (doseMatch != null) {
      _doseController.text = doseMatch.group(1) ?? '';
      setState(() {
        _doseUnit = doseMatch.group(2) ?? "mcg";
      });
    }
    _doCalculate();
    widget.onHistoryUsed?.call(entry);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).cardColor;
    final borderColor =
        Theme.of(context).colorScheme.primary.withOpacity(0.2);
    final borderRadius = BorderRadius.circular(12);
    final fieldFillColor = isDark ? const Color(0xFF232526) : Colors.white;
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor, width: 1.5),
    );

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: borderColor),
      ),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.balance,
                    color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 7),
                Text(
                  'Calculator',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Geist",
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontFamily: "Geist",
                  ),
                ),
              ),
            TextField(
              controller: _vialController,
              decoration: InputDecoration(
                labelText: "Vial Strength (mg)",
                hintText: "e.g., 10 (0-1000 mg)",
                prefixIcon: const Icon(Icons.science_outlined,
                    color: Color(0xFF32BACF)),
                border: fieldBorder,
                enabledBorder: fieldBorder,
                focusedBorder: fieldBorder.copyWith(
                  borderSide:
                      const BorderSide(color: Color(0xFF32BACF), width: 2),
                ),
                isDense: true,
                filled: true,
                fillColor: fieldFillColor,
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _diluentController,
              decoration: InputDecoration(
                labelText: "Diluent Amount (ml)",
                hintText: "e.g., 2 (0-100 ml)",
                prefixIcon: const Icon(Icons.local_fire_department_outlined,
                    color: Color(0xFF32BACF)),
                border: fieldBorder,
                enabledBorder: fieldBorder,
                focusedBorder: fieldBorder.copyWith(
                  borderSide:
                      const BorderSide(color: Color(0xFF32BACF), width: 2),
                ),
                isDense: true,
                filled: true,
                fillColor: fieldFillColor,
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: _doseController,
                    decoration: InputDecoration(
                      labelText: "Desired Dose",
                      hintText: "e.g., 250",
                      prefixIcon: const Icon(Icons.edit_road_outlined,
                          color: Color(0xFF32BACF)),
                      border: fieldBorder,
                      enabledBorder: fieldBorder,
                      focusedBorder: fieldBorder.copyWith(
                        borderSide: const BorderSide(
                            color: Color(0xFF32BACF), width: 2),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: fieldFillColor,
                      labelStyle: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => _doCalculate(),
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _doseUnit,
                    decoration: InputDecoration(
                      border: fieldBorder,
                      enabledBorder: fieldBorder,
                      focusedBorder: fieldBorder.copyWith(
                        borderSide: const BorderSide(
                            color: Color(0xFF32BACF), width: 2),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: fieldFillColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      labelStyle: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    dropdownColor: fieldFillColor,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Geist",
                    ),
                    items: const [
                      DropdownMenuItem(
                        child: Text("mcg"),
                        value: "mcg",
                      ),
                      DropdownMenuItem(
                        child: Text("mg"),
                        value: "mg",
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _doseUnit = v;
                        });
                        _doCalculate();
                      }
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF32BACF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Geist"),
                  shadowColor: Colors.transparent,
                  elevation: 0,
                ),
                onPressed: _doCalculate,
                child: const Text("Calculate"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final double units;
  final int doses;
  final double? remainingAmount;

  const _ResultCard({
    required this.units,
    required this.doses,
    this.remainingAmount,
  });

  @override
  Widget build(BuildContext context) {
    final int unitsInt = units.round();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.medical_services_rounded,
                    color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 7),
                Text(
                  'Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Geist",
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1A1A1A),
                    fontFamily: "Geist",
                  ),
                  children: [
                    TextSpan(
                      text: "Inject: ",
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
                    TextSpan(
                      text: "$unitsInt",
                      style: const TextStyle(
                        color: Color(0xFF32BACF),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: " units on a 100-unit syringe.",
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 10),
            Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : const Color(0xFF727272),
                    fontFamily: "Geist",
                  ),
                  children: [
                    TextSpan(text: "Doses Available: "),
                    TextSpan(
                      text: "$doses",
                      style: const TextStyle(
                        color: Color(0xFF32BACF),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    TextSpan(text: " full doses per vial."),
                  ],
                ),
              ),
            ),
            if (remainingAmount != null) ...[
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : const Color(0xFF727272),
                      fontFamily: "Geist",
                    ),
                    children: [
                      const TextSpan(text: "Remaining Amount: "),
                      TextSpan(
                        text:
                            "${remainingAmount?.toStringAsFixed(2) ?? '0.00'} mg",
                        style: const TextStyle(
                          color: Color(0xFF32BACF),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const TextSpan(text: " in vial."),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 22),
            _SyringeImage(units: unitsInt),
          ],
        ),
      ),
    );
  }
}

class _SyringeImage extends StatelessWidget {
  final int units;

  const _SyringeImage({required this.units});

  @override
  Widget build(BuildContext context) {
    final double fillLevel = (units.clamp(0, 100)) / 100.0;
    return Column(
      children: [
        SizedBox(
          height: 96,
          width: 44,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Syringe outline
              Container(
                height: 96,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFB3B3B3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomPaint(
                  painter: _SyringeTicksPainter(),
                ),
              ),
              // Fill
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 96 * fillLevel,
                  width: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFF32BACF),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "$units Units",
          style: const TextStyle(
              color: Color(0xFF32BACF),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: "Geist"),
        ),
      ],
    );
  }
}

class _SyringeTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB3B3B3)
      ..strokeWidth = 1.2;
    for (int i = 1; i < 10; i++) {
      final y = size.height * i / 10;
      canvas.drawLine(Offset(8, y), Offset(size.width - 8, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}