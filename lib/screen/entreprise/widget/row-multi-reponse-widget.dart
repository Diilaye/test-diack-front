import 'package:flutter/material.dart';
import 'package:form/utils/colors-by-dii.dart';

class RowMultiReponseWidget extends StatelessWidget {
  final String title;
  final String titleObject;
  final int nombreReponse;
  final List<String> listeReponse;
  final Function ontap;
  final bool isActive;
  const RowMultiReponseWidget(
      {super.key,
      required this.title,
      required this.titleObject,
      required this.nombreReponse,
      required this.listeReponse,
      required this.ontap,
      this.isActive = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 2,
              ),
              Expanded(
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: noir, width: .5)),
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * .2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  titleObject,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: noir,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        color: noir,
                      ),
                      Expanded(
                        child: Row(
                          children: listeReponse
                              .map((s) => Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  color: noir, width: .5))),
                                      child: Center(
                                        child: Text(s),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 2,
              ),
              Expanded(
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: noir, width: .5)),
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * .2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: noir,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        color: noir,
                      ),
                      Expanded(
                        child: Row(
                          children: List.generate(nombreReponse, (int index) {
                            return Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: noir, width: .5))),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => ontap(),
                                    child: Center(
                                      child: Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: noir)),
                                        child: Center(
                                          child: Container(
                                            height: 10,
                                            width: 10,
                                            color: isActive ? noir : blanc,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
