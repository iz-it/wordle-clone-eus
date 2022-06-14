import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordleidinaf/pages/home_page.dart';
import 'package:wordleidinaf/providers/controller.dart';
import 'package:wordleidinaf/providers/theme_provider.dart';
import 'package:wordleidinaf/utils/theme_preferences.dart';

import 'constants/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Controller()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: FutureBuilder(
        initialData: false,
        future: ThemePreferences.getTheme(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              Provider.of<ThemeProvider>(context, listen: false)
                  .setTheme(turnOn: snapshot.data as bool);
            });
          }
          return Consumer<ThemeProvider>(
            builder: (_, notifier, __) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Wordle EUS',
              //si isdark true = darktheme, sino lighttheme
              theme: notifier.isDark ? darkTheme : lightTheme,
              home: const Material(child: HomePage()),
            ),
          );
        },
      ),
    );
  }
}