import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/habit_mode.dart';
import '../controllers/tracker_controller.dart';
import '../widgets/duration_selector.dart';
import '../widgets/form_section.dart';
import '../widgets/mode_selector.dart';
import '../widgets/reminder_time_tile.dart';

class CreateTrackerScreen extends StatefulWidget {
  const CreateTrackerScreen({super.key});

  @override
  State<CreateTrackerScreen> createState() => _CreateTrackerScreenState();
}

class _CreateTrackerScreenState extends State<CreateTrackerScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  HabitMode _mode = HabitMode.doHabit;
  int _days = 30;
  TimeOfDay _time = const TimeOfDay(hour: 20, minute: 0);
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final tracker = await TrackerScope.read(context).create(
      name: _nameController.text,
      mode: _mode,
      totalDays: _days,
      reminderHour: _time.hour,
      reminderMinute: _time.minute,
    );
    if (!mounted) return;
    context.pushReplacement('/tracker/${tracker.id}');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 22, 0),
              child: Row(
                children: [
                  IconButton.filled(
                    onPressed: () => context.pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: palette.sage,
                      foregroundColor: palette.ink,
                    ),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close',
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'New habit',
                    style: TextStyle(
                      color: palette.ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                  children: [
                    FormSection(
                      title: 'Mode',
                      child: ModeSelector(
                        value: _mode,
                        onChanged: (mode) => setState(() => _mode = mode),
                      ),
                    ),
                    const SizedBox(height: 26),
                    FormSection(
                      title: _mode.inputLabel,
                      child: TextFormField(
                        controller: _nameController,
                        maxLength: 40,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          color: palette.ink,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: _mode.inputHint,
                          hintStyle: TextStyle(color: palette.muted),
                          counterText: '',
                          filled: true,
                          fillColor: palette.surface,
                          contentPadding: const EdgeInsets.all(18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: palette.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: palette.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: palette.emphasis,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Give your habit a name'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 26),
                    FormSection(
                      title: 'Challenge length',
                      child: DurationSelector(
                        value: _days,
                        onChanged: (days) => setState(() => _days = days),
                      ),
                    ),
                    const SizedBox(height: 26),
                    FormSection(
                      title: 'Reminder',
                      child: ReminderTimeTile(
                        time: _time,
                        onChanged: (time) => setState(() => _time = time),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
              child: FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : const Text('Start tracking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
