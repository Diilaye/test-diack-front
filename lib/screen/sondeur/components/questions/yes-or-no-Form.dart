import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class YesOrnOForm extends StatefulWidget {
  final ChampsFormulaireModel champ;
  const YesOrnOForm({super.key, required this.champ});

  @override
  State<YesOrnOForm> createState() => _YesOrnOFormState();
}

class _YesOrnOFormState extends State<YesOrnOForm> {
  bool isOpenSetting = false;
  bool isObligatoire = false;
  bool isDefaultReponse = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final formulaireSondeurBloc = Provider.of<FormulaireSondeurBloc>(context);

    return Row(
      children: [
        paddingHorizontalGlobal(size.width * .05),
        Expanded(
          child: Container(
            height: isOpenSetting
                ? widget.champ.haveResponse == '1'
                    ? 350
                    : 300
                : 220,
            decoration: BoxDecoration(color: blanc, border: Border.all()),
            child: Column(
              children: [
                paddingVerticalGlobal(8),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() {
                        isOpenSetting = !isOpenSetting;
                      }),
                      child: Container(
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
                            isOpenSetting
                                ? CupertinoIcons.clear
                                : CupertinoIcons.settings,
                            size: 14,
                            color: noir,
                          ),
                        ),
                      ),
                    ),
                    paddingHorizontalGlobal(8),
                    GestureDetector(
                      onTap: () => dialogRequest(
                              context: context,
                              title: 'Voullez-vous suprimez ce champ')
                          .then((value) {
                        if (value) {
                          formulaireSondeurBloc
                              .deleteChampFormulaire(widget.champ.id!);
                        }
                      }),
                      child: Container(
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
                    ),
                    paddingHorizontalGlobal(8)
                  ],
                ),
                Row(
                  children: [
                    paddingHorizontalGlobal(8),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController()
                          ..text = widget.champ.nom!,
                        onSubmitted: (value) => formulaireSondeurBloc
                            .updateChampFormulaireNomQuestions(
                                widget.champ.id!, value),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: noir),
                        cursorColor: noir,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Question à poser ?"),
                      ),
                    ),
                    paddingHorizontalGlobal(8),
                  ],
                ),
                Row(
                  children: [
                    paddingHorizontalGlobal(8),
                    Expanded(
                      child: Container(
                        height: 2,
                        decoration: DottedDecoration(),
                      ),
                    ),
                    paddingHorizontalGlobal(8),
                  ],
                ),
                Row(
                  children: [
                    paddingHorizontalGlobal(8),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController()
                          ..text = widget.champ.description!,
                        onSubmitted: (value) => formulaireSondeurBloc
                            .updateChampFormulaireDescriptionQuestions(
                                widget.champ.id!, value),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: noir),
                        cursorColor: noir,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Description question"),
                      ),
                    ),
                    paddingHorizontalGlobal(8),
                  ],
                ),
                Row(
                  children: [
                    paddingHorizontalGlobal(8),
                    Expanded(
                        child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: blanc,
                          border: Border.all(),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(2, 2),
                                blurRadius: .5,
                                color: noir.withOpacity(.4))
                          ]),
                      child: Row(
                        children: [
                          paddingHorizontalGlobal(),
                          Icon(CupertinoIcons.circle),
                          paddingHorizontalGlobal(),
                          Text(
                            'OUI',
                            style: TextStyle(
                                fontSize: 18,
                                color: noir,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )),
                    paddingHorizontalGlobal(),
                    Expanded(
                        child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: blanc,
                          border: Border.all(),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(2, 2),
                                blurRadius: .5,
                                color: noir.withOpacity(.4))
                          ]),
                      child: Row(
                        children: [
                          paddingHorizontalGlobal(),
                          Icon(
                            CupertinoIcons.circle,
                            color: noir,
                          ),
                          paddingHorizontalGlobal(),
                          Text(
                            'NON',
                            style: TextStyle(
                                fontSize: 18,
                                color: noir,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )),
                    paddingHorizontalGlobal(8),
                  ],
                ),
                if (isOpenSetting)
                  Column(
                    children: [
                      paddingVerticalGlobal(),
                      Row(
                        children: [
                          paddingHorizontalGlobal(8),
                          Container(
                            height: 45,
                            width: 200,
                            decoration: BoxDecoration(
                                color: gris.withOpacity(.7),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                paddingHorizontalGlobal(8),
                                Text(
                                  "réponse".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: noir),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 20,
                                  width: 45,
                                  child: Transform.scale(
                                    transformHitTests: false,
                                    scale: .7,
                                    child: CupertinoSwitch(
                                      value: widget.champ.haveResponse == '1'
                                          ? true
                                          : false,
                                      activeColor: btnColor,
                                      onChanged: (value) {
                                        formulaireSondeurBloc
                                            .updateChampFormulaireHaveReponseQuestions(
                                                widget.champ.id!,
                                                widget.champ.haveResponse == '1'
                                                    ? '0'
                                                    : '1');
                                        setState(() {
                                          isDefaultReponse = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                paddingHorizontalGlobal(8),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 45,
                            width: 200,
                            decoration: BoxDecoration(
                                color: gris.withOpacity(.7),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                paddingHorizontalGlobal(8),
                                Text(
                                  "Obligatoire".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: noir),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 20,
                                  width: 45,
                                  child: Transform.scale(
                                    transformHitTests: false,
                                    scale: .7,
                                    child: CupertinoSwitch(
                                      value: widget.champ.isObligatoire == '1'
                                          ? true
                                          : false,
                                      activeColor: btnColor,
                                      onChanged: (value) {
                                        formulaireSondeurBloc
                                            .updateChampFormulaireObligatoireQuestions(
                                                widget.champ.id!,
                                                widget.champ.isObligatoire ==
                                                        '1'
                                                    ? '0'
                                                    : '1');
                                        setState(() {
                                          isObligatoire = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                paddingHorizontalGlobal(8),
                              ],
                            ),
                          ),
                          paddingHorizontalGlobal(8),
                        ],
                      ),
                      paddingVerticalGlobal(),
                      if (widget.champ.haveResponse == '1')
                        Row(
                          children: [
                            paddingHorizontalGlobal(8),
                            Expanded(
                                child: GestureDetector(
                              onTap: () => formulaireSondeurBloc
                                  .addChampFormulaireResponseTextField(
                                      widget.champ.id!,
                                      widget.champ.listeOptions![0].id!,
                                      widget.champ.listeOptions![0].option!),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: blanc,
                                    border: Border.all(),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(2, 2),
                                          blurRadius: .5,
                                          color: noir.withOpacity(.4))
                                    ]),
                                child: Row(
                                  children: [
                                    paddingHorizontalGlobal(),
                                    Icon(
                                      widget.champ.listeReponses![0].id! ==
                                              widget.champ.listeOptions![0].id!
                                          ? CupertinoIcons.circle_fill
                                          : CupertinoIcons.circle,
                                      color: noir,
                                    ),
                                    paddingHorizontalGlobal(),
                                    Text(
                                      'OUI',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: noir,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            )),
                            paddingHorizontalGlobal(),
                            Expanded(
                                child: GestureDetector(
                              onTap: () => formulaireSondeurBloc
                                  .addChampFormulaireResponseTextField(
                                      widget.champ.id!,
                                      widget.champ.listeOptions![1].id!,
                                      widget.champ.listeOptions![1].option!),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: blanc,
                                    border: Border.all(),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(2, 2),
                                          blurRadius: .5,
                                          color: noir.withOpacity(.4))
                                    ]),
                                child: Row(
                                  children: [
                                    paddingHorizontalGlobal(),
                                    Icon(
                                      widget.champ.listeReponses![0]!.id! ==
                                              widget.champ.listeOptions![1].id!
                                          ? CupertinoIcons.circle_fill
                                          : CupertinoIcons.circle,
                                      color: noir,
                                    ),
                                    paddingHorizontalGlobal(),
                                    Text(
                                      'NON',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: noir,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            )),
                            paddingHorizontalGlobal(),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = widget.champ.notes!,
                                onSubmitted: (value) => formulaireSondeurBloc
                                    .updateChampFormulaireNotesQuestions(
                                        widget.champ.id!, value),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: noir),
                                cursorColor: noir,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(),
                                    hintText: "Note"),
                              ),
                            ),
                            paddingHorizontalGlobal(8)
                          ],
                        )
                    ],
                  ),
                paddingVerticalGlobal(8),
              ],
            ),
          ),
        ),
        paddingHorizontalGlobal(size.width * .05),
      ],
    );
  }
}
