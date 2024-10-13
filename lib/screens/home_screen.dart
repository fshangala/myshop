import 'package:flutter/material.dart';
import 'package:myshop/pages/home_page.dart';
import 'package:myshop/pages/invoices_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

enum Pages {
  home,
  invoices,
}

class _HomeScreenState extends State<HomeScreen> {
  var page = Pages.home;

  Widget renderPage(Pages page) {
    switch (page) {
      case Pages.home:
        return const HomePage();

      case Pages.invoices:
        return const InvoicesPage();

      default:
        return const Column();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          );
        }),
        title: const Text("MyShop"),
      ),
      drawer: Builder(builder: (context) {
        return Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  "MyShop",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                trailing:
                    page == Pages.home ? const Icon(Icons.arrow_back) : null,
                onTap: () {
                  setState(() {
                    page = Pages.home;
                    Scaffold.of(context).closeDrawer();
                  });
                },
              ),
              ListTile(
                title: const Text("Invoices"),
                trailing: page == Pages.invoices
                    ? const Icon(Icons.arrow_back)
                    : null,
                onTap: () {
                  setState(() {
                    page = Pages.invoices;
                    Scaffold.of(context).closeDrawer();
                  });
                },
              )
            ],
          ),
        );
      }),
      body: renderPage(page),
    );
  }
}
