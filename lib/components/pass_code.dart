import 'package:flutter/material.dart';
import 'package:smart_home/styles/app_colors.dart';

class PassCode extends StatelessWidget {
  const PassCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) => FormCode()),
          ),
        ),
      ],
    );
  }
}

class FormCode extends StatefulWidget {
  const FormCode({super.key});

  @override
  State<FormCode> createState() => _FormCodeState();
}

class _FormCodeState extends State<FormCode> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      alignment: Alignment.center,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.white,
      ),
      child: TextField(
        textAlign: TextAlign.center,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: TextStyle(fontSize: 30),
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}
