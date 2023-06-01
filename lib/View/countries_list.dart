import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CountriesListScreen extends StatefulWidget {
  CountriesListScreen({Key });

  @override
  _CountriesListScreenState createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  TextEditingController searchController = TextEditingController();
  StatesServices statesServices = StatesServices();
  List<dynamic> countryData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<dynamic> data = await statesServices.countriesListApi();
    setState(() {
      countryData = data;
    });
  }

  List<dynamic> getFilteredCountries() {
    String searchText = searchController.text.toLowerCase();
    if (searchText.isEmpty) {
      return countryData;
    } else {
      return countryData.where((country) {
        String name = country['country'].toString().toLowerCase();
        return name.contains(searchText);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search By Country',
                  prefixIcon: Icon(Icons.search_sharp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: countryData.isEmpty
                  ? Center(
                      child: SpinKitWave(
                        color: Colors.red,
                      ),
                    )
                  : ListView.builder(
                      itemCount: getFilteredCountries().length,
                      itemBuilder: (context, index) {
                        String name = getFilteredCountries()[index]['country'];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => CountryView(
                                    country: getFilteredCountries()[index]
                                            ['country']
                                        .toString(),
                                    flag: getFilteredCountries()[index]
                                        ['countryInfo']['flag']
                                        .toString(),
                                    cases: getFilteredCountries()[index]
                                            ['cases']
                                        .toString(),
                                    recovered: getFilteredCountries()[index]
                                            ['recovered']
                                        .toString(),
                                    deaths: getFilteredCountries()[index]
                                            ['deaths']
                                        .toString(),
                                    active: getFilteredCountries()[index]
                                            ['active']
                                        .toString(),
                                    critical: getFilteredCountries()[index]
                                            ['critical']
                                        .toString(),
                                    tests: getFilteredCountries()[index]
                                            ['tests']
                                        .toString(),
                                    todayCases: getFilteredCountries()[index]
                                            ['todayCases']
                                        .toString(),
                                    todayRecovered: getFilteredCountries()[index]
                                            ['todayRecovered']
                                        .toString(),
                                    todayDeaths: getFilteredCountries()[index]
                                            ['todayDeaths']
                                        .toString(),
                                  ),
                                ),
                              );
                            },
                            leading: Image.network(
                              getFilteredCountries()[index]['countryInfo']
                                  ['flag'],
                              width: 70,
                            ),
                            title: Text(getFilteredCountries()[index]
                                ['country']),
                            subtitle: Text('Total Cases - ' +
                                getFilteredCountries()[index]['cases']
                                    .toString()),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
