import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pokemon_app/model/pokehub.dart';
import 'package:pokemon_app/pages/details.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  var response;
  PokeHub pokemon;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    pokemon = PokeHub.fromJson(jsonData);
//    print(pokemon.pokemon[0].name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Pokemon"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            pokemon = null;
            getData();
          });
        },
        child: Icon(
          Icons.refresh,
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        child: pokemon != null
            ? ListView.builder(
                itemCount: pokemon.pokemon.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Hero(
                      tag: "${pokemon.pokemon[index].id}",
                      child: Image.network("${pokemon.pokemon[index].img}"),
                    ),
                    title: Text(
                      "${pokemon.pokemon[index].name}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${pokemon.pokemon[index].weight}"),
                    trailing: Text("${pokemon.pokemon[index].type[0]}"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Details(
                                    pokemon: pokemon,
                                    index: index,
                                  )));
                    },
                  );
                })
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
