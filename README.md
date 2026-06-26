# TP1- Developpement mobile avance
## dev_mobile_app_meteo_groupe13
Application meteo AppMeteo- TP UE2
## Membres du groupe
| N |     Nom et prenom      | Role dans le groupe |
|---|------------------------|---------------------|
| 1 | KOTCHONI Fred          | Chef de groupe      |
| 2 | AYIHOSSOU A. Yves      | Developpeur         |
| 3 | HOUEGNIHOUE E. Casimir | Developpeur         |
| 4 | BOUKO Faïzou Bio Nari  | Developpeur         |
| 5 | FANOUDH Gilles         | Developpeur         |
| 6 | M'PO Nestor            | Developpeur         |
| 7 | GNAGNA E. Landry       | Rapporteur          |

## Enseignant
TOGNON Jean-Paul
Adresse mail : tognonjeanpaul@gmail.com
(L’enseignant a ete invite comme collaborateur du depot GitHub)
## Description du projet
Ce projet est realise dans le cadre du TP1 du cours
UE2-Aspects avances du developpement mobile.
Il consiste a construire une application Flutter AppMeteo
avec une architecture MVVM et le package Provider.
## Technologies utilisees-Flutter / Dart-Package provider-Git / GitHub
## Instructions pour lancer le projet
1. Installer Flutter (https://flutter.dev)
2. Cloner le depot : git clone <URL_du_depot>
3. Installer les dependances : flutter pub get
4. Lancer l’application : flutter run
5. Cloner le depot : git clone <URL_du_depot>

## CORRECTION ETAPE 2 : CREER LE MODELE DE DONNEES
# Question de comprehension
 Notre reponse : Les propriétés de la classe Ville sont déclarées avec le mot-clé final pour rendre l'objet immuable (impossible à modifier après sa création).

  ## Grille d’auto-evaluation
  |CRITERE                                                      | NON FAIT | PARTIELLEMENT | REALISER|
  |-------------------------------------------------------------|----------|---------------|---------|
  |Le projet Flutter se lance sans erreur                       |    ☐    |     ☐         |    ☑    |
  |La classe Ville est correctement créée                       |    ☐    |     ☐         |    ☑    |
  |notifyListeners() est appelé après chaque modification       |    ☐    |     ☐         |    ☑    |
  |ChangeNotifierProvider est configuré dans main.dart          |    ☐    |     ☐         |    ☑    |
  |L'écran d'accueil utilise context.watch()                    |    ☐    |     ☐         |    ☑    |
  |Sélectionnez une ville avec jour l'accueil                   |    ☐    |     ☐         |    ☑    |
  |Les deux écrans fonctionnent correctement                    |    ☐    |     ☐         |    ☑    |


 ## Notes personnelles à ajouter
     Le projet respecte scrupuleusement l'architecture MVVM. Les états sont gérés de manière fluide par le Provider. L'interface utilisateur est dynamique et réagit instantanément aux changements de données, y compris lors de l'ajout manuel d'une nouvelle ville via le formulaire.
Nous avons fait un super boulot sur cette application météo, le code est propre, fonctionnel et bien structuré.
## TP2
## Grille d’auto-evaluation
|CRITERE                                          | NON FAIT | PARTIELLEMENT | REALISER |
|-------------------------------------------------|----------|---------------|--------- |
|dio est installé et configuré                    |    ☐    |     ☐         |    ☑    |
|La classe MeteoData parse correctement le JS     |    ☐    |     ☐         |    ☑    |
|Le service MeteoService appelle l’API            |    ☐    |     ☐         |    ☑    |
|L’intercepteur de log affiche les requêtes       |    ☐    |     ☐         |    ☑    |
|La vraie température s’affiche dans l’app        |    ☐    |     ☐         |    ☑    |
|Le loader s’affiche pendant le chargement        |    ☐    |     ☐         |    ☑    |
|L’erreur réseau est gérée et affichée            |    ☐    |     ☐         |    ☑    |
