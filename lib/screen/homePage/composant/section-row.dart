import 'package:flutter/material.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';

class SectionRowBtn extends StatelessWidget {
  final String title;
  final String type;
  final String text;
  final String image;
  final Function() onPressed;
  const SectionRowBtn(
      {super.key,
      this.title = "Créer un formulaire aimable.",
      required this.image,
      required this.onPressed,
      this.text =
          "Tapez du texte stylisé, téléchargez des images, intégrez des vidéos et personnalisez votre formulaire avec des médias, des couleurs et des polices.",
      this.type = "gauche"});

  @override
  Widget build(BuildContext context) {
    return type == "gauche"
        ? SizedBox(
            height: 450,
            child: Row(
              children: [
                // Section gauche : image
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            image, // Remplacez par votre image
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: primary
                                .withOpacity(0.5), // Effet de transparence
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Section droite : texte et boutons
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => onPressed(),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text("Se connecter".toUpperCase()),
                            ),
                            // SizedBox(width: 16),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     print("Sign up clicked");
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     foregroundColor: Colors.white,
                            //     backgroundColor: Colors.black,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(8),
                            //     ),
                            //   ),
                            //   child: Text("S'inscrire".toUpperCase()),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 450,
            child: Row(
              children: [
                // Section gauche : texte et boutons
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print("Login clicked");
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text("Se connecter".toUpperCase()),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                print("Sign up clicked");
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text("S'inscrire".toUpperCase()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Section droite : image
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            image, // Remplacez par votre image
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: Colors.black
                                .withOpacity(0.5), // Effet de transparence
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class SectionRowText extends StatelessWidget {
  final String type;
  final String title;
  final String text;
  final String image;
  const SectionRowText(
      {super.key,
      this.title = "Facile à réaliser",
      this.type = "gauche",
      required this.text,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return type == "gauche"
        ? SizedBox(
            height: 450,
            child: Row(
              children: [
                // Section image à droite
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      // Image de fond
                      Positioned.fill(
                        child: Image.network(
                          image, // Remplacez par votre image
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Overlay foncé
                      Positioned.fill(
                        child: Container(
                          color: primary.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
                // Section texte à gauche
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        paddingVerticalGlobal(),

                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                        paddingVerticalGlobal(),

                        // Ligne décorative rouge
                        Container(
                          width: 50,
                          height: 2,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 450,
            child: Row(
              children: [
                // Section texte à gauche
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        paddingVerticalGlobal(),
                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                        paddingVerticalGlobal(),

                        // Ligne décorative rouge
                        Container(
                          width: 50,
                          height: 2,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
                // Section image à droite
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      // Image de fond
                      Positioned.fill(
                        child: Image.network(
                          image, // Remplacez par votre image
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Overlay foncé
                      Positioned.fill(
                        child: Container(
                          color: primary.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
