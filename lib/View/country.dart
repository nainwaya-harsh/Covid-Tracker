import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pie_chart/pie_chart.dart';

class CountryView extends StatelessWidget {
  final String flag;
  final String country;
  final String cases;
  final String recovered;
  final String deaths;
  final String active;
  final String critical;
  final String tests;
  final String todayCases;
  final String todayRecovered;
  final String todayDeaths;
  CountryView(
      {super.key,
      required this.flag,
      required this.country,
      required this.cases,
      required this.recovered,
      required this.deaths,
      required this.active,
      required this.critical,
      required this.tests,
      required this.todayCases,
      required this.todayRecovered,
      required this.todayDeaths});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
          child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Image.network(
                flag,
              ),
              Text(country),
              SizedBox(
                height: 30,
              ),
              Text(
                'Covid Data of ' + country,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PieChart(dataMap: {
                        'Total Cases': double.parse(cases),
                        'Total Recovered': double.parse(recovered),
                        'Total Deaths': double.parse(deaths)
                      }),
                    ),
                    ReusableRow(title: 'Total Cases', value: cases),
                    ReusableRow(title: 'Total Recovered', value: recovered),
                    ReusableRow(title: 'Total Deaths', value: deaths),
                    ReusableRow(title: 'Active Cases', value: active),
                    ReusableRow(title: 'Critical Cases', value: critical),
                    ReusableRow(title: 'Total Tests', value: tests),
                    ReusableRow(title: 'Today Cases', value: todayCases),
                    ReusableRow(
                        title: 'Today Recovered', value: todayRecovered),
                    ReusableRow(title: 'Total Deaths', value: todayDeaths),
                  ],
                ),
              ))
            ],
          ),
        ),
      )),
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
      child: Container(
        color: Colors.red,
        height: 40,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(value)
              ],
            )
          ],
        ),
      ),
    );
  }
}
