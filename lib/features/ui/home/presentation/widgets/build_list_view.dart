import 'package:flutter/material.dart';
import 'package:math_matric/features/ui/home/domain/entities/last_studied.dart';
import 'package:math_matric/features/ui/home/presentation/widgets/view_actions.dart';

class BuildListView extends StatelessWidget {
  final List<LastStudied> topics;
  const BuildListView({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const ValueKey('list_view'),
      padding: const EdgeInsets.all(16),
      itemCount: topics.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final topic = topics[index];
        return Dismissible(
          key: Key(topic.title),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete_rounded, color: Colors.white),
          ),
          onDismissed: (_) => ViewActions.removeTopic(context, topic.title),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                topic.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(
                  value: topic.progress,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey),
                onPressed: () => ViewActions.removeTopic(context, topic.title),
              ),
              onTap: () => ViewActions.navigateToPaper(context, topic),
            ),
          ),
        );
      },
    );
  }
}
