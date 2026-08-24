enum StudyMode {
  practice,
  classnotes;

  String get title {
    switch (this) {
      case StudyMode.practice:
        return 'Practice Tests';
      case StudyMode.classnotes:
        return 'Class Notes';
    }
  }

  String get description {
    switch (this) {
      case StudyMode.practice:
        return 'Targeted questions with instant step-by-step solutions.';
      case StudyMode.classnotes:
        return 'Comprehensive theory notes, formulas, and cheat sheets.';
    }
  }

  String get stats {
    switch (this) {
      case StudyMode.practice:
        return '1,200+ Questions';
      case StudyMode.classnotes:
        return '14 Chapters';
    }
  }

  String get imageAsset {
    switch (this) {
      case StudyMode.practice:
        return 'assets/images/algebra.webp';
      case StudyMode.classnotes:
        return 'assets/images/algebra.webp';
    }
  }

  String get buttonText => 'Explore Now';
}