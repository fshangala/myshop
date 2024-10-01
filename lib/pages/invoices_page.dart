import 'package:flutter/material.dart';
import 'package:myshop/forms/invoice_form.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<StatefulWidget> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  void addInvoiceSheet() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return const InvoiceForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => addInvoiceSheet(),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
