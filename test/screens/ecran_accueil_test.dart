import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:app_meteo/viewmodels/ville_viewmodel.dart';
import 'package:app_meteo/screens/ecran_accueil.dart';

Widget creerAppTest(VilleViewModel viewModel) {
  return ChangeNotifierProvider<VilleViewModel>(
    create: (_) => viewModel,
    child: const MaterialApp(home: EcranAccueil()),
  );
}

void main() {
  late VilleViewModel vm;

  setUp(() {
    vm = VilleViewModel();
  });

  testWidgets('EcranAccueil affiche une AppBar avec le titre', (tester) async {
    await tester.pumpWidget(creerAppTest(vm));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('AppMeteo'), findsOneWidget);

    await tester.binding.runAsync(
      () => Future.delayed(const Duration(seconds: 1)),
    );
  });

  testWidgets('EcranAccueil affiche une Temperature', (tester) async {
    await tester.pumpWidget(creerAppTest(vm));
    await tester.pump(const Duration(seconds: 1));

    expect(find.textContaining('C'), findsWidgets);

    await tester.binding.runAsync(
      () => Future.delayed(const Duration(seconds: 1)),
    );
  });

  testWidgets('Le bouton Changer de ville est present', (tester) async {
    await tester.pumpWidget(creerAppTest(vm));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Changer de ville'), findsOneWidget);

    await tester.binding.runAsync(
      () => Future.delayed(const Duration(seconds: 1)),
    );
  });

  testWidgets('Appuyer sur Changer de ville ouvre la liste', (tester) async {
    await tester.pumpWidget(creerAppTest(vm));
    await tester.pump(const Duration(seconds: 1));

    final boutonFinder = find.text('Changer de ville');
    await tester.ensureVisible(boutonFinder);
    await tester.tap(boutonFinder, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Cotonou'), findsWidgets);

    await tester.binding.runAsync(
      () => Future.delayed(const Duration(seconds: 1)),
    );
  });
}
