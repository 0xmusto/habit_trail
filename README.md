# Habit Trail: Map Your Journey

Habit Trail is a minimal, user-centric habit-tracking application designed to help individuals build life-changing routines or quit stubborn vices. By sending intelligent, daily check-in reminders, the app holds users accountable for their actions and maps consistency onto an interactive visual progress trail.

---

## Key Features

### Dynamic Progress Trails
* Visual Waypoints: Every daily check-in adds a new milestone marker to your evolving path.
* Journey History: Tap past trail markers to review what actions you took on specific days.

### Dual-Mode Tracking
* Habit Building: Stack positive routines like exercising, reading, or meditating with visual momentum.
* Habit Quitting: Track days of freedom from negative triggers like smoking, excessive screen time, or junk food.

### Intelligent Check-ins
* Custom Reminders: Schedule push notifications exactly when you need personal accountability.
* Home Screen Widgets: View current trail baselines and interact with daily goals directly from the device home screen.

---

## Tech Stack

* Framework: Flutter (Dart SDK ^3.13.4)
* Routing and Navigation: go_router
* Notification Services: flutter_local_notifications (with timezone support)
* Home Screen Widgets: home_widget Integration
* Local Key-Value Storage: shared_preferences

---

## Project Structure

The codebase is organized using a feature-first, modular architecture:

```text
lib/
├── app/                  # Application-wide configurations and router setup
├── core/                 # Shared logic including home_widget and notification services
└── features/             # Independent domain modules
    ├── home/             # User dashboard and main user interfaces
    ├── rewards/          # Milestone unlockables and badges
    └── tracker/          # Core routine and vice tracking engine
```

---

## Getting Started

### Prerequisites
* Flutter SDK configured on your machine. Run `flutter doctor` to verify your setup.
* A connected Android/iOS emulator or physical device.

### Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/0xmusto/habit-trail.git
   cd habit-tracker
   ```

2. Fetch the required dependencies:
   ```bash
   flutter pub get
   ```

3. (Optional) Rebuild assets such as launcher icons and splash screens:
   ```bash
   flutter pub run flutter_launcher_icons
   flutter pub run flutter_native_splash:create
   ```

4. Run the application:
   ```bash
   flutter run
   ```

---

## License

Distributed under the MIT License.
