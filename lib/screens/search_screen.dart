import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/themes.dart';
import '../widgets/bottom_menu.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: TextField(
              decoration: InputDecoration(
                hintText: "Ara...",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.tune),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Son Aramalar",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ActionChip(
                        label: const Text("Görme"),
                        onPressed: () {},
                        avatar: const Icon(Icons.history, size: 16),
                      ),
                      ActionChip(
                        label: const Text("Bedensel"),
                        onPressed: () {},
                        avatar: const Icon(Icons.history, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final items = [
                    {
                      'title': 'Engellilere Erişilebilir Alanlar Sağlayalım',
                      'image': 'assets/images/tekerleklisandalye.webp',
                      'description':
                          'Engelli bireylerin hayatını kolaylaştırmak için erişilebilir alanlar oluşturalım.',
                    },
                    {
                      'title': 'İşaret Dili',
                      'image': 'assets/images/isaretdili.webp',
                      'description':
                          'İşitme engelli bireylerle iletişimi güçlendirmek için işaret dilini öğrenelim.',
                    },
                    {
                      'title': 'Engelli Bireyleri Destekleyelim',
                      'image': 'assets/images/gormeengelli.webp',
                      'description':
                          'Engelli bireylerin toplumsal hayata katılımını destekleyelim.',
                    },
                  ];

                  if (index >= items.length) return null;

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            items[index]['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[index]['title']!,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                items[index]['description']!,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 3,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
