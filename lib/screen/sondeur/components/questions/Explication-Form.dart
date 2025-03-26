import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class ExplicationForm extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const ExplicationForm({super.key, required this.champ});

  @override
  State<ExplicationForm> createState() => _ExplicationFormState();
}

class _ExplicationFormState extends State<ExplicationForm> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final formulaireSondeurBloc = Provider.of<FormulaireSondeurBloc>(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: blanc,
            ),
            child: Column(
              children: [
                paddingVerticalGlobal(8),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: blanc,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(2, 2),
                                blurRadius: 2,
                                color: noir.withOpacity(.4))
                          ]),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.delete,
                          size: 14,
                          color: rouge,
                        ),
                      ),
                    ),
                    paddingHorizontalGlobal(size.width * .05),
                  ],
                ),
                paddingVerticalGlobal(),
                Row(
                  children: [
                    paddingHorizontalGlobal(size.width * .05),
                    Expanded(
                      child: SizedBox(
                        child: TextField(
                          onSubmitted: (value) => formulaireSondeurBloc
                              .updateChampFormulaireNomQuestions(
                                  widget.champ.id!, value),
                          minLines:
                              6, // any number you need (It works as the rows for the textarea)
                          keyboardType: TextInputType.multiline,
                          maxLines: null,

                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: noir),
                          controller: TextEditingController()
                            ..text = widget.champ.nom!,

                          cursorColor: noir,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              labelText: "Zone d'Explication",
                              hintText: ""),
                        ),
                      ),
                    ),
                    paddingHorizontalGlobal(size.width * .05),
                  ],
                ),
                paddingVerticalGlobal(8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
