import 'package:flutter/cupertino.dart';
import 'package:form/utils/colors-by-dii.dart';

class overviewStatWidget extends StatelessWidget {
  final String title;
  final String chiffre;
  final String estimation;
  final String description;
  const overviewStatWidget(
      {super.key,
      required this.title,
      required this.chiffre,
      required this.estimation,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: blanc,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 0),
                blurRadius: 1,
                color: noir.withOpacity(.2))
          ]),
      child: Column(
        children: [
          const SizedBox(
            height: 4,
          ),
          Expanded(
              child: Row(
            children: [
              const SizedBox(
                width: 4,
              ),
              Text(title.toUpperCase())
            ],
          )),
          const SizedBox(
            height: 4,
          ),
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    chiffre,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    width: 8,
                    decoration: BoxDecoration(
                        color: gris.withOpacity(.5),
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        const Spacer(),
                        Container(
                          width: 8,
                          height: 0,
                          decoration: BoxDecoration(
                              color: vertFonce,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: 8,
                    decoration: BoxDecoration(
                        color: gris.withOpacity(.5),
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        const Spacer(),
                        Container(
                          width: 8,
                          height: 0,
                          decoration: BoxDecoration(
                              color: vertFonce,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: 8,
                    decoration: BoxDecoration(
                        color: gris.withOpacity(.5),
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        const Spacer(),
                        Container(
                          width: 8,
                          height: 0,
                          decoration: BoxDecoration(
                              color: vertFonce,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: 8,
                    decoration: BoxDecoration(
                        color: gris.withOpacity(.5),
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        const Spacer(),
                        Container(
                          width: 8,
                          height: 40,
                          decoration: BoxDecoration(
                              color: vertFonce,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  )
                ],
              )),
          const SizedBox(
            height: 4,
          ),
          Expanded(
              child: Row(
            children: [
              const SizedBox(
                width: 4,
              ),
              Container(
                  height: 25,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: vert.withOpacity(.4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: vert),
                        child: Center(
                          child: ImageIcon(
                            const AssetImage("assets/images/evolution.png"),
                            size: 10,
                            color: blanc,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "$estimation%",
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  )),
              const SizedBox(
                width: 8,
              ),
              Text(
                description,
                style: TextStyle(fontSize: 8),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          )),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    ));
  }
}
