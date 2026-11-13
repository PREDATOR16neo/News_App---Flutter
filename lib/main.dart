import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'providers/news_provider.dart';
import 'screens/home_screen.dart';
import 'services/mock_news_service.dart';
import 'services/news_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp(newsService: MockNewsService()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.newsService});

  final NewsService newsService;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsProvider(newsService),
      child: MaterialApp(
        title: 'News App',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
