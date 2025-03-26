import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-reponse-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/models/response-sondeur-model.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';
import 'dart:html';

class MultiChoiceWidget extends StatelessWidget {
  final ChampsFormulaireModel champ;
  const MultiChoiceWidget({super.key, required this.champ});

  @override
  Widget build(BuildContext context) {
    final formulaireReponseBloc = Provider.of<FormulaireReponseBloc>(context);

    return FutureBuilder<List<ReponseSondeurModel>>(
        future: formulaireReponseBloc.getResponseSonde(champ.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        champ.nom!,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                      paddingHorizontalGlobal(8),
                      if (champ.isObligatoire == '1')
                        Icon(
                          Icons.star,
                          size: 10,
                          color: rouge,
                        ),
                      const Spacer(),
                      Text('(${champ.notes!})')
                    ],
                  ),
                  paddingHorizontalGlobal(32),
                  ...champ.listeOptions!
                      .map(
                        (el) => FutureBuilder(
                          builder: (context, state) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    print('rff');
                                    print(snapshot.data!
                                            .firstWhere(
                                                (e) =>
                                                    e.responseEtatID == el.id,
                                                // ignore: unnecessary_null_comparison
                                                orElse: () =>
                                                    ReponseSondeurModel(id: ""))
                                            .id !=
                                        "");
                                    if (snapshot.data!
                                            .firstWhere(
                                                (e) =>
                                                    e.responseEtatID == el.id,
                                                // ignore: unnecessary_null_comparison
                                                orElse: () =>
                                                    ReponseSondeurModel(id: ""))
                                            .id !=
                                        "") {
                                      await formulaireReponseBloc
                                          .removeResponseSonde(
                                              champ.id!,
                                              snapshot.data!
                                                  .firstWhere(
                                                      (e) =>
                                                          e.responseEtatID ==
                                                          el.id,
                                                      // ignore: unnecessary_null_comparison
                                                      orElse: () =>
                                                          ReponseSondeurModel(
                                                              id: ""))
                                                  .responseID!);
                                      window.location.reload();
                                    } else {
                                      formulaireReponseBloc
                                          .addReponseMultiChoice(
                                              el.toJson(), champ.toJson());
                                    }
                                  },
                                  child: Icon(
                                    snapshot.data!
                                                .firstWhere(
                                                    (e) =>
                                                        e.responseEtatID ==
                                                        el.id,
                                                    // ignore: unnecessary_null_comparison
                                                    orElse: () =>
                                                        ReponseSondeurModel(
                                                            id: ""))
                                                .id !=
                                            ""
                                        ? Icons.square
                                        : formulaireReponseBloc
                                                .reponseMultiChoice
                                                .where(
                                                    (et) => et['id'] == el.id)
                                                .isEmpty
                                            ? Icons.square_outlined
                                            : Icons.square,
                                    size: 14,
                                  ),
                                ),
                                paddingHorizontalGlobal(8),
                                Text(el.option!)
                              ],
                            );
                          },
                          future: null,
                        ),
                      )
                      .toList(),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
