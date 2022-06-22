import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home_screen/cubit/record/record_cubit.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/recordings_list/view/recordings_list_screen.dart';

import 'screens/recordings_list/cubit/files/files_cubit.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Come On Audio',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Come On Audio'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Index pour parcourir la liste des screens
  int index = 0;
  // list des screens que l'on va utilisé
  final screens = [
    const HomeScreen(),
    const RecordingsListScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // On charge les states léger avant l'app pour éviter de ralonger ceux ci
        BlocProvider<RecordCubit>(
          create: (context) => RecordCubit(),
        ),

        /// de la meme manière [FilesCubit] est appelé dans le but de chargé tout les
        /// différents fichier stocké que l'ont va lister dans les enregistrements
        BlocProvider<FilesCubit>(
          create: (context) => FilesCubit(),
        ),
      ],
      child: Scaffold(
          // Screen dynamique
          body: screens[index],
          // BotomBar classique utilisant la dernier version de MUI
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.white,
              elevation: 0,
              labelTextStyle: MaterialStateProperty.all(const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
            ),
            child: NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (index) => setState(() {
                this.index = index;
              }),
              animationDuration: const Duration(milliseconds: 800),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.mic_external_on),
                  label: 'Acceuil',
                ),
                NavigationDestination(
                  icon: Icon(Icons.list),
                  label: 'Mes enregistrements',
                ),
              ],
            ),
          )),
    );
  }
}
