# myshop
Make invoices, generate sales and create a closing book among other things.

# Invoicing
## Invoices page
- a list of invoices
- a create invoice modal or some kind of popup

# Data Types
## Invoices
```
Lis<String> invoices
```
## Invoice
```
String invoiceNumber.customerName
String invoiceNumber.date
String invoiceNumber.paymentMethod
```
## InvoiceItems
```
List<String> invoiceNumber.invoiceItems
```
## InvoiceItem
```
String invoiceNumber.invoiceItemHash.quantity
String invoiceNumber.invoiceItemHash.description
String invoiceNumber.invoiceItemHash.unitPrice
```