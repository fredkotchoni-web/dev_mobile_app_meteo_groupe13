import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ville.dart';
import '../viewmodels/ville_viewmodel.dart';

class EcranAjouterVille extends StatefulWidget {
  const EcranAjouterVille({super.key});

  @override
  State<EcranAjouterVille> createState() => _EcranAjouterVilleState();
}

class _EcranAjouterVilleState extends State<EcranAjouterVille> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour récupérer les textes saisis
  final _nomController = TextEditingController();
  final _paysController = TextEditingController();
  final _tempController = TextEditingController();
  final _humiditeController = TextEditingController();

  String _conditionSelectionnee = 'Ensoleille';

  // Les options disponibles pour la météo
  final List<String> _conditions = [
    'Ensoleille',
    'Nuageux',
    'Pluvieux',
    'Orageux',
    'Ventueux',
  ];

  @override
  void dispose() {
    _nomController.dispose();
    _paysController.dispose();
    _tempController.dispose();
    _humiditeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une ville'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ Nom
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom de la ville'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un nom' : null,
              ),
              const SizedBox(height: 12),

              // Champ Pays
              TextFormField(
                controller: _paysController,
                decoration: const InputDecoration(labelText: 'Pays'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un pays' : null,
              ),
              const SizedBox(height: 12),

              // Champ Température
              TextFormField(
                controller: _tempController,
                decoration: const InputDecoration(
                  labelText: 'Température (°C)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer une température' : null,
              ),
              const SizedBox(height: 12),

              // Champ Humidité
              TextFormField(
                controller: _humiditeController,
                decoration: const InputDecoration(labelText: 'Humidité (%)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer l\'humidité' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _conditionSelectionnee,
                decoration: const InputDecoration(labelText: 'Condition météo'),
                items: _conditions.map((String condition) {
                  return DropdownMenuItem<String>(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (String? nouvelleValeur) {
                  setState(() {
                    _conditionSelectionnee = nouvelleValeur!;
                  });
                },
              ),
              const SizedBox(height: 30),

              // Bouton de Validation
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Création du nouvel objet Ville
                    final nouvelleVille = Ville(
                      nom: _nomController.text,
                      pays: _paysController.text,
                      temperature: double.parse(_tempController.text),
                      condition: _conditionSelectionnee,
                      humidite: int.parse(_humiditeController.text),
                    );

                    context.read<VilleViewModel>().ajouterVille(nouvelleVille);

                    // Retourner à l'écran précédent (la liste des villes)
                    Navigator.pop(context);
                  }
                },
                child: const Text('Enregistrer la ville'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
