class DailyChartData {
  final DateTime date;
  final int minutes;
  final int correctAnswers;
  final int totalQuestions;

  const DailyChartData({
    required this.date,
    required this.minutes,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  double get accuracy {
    if (totalQuestions == 0) return 0;
    return (correctAnswers / totalQuestions) * 100;
  }
}
