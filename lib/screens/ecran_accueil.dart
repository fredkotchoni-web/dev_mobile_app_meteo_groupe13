import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_liste_villes.dart';
import 'ecran_detail_ville.dart';
import 'package:image_picker/image_picker.dart';
import '../services/localisation_service.dart';
import '../services/meteo_service.dart';

class EcranAccueil extends StatefulWidget {
  const EcranAccueil({super.key});

  @override
  State<EcranAccueil> createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<VilleViewModel>();
      if (vm.villeSelectionnee != null) {
        vm.selectionnerVille(vm.villeSelectionnee!);
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  IconData _iconeMeteo(String condition) {
    switch (condition) {
      case 'Ensoleille':
        return Icons.wb_sunny;
      case 'Nuageux':
        return Icons.cloud;
      case 'Pluvieux':
        return Icons.umbrella;
      case 'Orageux':
        return Icons.thunderstorm;
      case 'Ventueux':
        return Icons.air;
      default:
        return Icons.wb_cloudy;
    }
  }

  // Correction de la couleur de l'icône selon le temps
  Color _couleurIcone(String condition) {
    switch (condition) {
      case 'Ensoleille':
        return Colors.orange;
      case 'Nuageux':
        return Colors.grey[600]!;
      case 'Pluvieux':
      case 'Orageux':
        return Colors.blue[700]!;
      default:
        return Colors.blue;
    }
  }

  // RETOURNE UNIQUEMENT LES TROIS COULEURS DEMANDÉES (Correction de l'application)
  Color _couleurFond(String condition) {
    switch (condition) {
      case 'Ensoleille':
        return Colors.orange[100]!;
      case 'Nuageux':
        return Colors.grey[300]!;
      case 'Pluvieux':
      case 'Orageux': // Ajout d'une sécurité si Orageux arrive
        return Colors.blue[100]!;
      default:
        return Colors.white;
    }
  }

  void _choisirSourcePhoto(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Galerie'),
                onTap: () async {
                  Navigator.pop(context);
                  _recupererImage(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.blue),
                title: const Text('Appareil photo'),
                onTap: () async {
                  Navigator.pop(context);
                  _recupererImage(context, ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _recupererImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null && mounted) {
      context.read<VilleViewModel>().mettreAJourPhoto(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VilleViewModel>();
    final ville = vm.villeSelectionnee;
    final meteoData = vm.meteoActuelle;

    final conditionActuelle = (meteoData != null && vm.erreur == null)
        ? meteoData.conditionTexte
        : (ville?.condition ?? 'Inconnu');

    // --- GESTION DE LA ROTATION CONTINUE ---
    if (conditionActuelle == 'Ensoleille') {
      _rotationController.repeat();
    } else {
      _rotationController.stop();
    }

    final double tailleIcone = (meteoData != null && meteoData.temperature > 30)
        ? 120.0
        : 80.0;

    // FIX : On utilise directement la fonction de condition pour avoir les vraies 3 couleurs demandées !
    Color couleurFondMeteo = _couleurFond(conditionActuelle);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppMeteo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
        child: ville == null
            ? const Center(child: CircularProgressIndicator())
            : AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                width: double.infinity,
                height: double.infinity,
                color: couleurFondMeteo,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EcranDetailVille(
                                  ville: vm.villeSelectionnee!,
                                  meteo: vm.meteoActuelle,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Hero(
                                tag:
                                    'icone-${vm.villeSelectionnee?.nom ?? "meteo"}',
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.elasticOut,
                                  width: tailleIcone,
                                  height: tailleIcone,
                                  alignment: Alignment.center,
                                  child: RotationTransition(
                                    turns: _rotationController,
                                    child: Icon(
                                      _iconeMeteo(conditionActuelle),
                                      size: tailleIcone,
                                      color: _couleurIcone(
                                        conditionActuelle,
                                      ), // FIX : Couleur dynamique !
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              Text(
                                ville.nom,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),

                              if (vm.gpsCoordsActuelles != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Lat: ${vm.gpsCoordsActuelles![0].toStringAsFixed(4)}° | Lon: ${vm.gpsCoordsActuelles![1].toStringAsFixed(4)}°',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 8),

                              Consumer<VilleViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.chargement) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (vm.erreur != null) {
                                    return Column(
                                      children: [
                                        const Icon(
                                          Icons.wifi_off,
                                          size: 60,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          vm.erreur!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (vm.villeSelectionnee != null) {
                                              vm.selectionnerVille(
                                                vm.villeSelectionnee!,
                                              );
                                            }
                                          },
                                          child: const Text('Réessayer'),
                                        ),
                                      ],
                                    );
                                  }

                                  final meteo = vm.meteoActuelle;
                                  if (meteo == null) {
                                    return const Text('Chargement initial...');
                                  }

                                  return Column(
                                    children: [
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        transitionBuilder: (child, animation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        child: Text(
                                          '${vm.meteoActuelle?.temperature.toStringAsFixed(1) ?? '--'} °C',
                                          key: ValueKey(
                                            vm.villeSelectionnee?.nom,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      Text(
                                        meteo.dateFormatee,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      Text(
                                        '${meteo.conditionTexte} - ${meteo.humidite}% humidité',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      const Text(
                                        'Prévisions sur 3 jours',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      SizedBox(
                                        height: 120,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: meteo.previsions.length,
                                          itemBuilder: (context, index) {
                                            final prev =
                                                meteo.previsions[index];
                                            return Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              elevation: 2,
                                              child: Container(
                                                width: 100,
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      prev.dateFormatee,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Icon(
                                                      _iconeMeteo(
                                                        prev.conditionTexte,
                                                      ),
                                                      color: _couleurIcone(
                                                        prev.conditionTexte,
                                                      ),
                                                      size: 28,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      '${prev.tempMax.toStringAsFixed(0)}° / ${prev.tempMin.toStringAsFixed(0)}°',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GestureDetector(
                            onTap: () => _choisirSourcePhoto(context),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: vm.villeSelectionnee?.photoPath != null
                                  ? (kIsWeb
                                        ? Image.network(
                                            vm.villeSelectionnee!.photoPath!,
                                            width: double.infinity,
                                            height: 140,
                                            fit: BoxFit.contain,
                                          )
                                        : Image.file(
                                            File(
                                              vm.villeSelectionnee!.photoPath!,
                                            ),
                                            width: double.infinity,
                                            height: 140,
                                            fit: BoxFit.contain,
                                          ))
                                  : Container(
                                      width: double.infinity,
                                      height: 140,
                                      color: Colors.grey[200],
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.add_a_photo,
                                            size: 35,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Appuyez pour ajouter une photo',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        ElevatedButton.icon(
                          icon: const Icon(Icons.my_location),
                          label: const Text('Trouver la ville la plus proche'),
                          onPressed: () async {
                            final service = LocalisationService();
                            final position = await service.getPosition();

                            if (position != null && context.mounted) {
                              final vm = context.read<VilleViewModel>();
                              final villeProche = service.trouverVilleProche(
                                position,
                                vm.villes,
                                MeteoService.coords,
                              );

                              if (villeProche != null) {
                                vm.selectionnerVille(villeProche);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Ville proche : ${villeProche.nom}',
                                    ),
                                  ),
                                );
                              }
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('GPS indisponible'),
                                ),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        ElevatedButton.icon(
                          icon: const Icon(Icons.list),
                          label: const Text('Changer de ville'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EcranListeVilles(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
