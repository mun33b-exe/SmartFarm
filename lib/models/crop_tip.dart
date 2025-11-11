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
}
