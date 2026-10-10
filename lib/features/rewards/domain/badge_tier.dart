enum BadgeTier {
  starter(7, 'Week Starter', 'Finish a 7-day goal'),
  steady(15, 'Steady Stepper', 'Finish a 15-day goal'),
  committed(30, 'Committed', 'Finish a 30-day goal'),
  unstoppable(60, 'Unstoppable', 'Finish a 60-day goal'),
  legend(90, 'Legend', 'Finish a 90-day goal');

  const BadgeTier(this.days, this.title, this.description);

  final int days;
  final String title;
  final String description;

  static BadgeTier forDays(int days) =>
      values.lastWhere((t) => t.days <= days, orElse: () => values.first);
}
