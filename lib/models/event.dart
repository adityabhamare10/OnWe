class Event {
  final String title;
  final String imagePath;
  bool isReminderSet;

  Event({
    required this.title,
    required this.imagePath,
    required this.isReminderSet,
  });

  void toggleReminder() {
    isReminderSet = !isReminderSet;
  }

  static fromJson(data) {}
}
