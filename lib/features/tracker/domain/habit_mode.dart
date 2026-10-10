enum HabitMode {
  doHabit,
  quitHabit;

  String get title => switch (this) {
    HabitMode.doHabit => 'Build a habit',
    HabitMode.quitHabit => 'Quit a habit',
  };

  String get subtitle => switch (this) {
    HabitMode.doHabit => 'Do something every day',
    HabitMode.quitHabit => 'Stay away from something',
  };

  String get inputLabel => switch (this) {
    HabitMode.doHabit => 'I want to...',
    HabitMode.quitHabit => 'I want to quit...',
  };

  String get inputHint => switch (this) {
    HabitMode.doHabit => 'e.g. read 10 pages',
    HabitMode.quitHabit => 'e.g. smoking',
  };

  String get successLabel => switch (this) {
    HabitMode.doHabit => 'Yes, I did it',
    HabitMode.quitHabit => 'I stayed away',
  };

  String get failLabel => switch (this) {
    HabitMode.doHabit => 'Not today',
    HabitMode.quitHabit => 'I slipped',
  };

  String get successStat => switch (this) {
    HabitMode.doHabit => 'Done',
    HabitMode.quitHabit => 'Clean',
  };

  String get failStat => switch (this) {
    HabitMode.doHabit => 'Missed',
    HabitMode.quitHabit => 'Slips',
  };

  String question(String habit) => switch (this) {
    HabitMode.doHabit => 'Did you $habit today?',
    HabitMode.quitHabit => 'Did you stay away from $habit today?',
  };

  String displayName(String habit) => switch (this) {
    HabitMode.doHabit =>
      habit.isEmpty ? habit : habit[0].toUpperCase() + habit.substring(1),
    HabitMode.quitHabit => 'Quit $habit',
  };
}
