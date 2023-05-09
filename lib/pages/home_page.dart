import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/controllers/project_controller.dart';
import 'package:front/model/project_dto.dart';
import 'package:front/tools/tools.dart';
import 'package:front/widgets/custom_app_bar.dart';
import 'package:front/widgets/delete_btn.dart';
import 'package:front/widgets/ram_usage_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ProjectController _projectController;

  @override
  Widget build(BuildContext context) {
    _projectController = Provider.of<ProjectController>(context);

    return Scaffold(
      backgroundColor: mainDarkColor,
      appBar: const CustomAppBar(reverse: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: _projectController.projectList.isNotEmpty ? _buildListBody() : _buildEmptyBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Oups il semblerait que vous n'ayez aucun project déployé...",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildListBody() {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      itemCount: _projectController.projectList.length,
      itemBuilder: (context, index) {
        final currentProject = _projectController.projectList.elementAt(index);

        return Padding(
          key: Key("$index"),
          padding: const EdgeInsets.only(bottom: 20),
          child: ReorderableDragStartListener(
            index: index,
            child: currentProject.deploymentStep == maxStep
                ? _buildLoadedTile(currentProject)
                : _buildLoadingTile(currentProject),
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) newIndex -= 1;
          final projectRemoved = _projectController.projectList.removeAt(oldIndex);
          _projectController.projectList.insert(newIndex, projectRemoved);
        });
      },
    );
  }

  Widget _buildLoadingTile(ProjectDTO currentProject) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircularProgressIndicator(color: mainDarkColor),
          const SizedBox(width: 15),
          Text("Déploiement en cours...(Etape ${currentProject.deploymentStep}/$maxStep)"),
        ],
      ),
    );
  }

  Container _buildLoadedTile(ProjectDTO currentProject) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProjectTitle(currentProject),
                  const SizedBox(height: 20),
                  _buildProjectDetails(currentProject)
                ],
              ),
              SizedBox(
                height: 100,
                width: 200,
                child: AnimatedRamUsageChart(ramUsageStream: generateRamPerformanceDataStream()),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "Release: ${currentProject.releaseName}",
                    style: const TextStyle(color: Colors.black38),
                    overflow: TextOverflow.ellipsis,
                  ),
                  AutoSizeText(
                    "Git: ${currentProject.repoUrl}",
                    style: const TextStyle(color: Colors.black38),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                children: [
                  _buildRestartBtn(currentProject),
                  _buildStopBtn(currentProject),
                  DeleteBtn(onTap: () => _projectController.removeProject(currentProject)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDetails(ProjectDTO currentProject) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(currentProject.id ?? "tempId"),
        AutoSizeText("Technologie du projet: ${currentProject.techno}"),
        AutoSizeText(
            "Créé le: ${currentProject.creationDate.day}/${currentProject.creationDate.month}/${currentProject.creationDate.year} à ${currentProject.creationDate.hour}:${currentProject.creationDate.minute}"),
        currentProject.lastUpdate != null
            ? AutoSizeText("Dernière mise à jour: ${currentProject.lastUpdate!.toLocal().toString()}")
            : const SizedBox.shrink(),
      ],
    );
  }

  Row _buildProjectTitle(ProjectDTO currentProject) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AutoSizeText(
          currentProject.name!,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildRestartBtn(ProjectDTO currentProject) {
    return TextButton(
      onPressed: () {},
      child: const AutoSizeText(
        "🧯Redémarrer le projet",
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  Widget _buildStopBtn(ProjectDTO currentProject) {
    return TextButton(
      onPressed: () {},
      child: const AutoSizeText(
        "🛑Arrêter le projet",
        style: TextStyle(color: Colors.black54),
      ),
    );
  }
}
