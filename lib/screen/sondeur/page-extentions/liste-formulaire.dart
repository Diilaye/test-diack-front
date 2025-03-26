import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form/blocs/folder-bloc.dart';
import 'package:form/blocs/formulaire-bloc.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/folder-model.dart';
import 'package:form/screen/sondeur/components/formulaire-list-widget.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class ListeFormulaireSection extends StatelessWidget {
  const ListeFormulaireSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);
    final folderBloc = Provider.of<FolderBloc>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          paddingVerticalGlobal(8),
          SizedBox(
            height: 64,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Text(
                  "${folderBloc.folder == null ? "Mes formulaires" : folderBloc.folder!.titre}"
                      .toUpperCase(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rubik'),
                ),
                paddingHorizontalGlobal(),
                if (folderBloc.folder != null)
                  Text(
                    "créer par (${folderBloc.folder == null ? "" : folderBloc.folder!.userCreate!.nom} ${folderBloc.folder == null ? "" : folderBloc.folder!.userCreate!.prenom})"
                        .toLowerCase(),
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'roboto'),
                  ),
                paddingHorizontalGlobal(),
                paddingHorizontalGlobal(),
                GestureDetector(
                  onTap: () => formulaireSondeur.addFormSondeur(
                      folderBloc.folder == null ? "" : folderBloc.folder!.id!),
                  child: Container(
                    height: 42,
                    width: 150,
                    decoration: BoxDecoration(
                        color: btnColor,
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: formulaireSondeur.chargement
                          ? CircularProgressIndicator(
                              color: blanc,
                              backgroundColor: btnColor,
                            )
                          : Text(
                              'Créer un formulaire',
                              style: TextStyle(
                                  color: blanc,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                paddingHorizontalGlobal(),
              ],
            ),
          ),
          paddingVerticalGlobal(16),
          Expanded(
              child: ListView(
                  children: formulaireSondeur.formulaires
                      .where((e) {
                        if (e.archived == '1' || e.deleted == '1') {
                          return false;
                        } else {
                          if (folderBloc.folder == null) {
                            return true;
                          } else {
                            if (e.folderForm == null) {
                              return false;
                            } else {
                              return e.folderForm!.id! == folderBloc.folder?.id;
                            }
                          }
                        }
                      })
                      .map((e) => Column(
                            children: [
                              paddingVerticalGlobal(16),
                              FormulaireListWidget(
                                formulaireSondeur: e,
                              ),
                            ],
                          ))
                      .toList()
                  // [
                  //   paddingVerticalGlobal(16),
                  //   const ,
                  //   paddingVerticalGlobal(16),
                  //   const FormulaireListWidget(
                  //     isfolder: true,
                  //   ),
                  //   paddingVerticalGlobal(16),
                  //   const FormulaireListWidget(),
                  // ],
                  ))
        ],
      ),
    );
  }
}
