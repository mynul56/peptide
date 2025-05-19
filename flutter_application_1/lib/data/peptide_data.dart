class PeptideInfo {
  final String name;
  final String description;
  final String mechanism;
  final String functionality;
  final String? dose;
  final String? notes;

  PeptideInfo({
    required this.name,
    required this.description,
    required this.mechanism,
    required this.functionality,
    this.dose,
    this.notes,
  });
}

final List<PeptideInfo> peptideData = [
  PeptideInfo(
    name: "AOD-9604",
    description: "A modified fragment of human growth hormone (hGH) that targets fat metabolism.",
    mechanism: "Mimics the fat-reducing effects of hGH without impacting blood sugar or growth.",
    functionality: "Fat loss, metabolic support, and potential cartilage repair properties.",
    dose: "300-350mcg/day",
    notes: "Best taken on empty stomach. Subcutaneous injection. Morning dosing preferred.",
  ),
  PeptideInfo(
    name: "ARA-290",
    description: "A synthetic peptide derived from erythropoietin (EPO) without stimulating red blood cell production.",
    mechanism: "Activates tissue repair receptors and reduces inflammation through the innate repair receptor.",
    functionality: "Neuropathy treatment, tissue protection, and reduction of inflammatory pain.",
    dose: "1-4mg daily",
    notes: "Subcutaneous injection. Course typically 28 days.",
  ),
  PeptideInfo(
    name: "BPC-157",
    description: "Body Protection Compound-157, derived from a protective protein in the stomach.",
    mechanism: "Accelerates healing through angiogenesis and growth factor stimulation.",
    functionality: "Injury recovery, gut health, and tissue repair throughout the body.",
    dose: "200-500 mcg/day",
    notes: "Best taken on empty stomach. Subcutaneous or oral. Cycle 2-4 weeks.",
  ),
  PeptideInfo(
    name: "BPC-157/TB-500",
    description: "A synergistic blend combining the healing properties of both peptides.",
    mechanism: "Combines BPC-157's angiogenesis promotion with TB-500's cell migration and healing effects.",
    functionality: "Enhanced injury recovery, tissue repair, and healing acceleration.",
    dose: "250mcg BPC/2mg TB combined",
    notes: "Daily (BPC) or 2-3x/week (TB). 4-8 week cycles. Best for severe injuries. Subcutaneous injection.",
  ),
  PeptideInfo(
    name: "Bronchogen",
    description: "A peptide bioregulator specific to lung tissue.",
    mechanism: "Regulates protein synthesis in lung cells and normalizes lung tissue metabolism.",
    functionality: "Supports respiratory function and lung tissue health.",
    dose: "1-2 capsules daily",
    notes: "Recommended course: 10-20 days. Can be repeated 2-3 times per year.",
  ),
  PeptideInfo(
    name: "Cagrilintide",
    description: "A novel amylin analog developed for weight management.",
    mechanism: "Acts on amylin receptors to regulate appetite and energy homeostasis.",
    functionality: "Weight management, appetite control, and metabolic regulation.",
    dose: "Under clinical investigation",
    notes: "Currently in development for obesity treatment.",
  ),
  PeptideInfo(
    name: "Cardiogen",
    description: "A peptide bioregulator specific to heart tissue.",
    mechanism: "Regulates protein synthesis in cardiac cells and supports heart muscle function.",
    functionality: "Cardiovascular health support and heart tissue maintenance.",
    dose: "1-2 capsules daily",
    notes: "Recommended course: 10-20 days. Can be repeated 2-3 times per year.",
  ),
  PeptideInfo(
    name: "Chonluten",
    description: "A peptide bioregulator specific to lung tissue health.",
    mechanism: "Normalizes protein synthesis in lung tissue and improves cellular metabolism.",
    functionality: "Respiratory system support and lung tissue regeneration.",
    dose: "1-2 capsules daily",
    notes: "Course duration: 10-20 days. May be repeated 2-3 times yearly.",
  ),
  PeptideInfo(
    name: "Cortagen",
    description: "A peptide bioregulator for the adrenal cortex.",
    mechanism: "Regulates protein synthesis in adrenal cells and supports hormone balance.",
    functionality: "Adrenal function support and stress response regulation.",
    dose: "1-2 capsules daily",
    notes: "Recommended course: 10-20 days. Can be repeated 2-3 times per year.",
  ),
  PeptideInfo(
    name: "DSIP",
    description: "Delta sleep-inducing peptide for sleep regulation.",
    mechanism: "Modulates neurotransmitter systems involved in sleep-wake cycles.",
    functionality: "Sleep improvement, stress reduction, and circadian rhythm regulation.",
    dose: "100-200mcg before bed",
    notes: "Best taken 30 minutes before bedtime. May improve jet lag recovery.",
  ),
  PeptideInfo(
    name: "Epitalon",
    description: "A synthetic peptide that regulates pineal gland function.",
    mechanism: "Increases telomerase activity and normalizes melatonin production.",
    functionality: "Anti-aging, circadian rhythm regulation, and DNA protection.",
    dose: "5-10mg daily for 10-20 days",
    notes: "Typically used in courses 2-4 times per year. Evening administration preferred.",
  ),
  PeptideInfo(
    name: "Follistatin 344",
    description: "A protein that inhibits myostatin and regulates muscle growth.",
    mechanism: "Binds to and inhibits myostatin, promoting muscle tissue growth.",
    functionality: "Muscle growth enhancement and fat metabolism regulation.",
    dose: "100-300mcg daily",
    notes: "Cycle length typically 10-30 days. Used in performance and muscle growth protocols.",
  ),
  PeptideInfo(
    name: "FOXO4-DRI",
    description: "A cell-penetrating peptide targeting senescent cells.",
    mechanism: "Disrupts FOXO4-p53 interaction in senescent cells, promoting apoptosis.",
    functionality: "Selective elimination of senescent cells and tissue regeneration.",
    dose: "Under research protocol",
    notes: "Currently in research phase. Dosing protocols still being established.",
  ),
];