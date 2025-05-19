import 'package:flutter/material.dart';

class CalculatorForm extends StatefulWidget {
  final void Function(double unitsToDraw, int dosesPerVial)? onCalculate;

  const CalculatorForm({super.key, this.onCalculate});

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
  bool _showResults = false;

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
      _errorMessage = null;
      _lastUnits = units;
      _lastDoses = dosesAvailable;
      _remainingAmount = remainingInMg;
      _showResults = true;
    });

    widget.onCalculate?.call(units, dosesAvailable);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE3E9F5)),
          ),
          margin: EdgeInsets.zero,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.balance, color: Color(0xFF32BACF)),
                    SizedBox(width: 7),
                    Text(
                      'Calculator',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Geist",
                        color: Color(0xFF1A1A1A),
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
                  decoration: const InputDecoration(
                    labelText: "Vial Strength (mg)",
                    hintText: "e.g., 10 (0-1000 mg)",
                    prefixIcon: Icon(Icons.science_outlined, color: Color(0xFF32BACF)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFFE3E9F5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFF32BACF)),
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _diluentController,
                  decoration: const InputDecoration(
                    labelText: "Diluent Amount (ml)",
                    hintText: "e.g., 2 (0-100 ml)",
                    prefixIcon: Icon(Icons.local_fire_department_outlined, color: Color(0xFF32BACF)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFFE3E9F5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFF32BACF)),
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: _doseController,
                        decoration: const InputDecoration(
                          labelText: "Desired Dose",
                          hintText: "e.g., 250",
                          prefixIcon: Icon(Icons.edit_road_outlined, color: Color(0xFF32BACF)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Color(0xFFE3E9F5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Color(0xFF32BACF)),
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => _doCalculate(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _doseUnit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Color(0xFFE3E9F5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Color(0xFF32BACF)),
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(child: Text("mcg"), value: "mcg"),
                          DropdownMenuItem(child: Text("mg"), value: "mg"),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: "Geist"),
                      shadowColor: Colors.transparent,
                      elevation: 0,
                    ),
                    onPressed: _doCalculate,
                    child: const Text("Calculate"),
                  ),
                )
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),
        if (_showResults && _lastUnits != null && _lastDoses != null)
          _ResultCard(
            units: _lastUnits!,
            doses: _lastDoses!,
            remainingAmount: _remainingAmount,
          ),
      ],
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE3E9F5)),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.medical_services_rounded, color: Color(0xFF32BACF)),
                SizedBox(width: 7),
                Text(
                      'Results',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Geist",
                        color: Color(0xFF1A1A1A),
                      ),
                    )
              ],
            ),
            const SizedBox(height: 18),
            Center(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: "Geist",
                  ),
                  children: [
                    const TextSpan(text: "Inject: "),
                    TextSpan(
                      text: "$unitsInt",
                      style: const TextStyle(
                        color: Color(0xFF32BACF),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const TextSpan(text: " units on a 100-unit syringe."),
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
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF727272),
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
                    const TextSpan(text: " full doses per vial."),
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
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF727272),
                      fontFamily: "Geist",
                    ),
                    children: [
                      const TextSpan(text: "Remaining Amount: "),
                      TextSpan(
                        text: "${remainingAmount?.toStringAsFixed(2) ?? '0.00'} mg",
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
    // The filled portion is proportional to units/100
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
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
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
              color: Color(0xFF32BACF), fontWeight: FontWeight.bold, fontSize: 16, fontFamily: "Geist"),
        ),
      ],
    );
  }
}

void _showResultBottomSheet(BuildContext context, double units, int doses, double? remainingAmount) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 100 * value),
        child: child,
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF32BACF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF32BACF),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Calculation Complete',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Geist",
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _ResultCard(
                    units: units,
                    doses: doses,
                    remainingAmount: remainingAmount,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SyringeTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB3B3B3)
      ..strokeWidth = 1.2;
    // Draw horizontal ticks (10 total)
    for (int i = 1; i < 10; i++) {
      final y = size.height * i / 10;
      canvas.drawLine(Offset(8, y), Offset(size.width - 8, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}