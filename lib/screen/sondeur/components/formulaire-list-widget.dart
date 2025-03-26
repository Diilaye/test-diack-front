import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/formulaire-sondeur-model.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/get-date-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FormulaireListWidget extends StatelessWidget {
  final FormulaireSondeurModel formulaireSondeur;
  const FormulaireListWidget({super.key, required this.formulaireSondeur});

  @override
  Widget build(BuildContext context) {
    final formulaireSondeurBloc = Provider.of<FormulaireSondeurBloc>(context);
    return Container(
      height: 110,
      decoration: BoxDecoration(
          color: blanc,
          borderRadius: BorderRadius.circular(6),
          border: Border(
            left: BorderSide(
                color: formulaireSondeur.folderForm != null
                    ? formulaireSondeur.folderForm!.color!.toColor()
                    : blanc,
                width: 10),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.2),
                blurRadius: 5,
                offset: Offset(2, 2))
          ]),
      child: Row(
        children: [
          paddingHorizontalGlobal(),
          IconButton(
              onPressed: () => null,
              icon: Icon(
                CupertinoIcons.square,
                color: noir,
                size: 24,
              )),
          IconButton(
              onPressed: () => null,
              icon: Icon(
                CupertinoIcons.star,
                color: noir,
                size: 24,
              )),
          paddingHorizontalGlobal(),
          SizedBox(
            height: 80,
            width: 320,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        formulaireSondeur.titre!,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rubik'),
                      ),
                    ],
                  ),
                  paddingVerticalGlobal(4),
                  Row(
                    children: [
                      Text(
                        'Créer le ${showDate(formulaireSondeur.date!)}',
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Roboto'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: primary,
          ),
          const Spacer(),
          Container(
            height: 32,
            // width: 240,
            decoration: BoxDecoration(
                color: gris, borderRadius: BorderRadius.circular(6)),
            child: Row(
              children: [
                paddingHorizontalGlobal(4),
                Text(
                  ' Voir les réponses (12) ',
                  style: TextStyle(
                      color: noir, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                paddingHorizontalGlobal(4),
              ],
            ),
          ),
          paddingHorizontalGlobal(),
          IconButton(
              onPressed: () {
                formulaireSondeurBloc
                    .setSelectedFormSondeurModel(formulaireSondeur);

                context.go('/formulaire/${formulaireSondeur.id}/view');
              },
              iconSize: 24,
              icon: Icon(CupertinoIcons.eye)),
          IconButton(
              onPressed: () {
                formulaireSondeurBloc
                    .setSelectedFormSondeurModel(formulaireSondeur);

                context.go('/formulaire/${formulaireSondeur.id}/create');
              },
              iconSize: 24,
              icon: Icon(CupertinoIcons.pencil)),
          IconButton(
              onPressed: () => print('Show'),
              iconSize: 24,
              icon: Icon(CupertinoIcons.share)),
          IconButton(
              onPressed: () => print('Show'),
              iconSize: 24,
              icon: Icon(CupertinoIcons.archivebox)),
          IconButton(
              onPressed: () => print('Show'),
              iconSize: 24,
              icon: Icon(
                CupertinoIcons.delete,
                color: rouge,
              )),
          paddingHorizontalGlobal(),
        ],
      ),
    );
  }
}
