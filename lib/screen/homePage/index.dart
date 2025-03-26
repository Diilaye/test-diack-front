import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form/screen/homePage/composant/appbar.dart';
import 'package:form/screen/homePage/composant/section-row.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:go_router/go_router.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarIndex(),
      backgroundColor: blanc,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: ListView(
          children: [
            paddingVerticalGlobal(),
            SectionRowBtn(
              image:
                  "https://forms.app/assets/img/home/form-builder-home-hero-en.png",
              onPressed: () {
                if (kDebugMode) {
                  print("onPressed");
                }
                context.go('/login');
              },
            ),
            paddingVerticalGlobal(),
            const SectionRowText(
                image:
                    "https://forms.app/assets/img/home/form-builder-home-hero-en.png",
                title: "Facile à utiliser",
                type: "droite",
                text:
                    "faites des choses pour les gens et vous obtiendrez plus de données."
                    "fonctionne très bien sur tous les appareils"),
            paddingVerticalGlobal(),
            const SectionRowText(
              image:
                  "https://forms.app/assets/img/home/form-builder-home-hero-en.png",
              title: "Facile à utiliser",
              type: "gauche",
              text:
                  "Commencez simplement à taper, comme un bloc-notes. Typeform anticipe les types de questions au fur et à mesure que vous les notez."
                  "Attirez votre audience grâce à de nombreuses options de conception et fonctionnalités avancées.\n\n"
                  "Sachez toujours à quoi ressemble votre police de caractères grâce à Live Preview",
            ),
            paddingVerticalGlobal()
          ],
        ),
      ),
    );
  }
}
