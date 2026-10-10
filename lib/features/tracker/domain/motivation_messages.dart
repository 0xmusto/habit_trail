import 'habit_mode.dart';

const _doSuccess = [
  'Another day done. Consistency is quietly building the new you.',
  'You showed up today, and that is what matters most.',
  'Small wins add up. Keep the chain going.',
  'Proud of you. Future you will say thank you.',
  'Discipline beats motivation, and you just proved it.',
];

const _doMiss = [
  'One missed day does not break you. Come back strong tomorrow.',
  'It is okay. What matters is that you keep going.',
  'Tomorrow is a fresh page. You have got this.',
  'Progress is not perfect. Get back on track tomorrow.',
  'Be kind to yourself, then try again tomorrow.',
];

const _quitSuccess = [
  'Another day free. Your strength is growing.',
  'You said no today, and that is real power.',
  'Every clean day makes the next one easier.',
  'Stay proud. You are rewriting your story.',
  'The cravings fade, but your willpower stays.',
];

const _quitSlip = [
  'A slip is not the end. Learn from it and keep moving.',
  'You are still on the path. Start fresh tomorrow.',
  'Do not let one day define the journey. You can do this.',
  'Be gentle with yourself. Tomorrow you try again.',
  'Falling is part of quitting. Getting up is what counts.',
];

String motivationFor({
  required HabitMode mode,
  required bool success,
  required int day,
  required int totalDays,
}) {
  if (success && day == totalDays) {
    return switch (mode) {
      HabitMode.doHabit =>
        'You finished all $totalDays days. This is a habit you can be proud of!',
      HabitMode.quitHabit =>
        'You made it through all $totalDays days. You are free and unstoppable!',
    };
  }
  final pool = switch ((mode, success)) {
    (HabitMode.doHabit, true) => _doSuccess,
    (HabitMode.doHabit, false) => _doMiss,
    (HabitMode.quitHabit, true) => _quitSuccess,
    (HabitMode.quitHabit, false) => _quitSlip,
  };
  return pool[day % pool.length];
}
