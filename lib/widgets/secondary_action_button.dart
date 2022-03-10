import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';

class SecondaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SecondaryActionButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: FightClubColors.darkGreyText, width: 2),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: FightClubColors.darkGreyText,
          ),
        ),
      ),
    );
  }
}
