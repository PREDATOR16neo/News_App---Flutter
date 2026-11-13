import 'package:material_ui/material_ui.dart';
import 'package:news_app/services/api_news_service.dart';
import 'package:provider/provider.dart';

import 'providers/bookmark_provider.dart';
import 'providers/news_provider.dart';
import 'screens/bookmark_screen.dart';
import 'screens/home_screen.dart';
import 'services/news_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp(newsService: ApiNewsService()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.newsService});

  final NewsService newsService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider(newsService)),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
      ],
      child: MaterialApp(
        title: 'News App',
        theme: AppTheme.lightTheme,
        home: const _NewsAppHome(),
      ),
    );
  }
}

class _NewsAppHome extends StatefulWidget {
  const _NewsAppHome();

  @override
  State<_NewsAppHome> createState() => _NewsAppHomeState();
}

class _NewsAppHomeState extends State<_NewsAppHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const screens = [HomeScreen(), BookmarkScreen()];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Favorit',
          ),
        ],
      ),
    );
  }
}
