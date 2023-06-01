import 'package:covid_tracker/Model/world_states_model.dart';
import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/countries_list.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStats extends StatefulWidget {
  const WorldStats({Key? key}) : super(key: key);

  @override
  State<WorldStats> createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose the AnimationController before calling super.dispose()
    super.dispose();
  }

  final colorList = <Color>[
    Color.fromARGB(255, 90, 66, 244),
    const Color(0xff1aa260),
    const Color(0xffde5246)
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              FutureBuilder(
                  future: statesServices.fetchWorldStatesRecords(),
                  builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                          flex: 1,
                          child: SpinKitFadingCircle(
                            color: Colors.white,
                            size: 50,
                            controller: _controller,
                          ));
                    } else
                      return Column(
                        children: [
                          PieChart(
                            dataMap: {
                              "Total": double.parse(
                                  snapshot.data!.cases!.toString()),
                              "Recovered": double.parse(
                                  snapshot.data!.recovered!.toString()),
                              "Death": double.parse(
                                  snapshot.data!.deaths!.toString())
                            },
                            animationDuration: Duration(
                              milliseconds: 1200,
                            ),
                            chartRadius:
                                MediaQuery.of(context).size.width / 2.2,
                            chartType: ChartType.ring,
                            colorList: colorList,
                            chartValuesOptions: ChartValuesOptions(
                                showChartValuesInPercentage: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 50, horizontal: 20),
                            child: Card(
                              child: Column(
                                children: [
                                  ReusableRow(
                                      title: 'Today Cases',
                                      value:
                                          snapshot.data!.todayCases.toString()),
                                  ReusableRow(
                                      title: 'Today Recovered',
                                      value: snapshot.data!.todayRecovered
                                          .toString()),
                                  ReusableRow(
                                      title: 'Today Deaths',
                                      value: snapshot.data!.todayDeaths
                                          .toString()),
                                  ReusableRow(
                                      title: 'Active Cases',
                                      value: snapshot.data!.active.toString()),
                                  ReusableRow(
                                      title: 'Critical Cases',
                                      value:
                                          snapshot.data!.critical.toString()),
                                  ReusableRow(
                                      title: 'Tests',
                                      value: snapshot.data!.tests.toString()),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CountriesListScreen())),
                            child: Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                  color: Color(0xff1aa260),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'Track Countries',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                  }),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Made with ❤️ by Harsh Nainwaya'),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title;
  String value;
  ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value)],
          )
        ],
      ),
    );
  }
}
