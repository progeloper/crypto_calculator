import 'package:coin_repository/coin_repository.dart';
import 'package:crypto_calculator/exchange/presentation/convertScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(MyApp(
    repo: CoinRepository(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required CoinRepository repo}) : _repo = repo;
  final CoinRepository _repo;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _repo,
      child: MaterialApp(
        title: 'Crypto Calculator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ConvertPage(),
      ),
    );
  }
}
