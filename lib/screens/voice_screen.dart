import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_menu.dart';

class VoiceScreen extends StatelessWidget {
  const VoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar.large(
                floating: true,
                pinned: true,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                title: Text(
                  "Akıllı Asistan",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Icon(Icons.assistant,
                                    size: 32,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "Merhaba! Size nasıl yardımcı olabilirim?",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Hızlı İşlemler",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.5,
                        children: [
                          ActionCard(
                            icon: Icons.local_hospital,
                            title: "Ambulans (112)",
                            color: Colors.red,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Ambulans Çağır"),
                                  content: const Text(
                                      "112'yi aramak istiyor musunuz?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("İptal"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // TODO: URL launcher ile telefon araması
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Ara"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          ActionCard(
                            icon: Icons.fire_truck,
                            title: "İtfaiye (110)",
                            color: Colors.orange,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("İtfaiye Çağır"),
                                  content: const Text(
                                      "110'u aramak istiyor musunuz?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("İptal"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // TODO: URL launcher ile telefon araması
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Ara"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          ActionCard(
                            icon: Icons.local_police,
                            title: "Polis (155)",
                            color: Colors.blue,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Polis Çağır"),
                                  content: const Text(
                                      "155'i aramak istiyor musunuz?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("İptal"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Ara"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          ActionCard(
                            icon: Icons.help_outline,
                            title: "Yardım",
                            color: Colors.green,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Bir şeyler sorun...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.mic),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
