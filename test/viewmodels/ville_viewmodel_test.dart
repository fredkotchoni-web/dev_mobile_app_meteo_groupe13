import 'package:flutter_test/flutter_test.dart';
import 'package:app_meteo/viewmodels/ville_viewmodel.dart';
import 'package:app_meteo/models/ville.dart';

void main() {
  late VilleViewModel vm;

  setUp(() {
    // Creer un ViewModel frais avant chaque test
    vm = VilleViewModel();
  });

  group('VilleViewModel', () {
    test('la liste initiale contient au moins 4 villes', () {
      expect(vm.villes.length, greaterThanOrEqualTo(4));
    });

    test('Cotonou est dans la liste initiale', () {
      final contientCotonou = vm.villes.any((v) => v.nom == 'Cotonou');
      expect(contientCotonou, isTrue);
    });

    test('selectionnerVille met a jour villeSelectionnee', () {
      // ARRANGE : trouver Lagos dans la liste
      final lagos = vm.villes.firstWhere((v) => v.nom == 'Lagos');

      // ACT
      vm.selectionnerVille(lagos);

      // ASSERT
      expect(vm.villeSelectionnee?.nom, equals('Lagos'));
    });

    // Test 4 : Complété !
    // tester ajouterVille augmente la liste de 1
    test('ajouterVille augmente la liste de 1', () {
      final tailleInitiale = vm.villes.length;
      final nouvelleVille = Ville(
        nom: 'Parakou',
        pays: 'Bénin',
        temperature: 28.5,
        condition: 'Ensoleillé',
        humidite: 65,
      );
      vm.ajouterVille(nouvelleVille);

      // On vérifie simplement que la taille a augmenté de 1
      expect(vm.villes.length, equals(tailleInitiale + 1));
    });

    // Test 5 : Complété !
    // tester que notifyListeners est appele
    test('selectionnerVille notifie les listeners', () {
      int compteur = 0;

      // On écoute les changements du ViewModel
      vm.addListener(() {
        compteur++;
      });

      final lagos = vm.villes.firstWhere((v) => v.nom == 'Lagos');

      // Act : cette action doit déclencher le notifyListeners
      vm.selectionnerVille(lagos);

      // Assert : le compteur doit avoir augmenté si notifyListeners() a été appelé
      expect(compteur, greaterThan(0));
    });
  });
}
