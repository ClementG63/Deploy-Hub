import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:front/constants.dart';
import 'package:front/controllers/dockerfile_controller.dart';
import 'package:front/controllers/instance_controller.dart';
import 'package:front/controllers/project_controller.dart';
import 'package:front/controllers/user_controller.dart';
import 'package:front/exceptions/dockerfile_creation_exception.dart';
import 'package:front/exceptions/instance_creation_exception.dart';
import 'package:front/model/gitlab/gitlab_branche.dart';
import 'package:front/model/gitlab/gitlab_file.dart';
import 'package:front/model/gitlab/gitlab_file_type.dart';
import 'package:front/model/gitlab/gitlab_project.dart';
import 'package:front/model/project_dto.dart';
import 'package:front/route/app_router.gr.dart';
import 'package:front/widgets/custom_app_bar.dart';
import 'package:front/widgets/purple_button.dart';
import 'package:provider/provider.dart';

class ParamPage extends StatefulWidget {
  final String projectUrl;

  const ParamPage({Key? key, required this.projectUrl}) : super(key: key);

  @override
  State<ParamPage> createState() => _ParamPageState();
}

class _ParamPageState extends State<ParamPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedTechno = "Flutter";
  final _projectNameController = TextEditingController();
  final _domainNameController = TextEditingController();
  late GitlabBranch _selectedBranch = GitlabBranch(name: "main");

  late ProjectController _projectController;
  late DockerfileController _dockerfileController;
  late InstanceController _instanceController;
  late UserController _userController;

  @override
  void initState() {
    _projectController = Provider.of<ProjectController>(context, listen: false);
    _dockerfileController = Provider.of<DockerfileController>(context, listen: false);
    _instanceController = Provider.of<InstanceController>(context, listen: false);
    _userController = Provider.of<UserController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GitlabProject>(
      future: _projectController.getRepo(widget.projectUrl),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: const CustomAppBar(reverse: false),
          backgroundColor: mainDarkColor,
          body: Center(
            child: Container(
              height: 600,
              width: 500,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: snapshot.hasData
                  ? buildOKDataColumnContent(snapshot.data!)
                  : const Center(child: SpinKitFoldingCube(color: mainDarkColor)),
            ),
          ),
        );
      },
    );
  }

  Widget buildOKDataColumnContent(GitlabProject gitlabProject) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            gitlabProject.name!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          _buildProjectFiles(gitlabProject),
          _buildBranchesDropdown(gitlabProject.gitBranchesList),
          _buildTechnoDropdown(),
          _buildForm(),
          const SizedBox(height: 20),
          _buildConfirmBtn(),
        ],
      ),
    );
  }

  PurpleButton _buildConfirmBtn() {
    return PurpleButton(
      btnTitle: "Confirmer les paramètres",
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          ProjectDTO newProject = ProjectDTO(
            techno: _selectedTechno,
            repoUrl: widget.projectUrl,
            name: _projectNameController.text,
            branch: _selectedBranch.name,
          );

          _deploymentCallChain(newProject);
          _projectController.addProject(newProject);

          if (mounted) AutoRouter.of(context).push(const HomeRoute());
        }
      },
      enabled: _projectNameController.text.isNotEmpty,
    );
  }

  Future<void> _deploymentCallChain(ProjectDTO newProject) async {
    try {
      //TODO CHANGE TEMPLATE ID AND URL
      final dockerFile = await _dockerfileController.createDockerfile(
        "hello-world",
        newProject.repoUrl!,
        _userController.loggedUser!.accessToken,
      );

      _projectController.updateDeploymentStep(newProject);

      final instance = await _instanceController.createInstance(
        _projectNameController.text.toLowerCase(),
        dockerFile!,
        _userController.loggedUser!.username.toLowerCase(),
        _domainNameController.text,
        _userController.loggedUser!.accessToken,
      );

      _projectController.updateDeploymentStep(newProject);

      await _projectController.createProject(
        newProject..releaseName = instance!.releaseName!,
        _userController.loggedUser!.accessToken,
      );

      _projectController.updateDeploymentStep(newProject);
    } on InstanceCreationException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.cause)));
      _projectController.removeProject(newProject);
    } on DockerfileCreationException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.cause)));
      _projectController.removeProject(newProject);
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              const Text("Nom du projet :"),
              const SizedBox(width: 10),
              SizedBox(
                width: 250,
                child: TextFormField(
                  controller: _projectNameController,
                  maxLength: 20,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Un nom de projet doit être donné';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Nom de domaine :"),
              const SizedBox(width: 10),
              SizedBox(
                width: 250,
                child: TextFormField(
                  controller: _domainNameController,
                  maxLength: 20,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Un nom de domaine doit être donné';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechnoDropdown() {
    const technologies = [
      "Go",
      "NodeJS",
      "Laravel/Symphony",
      "Flutter",
      "Angular/AngularJS",
      "Java Spring",
      "VueJS",
      "React",
      "Django",
    ];

    return Row(
      children: [
        const Text("Language :"),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: _selectedTechno,
          items: technologies.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) {
            setState(() {});
            _selectedTechno = value!;
          },
        ),
      ],
    );
  }

  Widget _buildBranchesDropdown(List<GitlabBranch> gitBranchesList) {
    return Row(
      children: [
        const Text("Branche :"),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: _selectedBranch.name,
          items: gitBranchesList
              .map((e) => DropdownMenuItem<String>(
                    value: e.name!,
                    child: Text(e.name!),
                  ))
              .toList(),
          onChanged: (String? value) {
            setState(() => _selectedBranch = gitBranchesList.firstWhere((e) => e.name == value!));
          },
        ),
      ],
    );
  }

  Padding _buildProjectFiles(GitlabProject gitlabProject) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: double.infinity,
        height: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView.builder(
          itemCount: gitlabProject.gitlabFilesList.length,
          itemBuilder: (context, index) {
            return buildChildren(gitlabProject.gitlabFilesList.elementAt(index));
          },
        ),
      ),
    );
  }

  Widget buildChildren(GitlabFile currentFile) {
    final isFolder = currentFile.type == GitlabFileType.folder;
    return Column(
      children: [
        Row(
          children: [
            isFolder ? const Icon(Icons.folder) : const Icon(Icons.insert_drive_file_outlined),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                currentFile.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (currentFile.children != null)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              children: [
                ...List.generate(
                    currentFile.children!.length, (index) => buildChildren(currentFile.children!.elementAt(index)))
              ],
            ),
          )
      ],
    );
  }
}
