import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form/blocs/admin-bloc.dart';
import 'package:form/blocs/annee-academique-bloc.dart';
import 'package:form/blocs/auth-bloc.dart';
import 'package:form/blocs/auth-sonde-bloc.dart';
import 'package:form/blocs/champs-bloc.dart';
import 'package:form/blocs/entreprise-bloc.dart';
import 'package:form/blocs/folder-bloc.dart';
import 'package:form/blocs/formulaire-bloc.dart';
import 'package:form/blocs/formulaire-reponse-bloc.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/blocs/matiere-bloc.dart';
import 'package:form/blocs/niveau-academique-bloc.dart';
import 'package:form/screen/administrateur/dashobord-admin.dart';
import 'package:form/screen/connexion/login-screen.dart';
import 'package:form/screen/connexion/login-sonde-screen.dart';
import 'package:form/screen/entreprise/dashbord-entreprise.dart';
import 'package:form/screen/homePage/index.dart';
import 'package:form/screen/sondeur/form-sondeur.dart';
import 'package:form/screen/sondeur/home-page-soneur.dart';
import 'package:form/screen/sondeur/homepage/index.dart';
import 'package:form/screen/sondeur/homepage/create-form-sondeur.dart';
import 'package:form/screen/sondeur/homepage/params-form-sondeur.dart';
import 'package:form/screen/utilistaeurs/view-formulaire-screen.dart';
import 'package:form/screen/view-form/view-form-sonde.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      name: 'formulaire-sondeur',
      path: '/formulaire-sondeur/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;

        return FutureBuilder(
          future: context
              .read<FormulaireSondeurBloc>()
              .setSelectedFormSondeurModel(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                    child: Text('Erreur lors du chargement du formulare')),
              );
            } else {
              return const FormSondeurScreen();
            }
          },
        );
      },
    ),
    GoRoute(
      name: 'formulaire-sondeur-create',
      path: '/formulaire/:id/create',
      builder: (context, state) {
        final id = state.pathParameters['id']!;

        return FutureBuilder(
          future: context
              .read<FormulaireSondeurBloc>()
              .setSelectedFormSondeurModel(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                    child: GestureDetector(
                        onTap: () => context.go("/"),
                        child: Text('Erreur lors du chargement du formulare'))),
              );
            } else {
              return const CreateFormSondeurScreen();
            }
          },
        );
      },
    ),
    GoRoute(
      name: 'formulaire-sondeur-params',
      path: '/formulaire/:id/params',
      builder: (context, state) {
        final id = state.pathParameters['id']!;

        return FutureBuilder(
          future: context
              .read<FormulaireSondeurBloc>()
              .setSelectedFormSondeurModel(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                    child: GestureDetector(
                        onTap: () => context.go("/"),
                        child: Text('Erreur lors du chargement du formulare'))),
              );
            } else {
              return const ParamsFormSondeurScreen();
            }
          },
        );
      },
    ),
    GoRoute(
      name: 'formulaire-sondeur-view',
      path: '/formulaire/:id/view',
      builder: (context, state) {
        final id = state.pathParameters['id']!;

        return FutureBuilder(
          future: context
              .read<FormulaireSondeurBloc>()
              .setSelectedFormSondeurModel(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                    child: Text('Erreur lors du chargement du formulare')),
              );
            } else {
              return Container();
            }
          },
        );
      },
    ),
    GoRoute(
      name: 'formulaire-user',
      path: '/formulaire-view/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;

        return FutureBuilder(
          future: context
              .read<FormulaireSondeurBloc>()
              .setSelectedFormSondeurModel(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                    child: Text('Erreur lors du chargement du formulare')),
              );
            } else {
              return const ViewFormulaireScreen();
            }
          },
        );
      },
    ),
    GoRoute(
      name: 'formulaire-sonde',
      path: '/formulaire-view-sonde/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        String? email = state.uri.queryParameters['email'];
        String? password = state.uri.queryParameters['password'];

        return FutureBuilder(
          future: context
              .read<FormulaireSondeurBloc>()
              .setSelectedFormSondeurModel(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                    child: Text('Erreur lors du chargement du formulare')),
              );
            } else {
              return FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.containsKey("token") &&
                          snapshot.data!.containsKey("type")) {
                        if (snapshot.data!.getString("type") == "sonde") {
                          return const ViewFormSondeScreen();
                        } else {
                          return FutureBuilder(
                              future: context
                                  .read<AuthSondeBloc>()
                                  .setEmailInit(email, password),
                              builder: (snapshot, context) {
                                return LoginSondeScreen(
                                  id: id,
                                );
                              });
                        }
                      } else {
                        return FutureBuilder(
                            future: context
                                .read<AuthSondeBloc>()
                                .setEmailInit(email, password),
                            builder: (snapshot, context) {
                              return LoginSondeScreen(
                                id: id,
                              );
                            });
                      }
                    } else {
                      return const Scaffold();
                    }
                  });
            }
          },
        );
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.getString('type') != "" &&
                snapshot.data!.containsKey("token")) {
              if (snapshot.data!.getString('type') == "admin") {
                return const DashbordAdminScreen();
              } else if (snapshot.data!.getString('type') == "entreprise") {
                return const DashbordEntrepriseScreen();
              } else if (snapshot.data!.getString('type') == "sondeur") {
                return const IndexSondeur();
              } else {
                return Container();
              }
            } else {
              return const IndexPage();
            }
          } else {
            return const IndexPage();
          }
        },
      ),
    ),
    GoRoute(
      path: '/sondeur',
      builder: (context, state) => FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.getString('type') != "" &&
                snapshot.data!.containsKey("token")) {
              if (snapshot.data!.getString('type') == "admin") {
                return const DashbordAdminScreen();
              } else if (snapshot.data!.getString('type') == "entreprise") {
                return const DashbordEntrepriseScreen();
              } else if (snapshot.data!.getString('type') == "sondeur") {
                return const IndexSondeur();
              } else {
                return Container();
              }
            } else {
              return const IndexPage();
            }
          } else {
            return const IndexPage();
          }
        },
      ),
    ),
    GoRoute(
      path: '/sign-in',
      redirect: (context, state) => Future<String>(
        () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.containsKey("token") && prefs.containsKey("type")) {
            if (prefs.getString("type") == "admin") {
              return '/admin';
            } else if (prefs.getString("type") == "entreprise") {
              return '/entreprise';
            } else if (prefs.getString("type") == "sondeur") {
              return '/';
            } else {
              return '/';
            }
          } else {
            return '/sign-in';
          }
        },
      ),
      builder: (context, state) => FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.getString('type') != "" &&
                snapshot.data!.containsKey("token")) {
              if (snapshot.data!.getString('type') == "admin") {
                return const DashbordAdminScreen();
              } else if (snapshot.data!.getString('type') == "entreprise") {
                return const DashbordEntrepriseScreen();
              } else if (snapshot.data!.getString('type') == "sondeur") {
                return const IndexSondeur();
              } else {
                return const LoginScreen();
              }
            } else {
              return const LoginScreen();
            }
          } else {
            return const LoginScreen();
          }
        },
      ),
    ),
    GoRoute(
      path: '/login',
      redirect: (context, state) => Future<String>(
        () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.containsKey("token") && prefs.containsKey("type")) {
            if (prefs.getString("type") == "admin") {
              return '/admin';
            } else if (prefs.getString("type") == "entreprise") {
              return '/entreprise';
            } else if (prefs.getString("type") == "sondeur") {
              return '/sondeur';
            } else {
              return '/';
            }
          } else {
            return '/sign-in';
          }
        },
      ),
    ),
  ],
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // ignore: prefer_const_constructors
  setUrlStrategy(PathUrlStrategy());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthBloc()),
        ChangeNotifierProvider(create: (_) => AuthSondeBloc()),
        ChangeNotifierProvider(create: (_) => AdminBloc()),
        ChangeNotifierProvider(create: (_) => MatiereBloc()),
        ChangeNotifierProvider(create: (_) => AnneeAcademiqueBloc()),
        ChangeNotifierProvider(create: (_) => NiveauAcademiqueBloc()),
        ChangeNotifierProvider(create: (_) => FormulaireBloc()),
        ChangeNotifierProvider(create: (_) => EntrepriseBloc()),
        ChangeNotifierProvider(create: (_) => FormulaireSondeurBloc()),
        ChangeNotifierProvider(create: (_) => ChampsBloc()),
        ChangeNotifierProvider(create: (_) => FormulaireReponseBloc()),
        ChangeNotifierProvider(create: (_) => FolderBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'simplon fformulaire',
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale('en'), Locale('fr')],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: createMaterialColor(noir))
                .copyWith(background: blanc),
        fontFamily: 'Roboto', // Nom de la famille déclarée dans pubspec.yaml
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black87),
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
        ),
      ),
      routerConfig: _router,
    );
  }
}
