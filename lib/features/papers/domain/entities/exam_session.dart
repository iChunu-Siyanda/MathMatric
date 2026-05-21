//Enums are much better than strings, they are safe(compile-time safety).
enum ExamSession {
  march,
  june,
  november,
  ieb,
  prelims;
  
  static ExamSession? tryParse(String? value) {
    if (value == null) return null;

    // Normalizes strings by removing spaces, underscores, hyphens, and forcing lowercase.
    // e.g., "May June" -> "mayjune"
    final cleanValue = value.replaceAll(RegExp(r'[\s\-_]'), '').toLowerCase();

    for (final session in ExamSession.values) {
      // Normalizes the enum name for comparison (e.g., "mayJune" -> "mayjune")
      if (session.name.toLowerCase() == cleanValue) {
        return session;
      }
    }
    
    return null; // Return null safely instead of crashing for "Class Notes"
  }
}