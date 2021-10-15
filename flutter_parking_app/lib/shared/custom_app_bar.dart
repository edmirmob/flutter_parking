import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final String title;
  final double elevation;
  final bool arrowBack;
  final String textLeading;
  final List<Widget> actions;
  CustomAppBar(
      {this.title,
      this.elevation,
      this.arrowBack,
      this.textLeading,
      this.actions});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: Color.fromRGBO(108, 99, 255, 1),
      toolbarHeight: 60,
      actions: actions,
      elevation: elevation ?? theme.appBarTheme.elevation,
      automaticallyImplyLeading: false,
      leadingWidth: 120,
      leading: arrowBack == true
          ? IconButton(
              icon: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  textLeading != null
                      ? Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              textLeading,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
              color: Color.fromARGB(255, 81, 142, 222),
              onPressed: () {
                Navigator.maybePop(context);
              })
          : null,
      title: title != null
          ? Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            )
          : Container(),
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 81, 142, 222),
      ),
    );
  }
}
