import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';

class FightResultWidget extends StatelessWidget {
  // передаем на вход данные из FightResult()
  final FightResult fightResult;

  const FightResultWidget({
    Key? key,
    required this.fightResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: ColoredBox(color: Colors.white)),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, FightClubColors.darkPurple],
                    ),
                  ),
                ),
              ),
              Expanded(child: ColoredBox(color: FightClubColors.darkPurple)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You",
                    style: TextStyle(
                      color: FightClubColors.darkGreyText,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 92,
                    width: 92,
                    child: Image.asset(FightClubImages.youAvatar),
                  ),
                ],
              ),
              Container(
                height: 44,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: fightResult.color,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    fightResult.result.toLowerCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You",
                    style: TextStyle(
                      color: FightClubColors.darkGreyText,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 92,
                    width: 92,
                    child: Image.asset(FightClubImages.enemyAvatar),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
