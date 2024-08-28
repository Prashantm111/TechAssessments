import 'package:flutter/material.dart';

import '../Color.dart';

class MyButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;

  const MyButton({
    super.key,
    required this.title,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        //  width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                spreadRadius: 3,
                blurRadius: 6,
                offset: Offset(0, 5))
          ],

          color: ColorSelect.primaryColor, //Border.all
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 30.0,
            )
          ],
        ),
      ),
    );
  }
}

class AppToolBar extends StatelessWidget implements PreferredSizeWidget {
  const AppToolBar({
    super.key,
    required this.toolbarTittle,
  });

  final String toolbarTittle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: ColorSelect.primaryColor,
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(
        toolbarTittle,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(100);
}
