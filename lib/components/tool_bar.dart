import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_styles.dart';
import 'package:smart_home/styles/app_text.dart';

class ToolBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? action;

  const ToolBar({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppStyles.paddingBothSidesPage),
        child: Column(
          children: [
            const Spacer(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => {context.pop(true)},
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          color: AppColors.black.withOpacity(0.7)),
                      child: const Icon(
                        Icons.arrow_back_ios_sharp,
                        size: 15,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: AppText.heading4.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.black.withOpacity(0.8)),
                  ),
                  action ??
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            color: AppColors.black.withOpacity(0)),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(
        70,
      );
}
