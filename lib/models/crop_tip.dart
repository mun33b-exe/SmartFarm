class CropTip {
  final String title;
  final String description;
  final String icon;

  const CropTip({
    required this.title,
    required this.description,
    required this.icon,
  });

  static final List<CropTip> dummyTips = [
    const CropTip(
      title: 'Irrigation',
      description: 'Check soil moisture before watering.',
      icon: '💧',
    ),
    const CropTip(
      title: 'Pest Control',
      description: 'Look for common pests in the morning.',
      icon: '🐞',
    ),
    const CropTip(
      title: 'Fertilizer',
      description: 'Apply nitrogen-based fertilizer this week.',
      icon: '🌱',
    ),
  ];

  static final Map<String, List<CropTip>> filteredTips = {
    'Wheat': const [
      CropTip(
        title: 'Sowing',
        description: 'Sow seeds in rows for best yield.',
        icon: '🌾',
      ),
      CropTip(
        title: 'Watering',
        description: 'First irrigation at 21 days is crucial.',
        icon: '💧',
      ),
      CropTip(
        title: 'Pest Alert',
        description: 'Watch for yellow rust.',
        icon: '🐞',
      ),
    ],
    'Rice': const [
      CropTip(
        title: 'Planting',
        description: 'Transplant seedlings 25-30 days old.',
        icon: '🌱',
      ),
      CropTip(
        title: 'Water',
        description: 'Maintain 2-5 cm standing water.',
        icon: '💧',
      ),
      CropTip(
        title: 'Harvest',
        description: 'Harvest when 80-85% of grains are straw-colored.',
        icon: '🌾',
      ),
    ],
    'Cotton': const [
      CropTip(
        title: 'Soil',
        description: 'Requires well-drained soil.',
        icon: '🌱',
      ),
      CropTip(
        title: 'Pest Control',
        description: 'Monitor for pink bollworm.',
        icon: '🐞',
      ),
      CropTip(
        title: 'Picking',
        description: 'Begin picking when 30-40% open.',
        icon: '🌾',
      ),
    ],
  };
}
