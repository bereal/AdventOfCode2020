import 'dart:io';

var lineFormat = new RegExp(r"^([^(]+)\s+\(contains ([^)]+)\)$");
var spaces = new RegExp(r"\s+");
var commas = new RegExp(r",\s*");

class Rule {
  List<String> allergens;
  List<String> ingredients;

  Rule.parse(String line) {
    var m = lineFormat.firstMatch(line);
    this.ingredients = m.group(1).split(spaces);
    this.allergens = m.group(2).split(commas);
  }
}

Iterable<Rule> readRules() sync* {
  for (;;) {
    var line = stdin.readLineSync();
    if (line == null) {
      break;
    }
    yield Rule.parse(line);
  }
}

class Puzzle {
  Map<String, Set<String>> allergenToIngredients = Map();
  Map<String, int> ingredientCount = Map();
  Map<String, String> solution = Map(); // ingredient to allergen

  void add(Rule rule) {
    for (var allergen in rule.allergens) {
      var s = Set<String>.from(rule.ingredients);
      allergenToIngredients.update(allergen, (v) => v.intersection(s),
          ifAbsent: () => s);
    }
    for (var ingredient in rule.ingredients) {
      ingredientCount.update(ingredient, (v) => v + 1, ifAbsent: () => 1);
    }
  }

  void found(String allergen, String ingredient) {
    solution[ingredient] = allergen;
    allergenToIngredients.forEach((key, value) {
      if (value.length != 1 && key != ingredient) {
        value.remove(ingredient);
        if (value.length == 1) {
          found(key, value.first);
        }
      }
    });
  }

  void solve() {
    for (var a in allergenToIngredients.entries) {
      if (a.value.length == 1) {
        found(a.key, a.value.first);
      }
    }
  }

  int get safeSum => ingredientCount
      .map((k, v) => MapEntry(k, solution.containsKey(k) ? 0 : v))
      .values
      .reduce((a, b) => a + b);

  String get canonical {
    var ingredients = solution.keys.toList();
    ingredients.sort((a, b) => solution[a].compareTo(solution[b]));
    return ingredients.join(',');
  }
}

void main() {
  var puzzle = Puzzle();
  readRules().forEach(puzzle.add);
  puzzle.solve();
  print(puzzle.safeSum);
  print(puzzle.canonical);
}
