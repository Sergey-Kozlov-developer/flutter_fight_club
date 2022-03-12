import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_icons.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);

  @override
  _FightPageState createState() => _FightPageState();
}

class _FightPageState extends State<FightPage> {
  static const maxLives = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  // параметры атаки и защиты компьютерного бота
  BodyPart whatEnemyAttack = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  // для уменьшения жизней
  int yourLives = maxLives;
  int enemysLives = maxLives;

  String centerText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
              maxLivesCount: maxLives,
              yourLivesCount: yourLives,
              enemysLivesCount: enemysLives,
            ),
            const SizedBox(height: 11),
            // центрльное растояние между верхом и низом
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 30),
                child: SizedBox(
                  height: 146,
                  width: double.infinity,
                  child: ColoredBox(
                    color: Color.fromRGBO(197, 209, 234, 1),
                    child: Center(
                      child: Text(
                        centerText,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: FightClubColors.darkGreyText),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ControlsWidget(
              defendingBodyPart: defendingBodyPart,
              selectDefendingBodyPart: _selectDefendingBodyPart,
              attackingBodyPart: attackingBodyPart,
              selectAttackingBodyPart: _selectAttackingBodyPart,
            ),
            const SizedBox(height: 14),
            ActionButton(
              text:
                  yourLives == 0 || enemysLives == 0 ? "Start new game" : "Go",
              onTap: _onGoButtonClick,
              color: _getGoButtonColor(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getGoButtonColor() {
    if (yourLives == 0 || enemysLives == 0) {
      return const Color.fromRGBO(0, 0, 0, 0.87);
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      return Colors.black38;
    } else {
      return const Color.fromRGBO(0, 0, 0, 0.87);
    }
  }

  void _onGoButtonClick() {
    // кто победил и кто проиграл, надпись о начале игре
    // обновление состояния после окончания жизней
    if (yourLives == 0 || enemysLives == 0) {
      Navigator.of(context).pop();
    } else if (attackingBodyPart != null && defendingBodyPart != null) {
      setState(() {
        /* Логика защиты и атаки*/
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool yourLoseLife = defendingBodyPart != whatEnemyAttack;
        if (enemyLoseLife) {
          enemysLives -= 1;
        }
        if (yourLoseLife) {
          yourLives -= 1;
        }
        // сохранение результата в sharedPreferences
        final FightResult? fightResult =
            FightResult.calculateResult(yourLives, enemysLives);
        if (fightResult != null) {
          SharedPreferences.getInstance().then((sharedPreferences) {
            sharedPreferences.setString(
                "last_fight_result", fightResult.result);
            // сохранеие результата битвы для вывода на главный экран
            final String key = "stats_${fightResult.result.toLowerCase()}";
            final int currentValue = sharedPreferences.getInt(key) ?? 0;
            sharedPreferences.setInt(key, currentValue + 1);
          });
        }
        // изменение текста при ударе и блокировки в центре экрана
        centerText = _calculateCenterText(yourLoseLife, enemyLoseLife);

        whatEnemyDefends = BodyPart.random();
        whatEnemyAttack = BodyPart.random();
        /*Конец Логика защиты и атаки */

        attackingBodyPart = null;
        defendingBodyPart = null;
      });
    }
  }

  String _calculateCenterText(
      final bool yourLoseLife, final bool enemyLoseLife) {
    // изменение текста при ударе и блокировки в центре экрана
    if (enemysLives == 0 && yourLives == 0) {
      return "Draw";
    } else if (yourLives == 0) {
      return "You lost";
    } else if (enemysLives == 0) {
      return "You won";
    } else {
      final String first = enemyLoseLife
          ? "You hit enemy's ${attackingBodyPart!.name.toLowerCase()}."
          : "Your attack was blocked.";

      final String second = yourLoseLife
          ? "Enemy hit your ${whatEnemyAttack.name.toLowerCase()}."
          : "Enemy's attack was blocked.";

      return "$first\n$second";
    }
  }

  void _selectDefendingBodyPart(BodyPart value) {
    // обновление состояния после окончания жизней
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(BodyPart value) {
    // обновление состояния после окончания жизней
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }
}

class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemysLivesCount;

  const FightersInfo({
    Key? key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemysLivesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LivesWidget(
                overallLivesCount: maxLivesCount,
                currentLivesCount: yourLivesCount,
              ),
              Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    "You",
                    style: TextStyle(
                      color: FightClubColors.darkGreyText,
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 92,
                    width: 92,
                    child: Image.asset(FightClubImages.youAvatar),
                  ),

                  // ColoredBox(
                  //   color: Colors.red,
                  //   child: SizedBox(height: 92, width: 92),
                  // ),
                ],
              ),
              SizedBox(
                height: 44,
                width: 44,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FightClubColors.blueButton,
                  ),
                  child: Center(
                    child: Text(
                      "vs",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Enemy",
                    style: TextStyle(
                      color: FightClubColors.darkGreyText,
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 92,
                    width: 92,
                    child: Image.asset(FightClubImages.enemyAvatar),
                  ),
                ],
              ),
              LivesWidget(
                overallLivesCount: maxLivesCount,
                currentLivesCount: enemysLivesCount,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ControlsWidget extends StatelessWidget {
  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget({
    Key? key,
    required this.defendingBodyPart,
    required this.selectDefendingBodyPart,
    required this.attackingBodyPart,
    required this.selectAttackingBodyPart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text(
                "Defend".toUpperCase(),
                style: TextStyle(
                  color: FightClubColors.darkGreyText,
                ),
              ),
              const SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Text(
                "Attack".toUpperCase(),
                style: TextStyle(
                  color: FightClubColors.darkGreyText,
                ),
              ),
              const SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

// количество жизней
class LivesWidget extends StatelessWidget {
  // для жизней
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })  : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(overallLivesCount, (index) {
        if (index < currentLivesCount) {
          return [
            Image.asset(FightClubIcons.heartFull, height: 18, width: 18),
            if (index < overallLivesCount - 1) SizedBox(height: 4),
          ];
        } else {
          return [
            Image.asset(FightClubIcons.heartEmpty, height: 18, width: 18),
            if (index < overallLivesCount) SizedBox(height: 4),
          ];
        }
      }).expand((element) => element).toList(),
    );
  }
}

// используем Rich Enum
// для каждого значения можно хранить доп инфу
class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  // рандом метод для выбора компьютером что атаковать и защищать
  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

// общий класс кнопок defend and attack
class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    Key? key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        // width: 158,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? FightClubColors.blueButton : Colors.transparent,
            border: !selected
                ? Border.all(color: FightClubColors.darkGreyText, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              bodyPart.name.toUpperCase(),
              style: TextStyle(
                color: selected
                    ? FightClubColors.whiteText
                    : FightClubColors.darkGreyText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
