import 'dart:io';
import 'dart:math';

class Game {
  Character character;
  List<Monster> monsters;
  int defeatedMonsters = 0;

  Game(this.character, this.monsters);

  void startGame() {
    print("게임을 시작합니다!");
    while (character.health > 0 && defeatedMonsters < monsters.length) {
      var monster = getRandomMonster();
      battle(monster);
      if (character.health <= 0) {
        print("게임에서 패배하였습니다.");
        break;
      }
      defeatedMonsters++;
      if (defeatedMonsters == monsters.length) {
        print("축하합니다! 모든 몬스터를 물리쳤습니다. 게임에서 승리하였습니다.");
        break;
      }
      stdout.write("다음 몬스터와 대결하시겠습니까? (y/n): ");
      String? choice = stdin.readLineSync();
      if (choice?.toLowerCase() != 'y') {
        print("게임이 종료되었습니다.");
        break;
      }
    }
    saveGameResult();
  }

  void battle(Monster monster) {
    print("\n${monster.name}와의 전투가 시작됩니다!");
    while (character.health > 0 && monster.health > 0) {
      character.showStatus();
      monster.showStatus();

      stdout.write("행동을 선택하세요: 공격하기(1), 방어하기(2): ");
      String? action = stdin.readLineSync();

      if (action == '1') {
        character.attackMonster(monster);
      } else if (action == '2') {
        character.defend();
      } else {
        print("잘못된 입력입니다. 다시 선택하세요.");
        continue;
      }

      if (monster.health > 0) {
        monster.attackCharacter(character);
      }
    }
    if (monster.health <= 0) {
      print("${monster.name}를 물리쳤습니다!");
      monsters.remove(monster);
    }
  }

  Monster getRandomMonster() {
    return monsters[Random().nextInt(monsters.length)];
  }

  void saveGameResult() {
    stdout.write("결과를 저장하시겠습니까? (y/n): ");
    String? choice = stdin.readLineSync();
    if (choice?.toLowerCase() == 'y') {
      final file = File('result.txt');
      String result = character.health > 0 ? "승리" : "패배";
      file.writeAsStringSync("캐릭터 이름: ${character.name}, 남은 체력: ${character.health}, 게임 결과: $result\n");
      print("게임 결과가 저장되었습니다.");
    }
  }
}

class Character {
  String name;
  int health;
  int attack;
  int defense;

  Character(this.name, this.health, this.attack, this.defense);

  void attackMonster(Monster monster) {
    int damage = max(attack - monster.defense, 0);
    monster.health -= damage;
    print("$name이(가) ${monster.name}에게 $damage의 피해를 입혔습니다.");
  }

  void defend() {
    health += 5;
    print("$name이(가) 방어하여 체력을 5 회복했습니다.");
  }

  void showStatus() {
    print("$name - 체력: $health, 공격력: $attack, 방어력: $defense");
  }
}

class Monster {
  String name;
  int health;
  int attack;
  int defense = 0;

  Monster(this.name, this.health, int maxAttack, int characterDefense)
      : attack = max(Random().nextInt(maxAttack), characterDefense);

  void attackCharacter(Character character) {
    int damage = max(attack - character.defense, 0);
    character.health -= damage;
    print("$name이(가) ${character.name}에게 $damage의 피해를 입혔습니다.");
  }

  void showStatus() {
    print("$name - 체력: $health, 공격력: $attack");
  }
}

Character loadCharacterStats() {
  try {
    final file = File('characters.txt');
    final contents = file.readAsStringSync();
    final stats = contents.split(',');
    if (stats.length != 3) throw FormatException('Invalid character data');

    int health = int.parse(stats[0]);
    int attack = int.parse(stats[1]);
    int defense = int.parse(stats[2]);

    stdout.write("캐릭터의 이름을 입력하세요: ");
    String? name = stdin.readLineSync();
    if (name == null || !RegExp(r'^[a-zA-Z가-힣]+\$').hasMatch(name)) {
      throw FormatException('Invalid character name');
    }

    return Character(name, health, attack, defense);
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
}

List<Monster> loadMonsterStats() {
  List<Monster> monsters = [];
  try {
    final file = File('monsters.txt');
    final contents = file.readAsLinesSync();
    for (var line in contents) {
      final stats = line.split(',');
      if (stats.length != 3) throw FormatException('Invalid monster data');

      String name = stats[0];
      int health = int.parse(stats[1]);
      int maxAttack = int.parse(stats[2]);

      monsters.add(Monster(name, health, maxAttack, 0));
    }
  } catch (e) {
    print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
  return monsters;
}

void main() {
  Character character = loadCharacterStats();
  List<Monster> monsters = loadMonsterStats();
  Game game = Game(character, monsters);
  game.startGame();
}
