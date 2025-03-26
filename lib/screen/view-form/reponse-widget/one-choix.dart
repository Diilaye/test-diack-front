import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-reponse-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class OneChoixReponseWidget extends StatelessWidget {
  final ChampsFormulaireModel champ;

  const OneChoixReponseWidget({super.key, required this.champ});

  @override
  Widget build(BuildContext context) {
    final formulaireReponseBloc = Provider.of<FormulaireReponseBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                champ.nom!,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
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
          paddingVerticalGlobal(),
          ...champ.listeOptions!
              .map((el) => Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('formulaireReponseBloc.addReponseOneChoice');
                          formulaireReponseBloc.addReponseMultiChoice(
                              el.toJson(), champ.toJson());
                        },
                        child: Icon(
                          formulaireReponseBloc.reponseOneChoice['id'] == el.id
                              ? Icons.circle
                              : Icons.circle_outlined,
                          size: 14,
                        ),
                      ),
                      paddingHorizontalGlobal(8),
                      Text(el.option!)
                    ],
                  ))
              .toList(),
        ],
      ),
    );
  }
}
