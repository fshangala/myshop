import 'package:flutter/material.dart';
import 'package:myshop/dialogs/invoice_dialog.dart';
import 'package:myshop/forms/invoice_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<StatefulWidget> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  var invoices = <String>[];

  @override
  initState() {
    super.initState();
    getInvoices();
  }

  void getInvoices() {
    SharedPreferences.getInstance().then((instance) {
      var myinvoices = instance.getStringList("invoices") ?? [];
      setState(() {
        invoices = myinvoices;
      });
    });
  }

  void addInvoiceSheet() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: InvoiceForm(
            postSave: (response) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(response.message),
              ));
              if (response.success) {
                Navigator.pop(context);
                getInvoices();
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              label: const Text("Add Invoice"),
              icon: const Icon(Icons.add),
              onPressed: () => addInvoiceSheet(),
            ),
          ],
        ),
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            Column(
              children: invoices.map((elem) {
                return ListTile(
                  title: Text(elem),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return InvoiceDialog(
                          invoiceNumber: elem,
                          postDelete: (response) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response.message)));
                            if (response.success) {
                              Navigator.pop(context);
                              getInvoices();
                            }
                          },
                        );
                      },
                    );
                  },
                );
              }).toList(),
            )
          ],
        ),
      ],
    );
  }
}
