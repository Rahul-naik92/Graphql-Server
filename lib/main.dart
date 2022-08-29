import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'graphql_demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink('https://countries.trevorblades.com/');

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(cache: GraphQLCache(), link: httpLink),
    );
    return GraphQLProvider(
      client: client,
      child: const MyDemoGraph(),
    );
  }
}

class MyDemoGraph extends StatefulWidget {
  const MyDemoGraph({Key? key}) : super(key: key);

  @override
  State<MyDemoGraph> createState() => _MyDemoGraphState();
}

class _MyDemoGraphState extends State<MyDemoGraph> {
  String readRepositories = """
 query Getcontinents{
      continents{
      name     
    }
  }
""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GraphlQL Client'),
      ),
      body: Query(
          options: QueryOptions(document: gql(readRepositories)),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.data == null) {
              return Text("No Data Found");
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(result.data!['continents'][index]['name']),
                );
                //return Text(result.data!['continents'][index]['name']);
              },
              itemCount: result.data!['continents']?.length,
            );
          }),
    );
  }
}
