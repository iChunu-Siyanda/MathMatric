class PaperItem {
  final String title;
  final String brief;
  final Section ? section;

  const PaperItem({
    required this.title,
    required this.brief,
    this.section,
  });
}

class Section {
  final String title;
  final List<dynamic> topics;

  const Section({
    required this.title,
    required this.topics,
  });
}



// PaperBloc emits PaperLoaded(sections) → your PaperPage grid receives sections
// PaperTile → TopicsSliverList → passes its PaperItem (section)
// TopicsSliverList → SectionType → passes both PaperItem and TopicItem via SectionContext

// features/papers/
// ├── domain/          ← entities, use cases, abstract repositories
// ├── data/            ← repository implementations, local/remote data sources
// └── presentation/    ← UI + blocs + widgets
