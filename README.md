# myshop
Generate quotations.

# Invoicing
## Invoices page
- list of invoices
- create invoice modal
- invoice modal
- - add invoice item
- - update invoice item
- - delete invoice item

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