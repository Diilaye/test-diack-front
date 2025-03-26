import 'package:flutter/material.dart';
import 'package:form/responsive.dart';
import 'package:form/utils/colors-by-dii.dart';

class AppBarIndex extends StatelessWidget implements PreferredSizeWidget {
  const AppBarIndex({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Responsive.isDesktop(context)
        ? AppBar(
            title: Text('Simplon formulaire'.toUpperCase()),
            backgroundColor: secondary1,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: size.width * .1,
                  height: size.height * .1,
                  decoration: BoxDecoration(
                      color: secondary1,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      'Services',
                      style: TextStyle(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: size.width * .1,
                  height: size.height * .1,
                  decoration: BoxDecoration(
                      color: secondary1,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      'Templates',
                      style: TextStyle(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: size.width * .1,
                  height: size.height * .1,
                  decoration: BoxDecoration(
                      color: secondary1,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      'Reseaux',
                      style: TextStyle(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: size.width * .1,
                  height: size.height * .1,
                  decoration: BoxDecoration(
                      color: secondary1,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      'Contact',
                      style: TextStyle(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
            centerTitle: false,
            titleTextStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w500),
          )
        : Responsive.isTablet(context)
            ? AppBar(
                title: Text('Simplon formulaire'.toUpperCase()),
                backgroundColor: secondary1,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width * .1,
                      height: size.height * .1,
                      decoration: BoxDecoration(
                          color: secondary1,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          'Services',
                          style: TextStyle(
                              color: primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width * .1,
                      height: size.height * .1,
                      decoration: BoxDecoration(
                          color: secondary1,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          'Templates',
                          style: TextStyle(
                              color: primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width * .1,
                      height: size.height * .1,
                      decoration: BoxDecoration(
                          color: secondary1,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          'Reseaux',
                          style: TextStyle(
                              color: primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width * .1,
                      height: size.height * .1,
                      decoration: BoxDecoration(
                          color: secondary1,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          'Contact',
                          style: TextStyle(
                              color: primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
                centerTitle: false,
                titleTextStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              )
            : AppBar(
                title: Text('Simplon formulaire'.toUpperCase()),
                backgroundColor: secondary1,
                leading: Icon(Icons.menu),
                centerTitle: true,
                titleTextStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
