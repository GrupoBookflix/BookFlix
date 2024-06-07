//import 'package:flutter/material.dart';

/*void main() {
  runApp(const ScriptSelectionController());
}*/

/*
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
  List<Widget> tabs = [
    Text("Roteiro 1", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'Inter')),
    Text("Roteiro 2", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'Inter')),
    Text("Roteiro 3", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'Inter'))
  ];
  List<Widget> rows = [
    Text(
      'Romance',
      textAlign: TextAlign.left,
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.grey, fontFamily: 'Inter'),
    ),
    Text(
      'Suspense',
      textAlign: TextAlign.left,
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.grey, fontFamily: 'Inter'),
    ),
    Text(
      'Comédia',
      textAlign: TextAlign.left,
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.grey, fontFamily: 'Inter'),
    )
  ];

  late TabController controller;
  int activeTabIndex = 0;

  List<SizedBox> getScriptRows(){
    List<SizedBox> list = [];
    for (var i = 0; i < rows.length; i++) {
      list.add(
        SizedBox(
          width: double.infinity,
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: rows[i],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
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
                        child: const Image(
                            image: NetworkImage('https://covers.openlibrary.org/b/id/5546156-M.jpg'),
                            height: 150,
                            fit: BoxFit.contain
                        ),
                      ),
                      Container(
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
                        child: const Image(
                            image: NetworkImage('https://covers.openlibrary.org/b/id/1-M.jpg'),
                            height: 150,
                            fit: BoxFit.contain
                        ),
                      ),
                      Container(
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
                        child: const Image(
                            image: NetworkImage('http://covers.openlibrary.org/b/isbn/1931498717-M.jpg'),
                            height: 150,
                            fit: BoxFit.contain
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return list;
  }

  Widget getTabChild(index){
    // Usar o index depois
    return Container(
        margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
        child: Column(
          children: getScriptRows(),
        ));
  }

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: tabs.length,
      initialIndex: 0,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
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
                child: getTabChild(tabController.index),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
*/