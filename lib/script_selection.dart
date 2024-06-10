import 'package:bookflix/componentes.dart';
import 'package:bookflix/funcoes.dart';
import 'package:bookflix/models/livro.dart';
import 'package:flutter/material.dart';

//constroi a tela de carregamento
LoadingOverlay carregamento = LoadingOverlay();

void main() {
  runApp(const ScriptSelectionController());
}

class ScriptSelectionController extends StatelessWidget {
  const ScriptSelectionController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScriptTab(),
    );
  }
}

class ScriptTab extends StatefulWidget {
  const ScriptTab({super.key});

  @override
  State<ScriptTab> createState() => _ScriptTabState();
}

class _ScriptTabState extends State<ScriptTab> {
  List<String> generos = ['horror', 'romance', 'adventure']; // pegar generos favoritos do usuario
  List<Widget> tabs = [
    Text("Roteiro 1", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'Inter')),
    Text("Roteiro 2", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'Inter')),
    Text("Roteiro 3", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'Inter'))
  ];
  late TabController controller;
  late Future<List<Map<String, dynamic>>> scriptList;
  int activeTabIndex = 0;

  @override
  void initState() {
    print('-----------INIT STATE------------');
    scriptList = montaRoteiros(context);
  }

  // Abas dos Roteiros
  List<Container> getContainerTabs(){
    List<Container> list = [];
    for (var i = 0; i < tabs.length; i++) {
      list.add(Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), border: Border.all(width: 2.0,
            color: activeTabIndex == i
                ? const Color(0xFFAB47BC)
                : Colors.blue),
        ),
        child: tabs[i],
      ));
    }
    return list;
  }

  // Conteudo das abas
  Widget getTabChild(index) {
    return Container(
        margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
        child: Column(
          children: getScriptRows(index),
        ));
  }

  // Linhas com os livros de cada genero
  List<SizedBox> getScriptRows(index){
    List<SizedBox> list = [];

    for (var i = 0; i < generos.length; i++) {
      list.add(
        SizedBox(
          width: double.infinity,
          child: Container(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: scriptList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              generos[i],
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.grey, fontFamily: 'Inter'),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: getBooksContainers(snapshot.data![index][generos[i]]),
                          ),
                        ),
                      ],
                    );
                } else {
                  return const Text("Carregando");
                }
              },
            ),
          ),
        ),
      );
    }

    return list;
  }

  // Linha com os 3 livros do mesmo genero
  List<Container> getBooksContainers(List<Livro> books){
    List<Container> list = [];

    for(Livro book in books){
      list.add(
        Container(
          clipBehavior: Clip.none,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 10), // changes position of shadow
              ),
            ],
          ),
          child: Image(
              image: NetworkImage('https://covers.openlibrary.org/b/id/${book.imageId}-M.jpg'),
              height: 150,
              fit: BoxFit.contain
          ),
        ),
      );
    }
    return list;
  }

  // Build ----------------------------------------
  @override
  Widget build(BuildContext context) {
    final double largura = MediaQuery.of(context).size.width * 0.9;

    return DefaultTabController(
      animationDuration: Duration.zero,
      length: tabs.length,
      initialIndex: 0,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          setState(() {
            activeTabIndex = tabController.index;
          });
        });
        return Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              padding: const EdgeInsets.all(10),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 5),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(),
              tabs: getContainerTabs(),
            ),
          ),
          body: TabBarView(
          children: tabs.map((Widget tab) {
              return Center(
                child: Column(
                  children: [
                    getTabChild(tabController.index),
                    BotaoGradiente(
                      texto: "Selecionar Roteiro",
                      onPressed: () {
                        scriptList = montaRoteiros(context);
                        // Seleciona Roteiro
                        // tabController.index
                      },
                      largura: largura * 0.5,
                      altura: largura * 0.09,
                    ),
                  ]
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}