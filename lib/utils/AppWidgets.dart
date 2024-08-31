import 'package:flutter/material.dart';
import 'package:techassesment/data/UserInfo.dart';
import 'package:techassesment/resource/HeightAndWidth.dart';

import '../resource/Color.dart';


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
  Size get preferredSize => const Size.fromHeight(HeightAndWidth.toolBarHeight);
}

class CenterProgressLoader extends StatelessWidget {
  final Color backgroundColor;
  final MaterialColor color;
  final double strokeWidth;

  const CenterProgressLoader({
    super.key,
    this.backgroundColor = Colors.black,
    this.color = Colors.amber,
    this.strokeWidth = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black,
              spreadRadius: 5,
              blurRadius: 30,
              offset: Offset(0, 5))
        ],

        color: Colors.white, //Border.all
        borderRadius: BorderRadius.circular(5),
      ),
      child: CircularProgressIndicator(
        backgroundColor: backgroundColor,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class PriceCardItem extends StatelessWidget {
  final int price;
  final VoidCallback callback;

  const PriceCardItem({
    super.key,
    required this.price,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(8)),
        child: Text(
          "AED $price",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

String getInitials(String name) => name.isNotEmpty
    ? name.trim().split(' ').map((l) => l[0]).take(2).join()
    : '';

Column UserProfileCardItem(BuildContext context, UserInfoModel userinfo) {
  String userStatus = "";
  if (userinfo.status! == "1") {
    userStatus = "Verified";
  } else {
    userStatus = "Non-Verified";
  }


  return Column(
    children: [
      Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            getInitials(userinfo.name!),
            style: const TextStyle(color: Colors.white, fontSize: 35),
          ),
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      Text(
        userinfo.name!,
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      Text(
        userinfo.number!,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      Text(
        userStatus,
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
