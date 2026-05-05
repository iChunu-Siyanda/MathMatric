import 'package:equatable/equatable.dart';

class LastStudied extends Equatable {
  final String title;
  final String backgroundImg;
  final double progress;
  final int lastPage; 
  final List<String> assets;

  const LastStudied({
    required this.title,
    required this.backgroundImg,
    required this.progress,
    required this.lastPage, 
    required this.assets,
  });

  factory LastStudied.fromJson(Map<String, dynamic> json) => LastStudied(
    title: json['title'],
    backgroundImg: json['backgroundImg'],
    progress: (json['progress'] as num).toDouble(),
    lastPage: json['lastPage'] ?? 1, // Fallback to page 1
    assets: List<String>.from(json['assets']),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'backgroundImg': backgroundImg,
    'progress': progress,
    'lastPage': lastPage,
    'assets': assets,
  };

  @override
  List<Object?> get props => [title, progress, lastPage];
}
