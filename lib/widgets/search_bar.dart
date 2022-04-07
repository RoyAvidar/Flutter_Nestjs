import 'package:flutter/material.dart';
import 'package:flutter_main/models/user.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_main/widgets/admin/admin_user_item.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  List<User> users = [];
  var isLoading = true;

  Future<List<User>> getUsers() async {
    final usersData =
        await Provider.of<UserProvider>(context, listen: false).getUsers();
    setState(() {
      users = usersData;
      isLoading = false;
    });
    return users;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(users),
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate(List<User> users) {
    this.users = users;
  }
  List<User> users = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<User> matchQuery = [];
    for (var user in users) {
      if (user.userName!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(user);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      // itemBuilder: (context, i) {
      //   var result = matchQuery[i];
      //   // print(result);
      //   return ListTile(
      //     title: Text(result.userName!),
      //   );
      // },
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: matchQuery[i],
        child: AdminUserItem(),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<User> matchQuery = [];
    for (var user in users) {
      if (user.userName!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(user);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, i) {
        var result = matchQuery[i];
        // print(result);
        return ListTile(
          title: Text(result.userName!),
        );
      },
    );
  }
}
