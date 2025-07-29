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
import 'package:form/screen/sondeur/homepage/index.dart';
import 'package:form/screen/sondeur/homepage/create-form-sondeur.dart';
import 'package:form/screen/sondeur/homepage/params-form-sondeur.dart';
import 'package:form/screen/sondeur/homepage/share-form-sondeur.dart';
import 'package:form/screen/shared/shared-form-access-page.dart';
import 'package:form/screen/shared/form-share-test-page.dart';
import 'package:form/screen/shared/form-response-page.dart' as FormResponse;
import 'package:form/screen/shared/form-test-routes-page.dart';
import 'package:form/screen/shared/apercu-test-page.dart';
import 'package:form/screen/shared/sonde-response-page.dart';
import 'package:form/screen/shared/formulaire-results-page.dart';
import 'package:form/screen/sonde-test-page.dart';
import 'package:form/screen/utilistaeurs/view-formulaire-screen.dart';
import 'package:form/screen/view-form/view-form-sonde.dart';
import 'package:form/utils/app_theme.dart';
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
      name: 'formulaire-sondeur-share',
      path: '/formulaire/:id/share',
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
              return const ShareFormSondeurScreen();
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
      name: 'form-response',
      path: '/form/:id',
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Formulaire introuvable'),
                      const SizedBox(height: 8),
                      Text('ID: $id'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/'),
                        child: const Text('Retour à l\'accueil'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              final formulaire =
                  context.read<FormulaireSondeurBloc>().formulaireSondeurModel;
              if (formulaire != null) {
                return FormResponse.FormResponsePage(
                  shareId:
                      'direct-$id', // ID de partage généré pour l'accès direct
                  formulaire: formulaire,
                );
              } else {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning_outlined,
                            size: 64, color: Colors.orange),
                        const SizedBox(height: 16),
                        const Text('Formulaire non disponible'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.go('/'),
                          child: const Text('Retour à l\'accueil'),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          },
        );
      },
    ),
    GoRoute(
      name: 'shared-form',
      path: '/form/share/:shareId',
      builder: (context, state) {
        final shareId = state.pathParameters['shareId']!;

        return SharedFormAccessPage(shareId: shareId);
      },
    ),
    GoRoute(
      name: 'sonde-response',
      path: '/sonde/formulaire/:formulaireId',
      builder: (context, state) {
        final formulaireId = state.pathParameters['formulaireId']!;

        return SondeResponsePage(
          sondeId: "sondeId",
          formulaireId: formulaireId,
        );
      },
    ),
    GoRoute(
      name: 'formulaire-results',
      path: '/formulaire/:formulaireId/results',
      builder: (context, state) {
        final formulaireId = state.pathParameters['formulaireId']!;

        return FormulaireResultsPage(
          formulaireId: formulaireId,
        );
      },
    ),
    GoRoute(
      name: 'sonde-test',
      path: '/sonde-test',
      builder: (context, state) {
        return const SondeTestPage();
      },
    ),
    GoRoute(
      name: 'apercu-test',
      path: '/apercu-test',
      builder: (context, state) {
        return const ApercuTestPage();
      },
    ),
    GoRoute(
      name: 'test-form-routes',
      path: '/test-form-routes',
      builder: (context, state) {
        return const FormTestRoutesPage();
      },
    ),
    GoRoute(
      name: 'test-shared-forms',
      path: '/test-shared-forms',
      builder: (context, state) {
        return const FormShareTestPage();
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
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
