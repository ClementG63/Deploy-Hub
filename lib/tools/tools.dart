import 'dart:math';

import 'package:front/model/gitlab/gitlab_file.dart';
import 'package:front/model/raw_performance_data.dart';

List<GitlabFile> buildTree(List<GitlabFile> gitlabFilesList) {
  List<GitlabFile> resultList = [];

  for (final element in gitlabFilesList) {
    if (!element.path.contains("/")) {
      if (resultList.where((rlE) => rlE.name == element.name).isEmpty) {
        resultList.add(element);
      }
    } else {
      final splitList = element.path.split("/");
      splitList.removeLast();
      final parentFolderName = splitList.last;

      deepInsert(resultList, parentFolderName, element);
    }
  }
  return resultList;
}

bool deepInsert(List<GitlabFile> initialList, String objective, GitlabFile toInsert){
  for(final file in initialList){
    if(file.name == objective){
      file.addChild(toInsert);
      return true;
    }
    if(file.children != null){
      if(deepInsert(file.children!, objective, toInsert)) return true;
    }
  }
  return false;
}

Stream<RamPerformanceData> generateRamPerformanceDataStream({int initialDataCount = 60}) async* {
  final random = Random();
  int currentRamUsage = 50;

  // Générer les données initiales
  for (int i = 0; i < initialDataCount; i++) {
    int change = random.nextInt(21) - 10;
    currentRamUsage += change;
    currentRamUsage = max(0, min(100, currentRamUsage));
    yield RamPerformanceData(DateTime.now().subtract(Duration(seconds: initialDataCount - i)), currentRamUsage);
  }
  // Générer des données de performance de la RAM aléatoires et lissées toutes les secondes
  while (true) {
    // Générer un pourcentage aléatoire compris entre -10% et 10%
    int change = random.nextInt(21) - 10;

    // Modifier l'utilisation de la RAM actuelle en ajoutant le pourcentage aléatoire
    currentRamUsage += change;

    // S'assurer que l'utilisation de la RAM reste dans la plage de 0 à 100%
    currentRamUsage = max(0, min(100, currentRamUsage));

    final timestamp = DateTime.now();
    yield RamPerformanceData(timestamp, currentRamUsage);
    await Future.delayed(const Duration(seconds: 1));
  }
}