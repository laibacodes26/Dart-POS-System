
import 'dart:io';

String readText(String message) {
  stdout.write(message);
  String? value = stdin.readLineSync();

  if (value == null) {
    exit(0);
  }

  return value.trim();
}

String readRequiredText(String message) {
  while (true) {
    String value = readText(message);

    if (value.isNotEmpty) {
      return value;
    }

    print('Input cannot be empty.');
  }
}

int readInt(String message) {
  while (true) {
    stdout.write(message);
    String? line = stdin.readLineSync();

    if (line == null) {
      exit(0);
    }

    int? number = int.tryParse(line.trim());

    if (number != null) {
      return number;
    }

    print('Please enter a valid whole number.');
  }
}

double readDouble(String message) {
  while (true) {
    stdout.write(message);
    String? line = stdin.readLineSync();

    if (line == null) {
      exit(0);
    }

    double? number = double.tryParse(line.trim());

    if (number != null && number.isFinite) {
      return number;
    }

    print('Please enter a valid number.');
  }
}

DateTime readDate(String message) {
  while (true) {
    String value = readRequiredText(message);
    DateTime? date = DateTime.tryParse(value);

    if (date != null) {
      return date;
    }

    print('Invalid date. Use YYYY-MM-DD.');
  }
}

class Product {
  int _id;
  String _name;
  double _retailPrice;
  double _wholesalePrice;
  bool _available;

  Product(
    this._id,
    this._name,
    this._retailPrice,
    this._wholesalePrice,
    this._available,
  );

  int get id => _id;
  String get name => _name;
  double get retailPrice => _retailPrice;
  double get wholesalePrice => _wholesalePrice;
  bool get available => _available;

  set name(String value) {
    if (value.trim().isNotEmpty) {
      _name = value;
    }
  }

  set retailPrice(double value) {
    if (value >= 0 && value.isFinite) {
      _retailPrice = value;
    }
  }

  set wholesalePrice(double value) {
    if (value >= 0 && value.isFinite) {
      _wholesalePrice = value;
    }
  }

  set available(bool value) {
    _available = value;
  }

  void showProduct() {
    print('ID: $_id');
    print('Name: $_name');
    print('Retail Price: Rs. $_retailPrice');
    print('Wholesale Price: Rs. $_wholesalePrice');
    print('Available: ${_available ? "Yes" : "No"}');
  }
}

class Customer {
  int _id;
  String _name;
  String _type;

  Customer(this._id, this._name, this._type);

  int get id => _id;
  String get name => _name;
  String get type => _type;

  double get discount {
    if (_type.toLowerCase() == 'regular') {
      return 0.20;
    } else if (_type.toLowerCase() == 'premium') {
      return 0.50;
    }

    return 0;
  }

  set name(String value) {
    if (value.trim().isNotEmpty) {
      _name = value;
    }
  }

  set type(String value) {
    if (value.toLowerCase() == 'regular' ||
        value.toLowerCase() == 'premium') {
      _type = value;
    }
  }

  void showCustomer() {
    print('ID: $_id');
    print('Name: $_name');
    print('Type: $_type');
    print('Discount: ${discount * 100}%');
  }
}

class Stock {
  int productId;
  int quantity;
  String vendor;

  Stock(this.productId, this.quantity, this.vendor);

  void showStock() {
    print('Product ID: $productId');
    print('Quantity: $quantity');
    print('Vendor: $vendor');
  }
}

class SaleItem {
  Product product;
  int quantity;
  double price;
  double cost;

  SaleItem(this.product, this.quantity)
      : price = product.retailPrice,
        cost = product.wholesalePrice;

  double get totalPrice => price * quantity;
  double get totalCost => cost * quantity;
}

class Payment {
  String paymentType;
  double receivedAmount;
  double change;

  Payment(this.paymentType, this.receivedAmount, double totalBill)
      : change = receivedAmount - totalBill;

  void showPayment() {
    print('Payment Type: $paymentType');
    print('Received Amount: Rs. $receivedAmount');
    print('Change: Rs. $change');
  }
}

class Sale {
  int id;
  Customer customer;
  DateTime date;
  List<SaleItem> items;
  Payment payment;
  double totalBill;
  double discountRate = 0;
  String customerType = '';

  Sale(
    this.id,
    this.customer,
    this.date,
    this.items,
    this.payment,
  ) : totalBill = 0 {
    calculateTotalBill();
  }

  double get subtotal {
    double total = 0;

    for (SaleItem item in items) {
      total += item.totalPrice;
    }

    return total;
  }

  double get totalCost {
    double total = 0;

    for (SaleItem item in items) {
      total += item.totalCost;
    }

    return total;
  }

  void calculateTotalBill() {
    discountRate = customer.discount;
    customerType = customer.type;

    totalBill = subtotal - (subtotal * discountRate);
  }

  double get profitOrLoss => totalBill - totalCost;

  void showSale() {
    print('\nSale ID: $id');
    print('Customer: ${customer.name}');
    print('Customer Type: $customerType');
    print('Date: ${date.toString().split(' ')[0]}');

    print('\nPurchased Products:');

    for (SaleItem item in items) {
      print(
        '${item.product.name} | Quantity: ${item.quantity} | '
        'Price: Rs. ${item.price} | Total: Rs. ${item.totalPrice}',
      );
    }

    print('\nSubtotal: Rs. $subtotal');
    print('Discount: ${discountRate * 100}%');
    print('Total Bill: Rs. $totalBill');

    payment.showPayment();

    print('Profit/Loss: Rs. $profitOrLoss');
  }
}

class Receipt {
  int id;
  Sale sale;
  String note;

  Receipt(this.id, this.sale, this.note);

  void showReceipt() {
    print('\n========== RECEIPT ==========');
    print('Receipt ID: $id');
    print('Sale ID: ${sale.id}');
    print('Customer: ${sale.customer.name}');
    print('Date: ${sale.date.toString().split(' ')[0]}');
    print('Total Bill: Rs. ${sale.totalBill}');
    print('Payment Type: ${sale.payment.paymentType}');
    print('Received: Rs. ${sale.payment.receivedAmount}');
    print('Change: Rs. ${sale.payment.change}');
    print('Note: $note');
    print('=============================');
  }
}

class POSSystem {
  List<Product> products = [];
  List<Customer> customers = [];
  List<Stock> stocks = [];
  List<Sale> sales = [];
  List<Receipt> receipts = [];

  int nextSaleId = 1;
  int nextReceiptId = 1;

  Product? findProduct(int id) {
    for (Product product in products) {
      if (product.id == id) {
        return product;
      }
    }

    return null;
  }

  Customer? findCustomer(String name) {
    for (Customer customer in customers) {
      if (customer.name.toLowerCase() == name.toLowerCase()) {
        return customer;
      }
    }

    return null;
  }

  Customer? findCustomerById(int id) {
    for (Customer customer in customers) {
      if (customer.id == id) {
        return customer;
      }
    }

    return null;
  }

  Stock? findStock(int productId) {
    for (Stock stock in stocks) {
      if (stock.productId == productId) {
        return stock;
      }
    }

    return null;
  }

  Sale? findSale(int id) {
    for (Sale sale in sales) {
      if (sale.id == id) {
        return sale;
      }
    }

    return null;
  }

  Receipt? findReceipt(int id) {
    for (Receipt receipt in receipts) {
      if (receipt.id == id) {
        return receipt;
      }
    }

    return null;
  }

  void addProduct() {
    int id = readInt('Enter product ID: ');

    if (id <= 0) {
      print('Product ID must be greater than zero.');
      return;
    }

    if (findProduct(id) != null) {
      print('Product ID already exists.');
      return;
    }

    String name = readRequiredText('Enter product name: ');
    double retail = readDouble('Enter retail price: ');
    double wholesale = readDouble('Enter wholesale price: ');

    if (retail < 0 || wholesale < 0) {
      print('Prices cannot be negative.');
      return;
    }

    String vendor = readRequiredText('Enter vendor name: ');

    Product product = Product(id, name, retail, wholesale, false);

    products.add(product);
    stocks.add(Stock(id, 0, vendor));

    print('Product added successfully.');
  }

  void viewProducts() {
    if (products.isEmpty) {
      print('No products available.');
      return;
    }

    for (Product product in products) {
      print('\n----------------');
      product.showProduct();
    }
  }

  void updateProduct() {
    int id = readInt('Enter product ID to update: ');
    Product? product = findProduct(id);

    if (product == null) {
      print('Product not found.');
      return;
    }

    String name = readRequiredText('Enter new product name: ');
    double retail = readDouble('Enter new retail price: ');
    double wholesale = readDouble('Enter new wholesale price: ');

    if (name.isEmpty || retail < 0 || wholesale < 0) {
      print('Invalid product information. Nothing was updated.');
      return;
    }

    product.name = name;
    product.retailPrice = retail;
    product.wholesalePrice = wholesale;

    print('Product updated successfully.');
  }

  void deleteProduct() {
    int id = readInt('Enter product ID to delete: ');
    Product? product = findProduct(id);

    if (product == null) {
      print('Product not found.');
      return;
    }

    for (Sale sale in sales) {
      for (SaleItem item in sale.items) {
        if (item.product.id == id) {
          print('This product is already used in a sale.');
          return;
        }
      }
    }

    products.remove(product);
    stocks.removeWhere((stock) => stock.productId == id);

    print('Product deleted successfully.');
  }

  void productMenu() {
    while (true) {
      print('\n===== PRODUCT MENU =====');
      print('1. Add Product');
      print('2. View Products');
      print('3. Update Product');
      print('4. Delete Product');
      print('0. Back');

      int choice = readInt('Enter choice: ');

      if (choice == 1) {
        addProduct();
      } else if (choice == 2) {
        viewProducts();
      } else if (choice == 3) {
        updateProduct();
      } else if (choice == 4) {
        deleteProduct();
      } else if (choice == 0) {
        return;
      } else {
        print('Invalid choice.');
      }
    }
  }

  void addCustomer() {
    int id = readInt('Enter customer ID: ');

    if (id <= 0 || findCustomerById(id) != null) {
      print('Invalid or already existing customer ID.');
      return;
    }

    String name = readRequiredText('Enter customer name: ');

    print('1. Regular Customer');
    print('2. Premium Customer');

    int choice = readInt('Select customer type: ');

    String type;

    if (choice == 1) {
      type = 'Regular';
    } else if (choice == 2) {
      type = 'Premium';
    } else {
      print('Invalid customer type.');
      return;
    }

    customers.add(Customer(id, name, type));

    print('Customer added successfully.');
  }

  void viewCustomers() {
    if (customers.isEmpty) {
      print('No customers available.');
      return;
    }

    for (Customer customer in customers) {
      print('\n----------------');
      customer.showCustomer();
    }
  }

  void updateCustomer() {
    int id = readInt('Enter customer ID to update: ');
    Customer? customer = findCustomerById(id);

    if (customer == null) {
      print('Customer not found.');
      return;
    }

    String name = readRequiredText('Enter new customer name: ');

    print('1. Regular');
    print('2. Premium');

    int choice = readInt('Select new customer type: ');

    String type;

    if (choice == 1) {
      type = 'Regular';
    } else if (choice == 2) {
      type = 'Premium';
    } else {
      print('Invalid customer type.');
      return;
    }

    Customer? existingCustomer = findCustomer(name);

    if (existingCustomer != null && existingCustomer.id != id) {
      print('Another customer already has this name.');
      return;
    }

    customer.name = name;
    customer.type = type;

    print('Customer updated successfully.');
  }

  void deleteCustomer() {
    int id = readInt('Enter customer ID to delete: ');
    Customer? customer = findCustomerById(id);

    if (customer == null) {
      print('Customer not found.');
      return;
    }

    for (Sale sale in sales) {
      if (sale.customer.id == id) {
        print('This customer is already linked to a sale.');
        return;
      }
    }

    customers.remove(customer);

    print('Customer deleted successfully.');
  }

  void customerMenu() {
    while (true) {
      print('\n===== CUSTOMER MENU =====');
      print('1. Add Customer');
      print('2. View Customers');
      print('3. Update Customer');
      print('4. Delete Customer');
      print('0. Back');

      int choice = readInt('Enter choice: ');

      if (choice == 1) {
        addCustomer();
      } else if (choice == 2) {
        viewCustomers();
      } else if (choice == 3) {
        updateCustomer();
      } else if (choice == 4) {
        deleteCustomer();
      } else if (choice == 0) {
        return;
      } else {
        print('Invalid choice.');
      }
    }
  }

  void addStock() {
    int id = readInt('Enter product ID: ');
    Product? product = findProduct(id);

    if (product == null) {
      print('Product not found.');
      return;
    }

    int quantity = readInt('Enter quantity to add: ');

    if (quantity <= 0) {
      print('Quantity must be greater than zero.');
      return;
    }

    String vendor = readRequiredText('Enter vendor name: ');
    Stock? stock = findStock(id);

    if (stock == null) {
      stocks.add(Stock(id, quantity, vendor));
    } else {
      stock.quantity += quantity;
      stock.vendor = vendor;
    }

    product.available = true;

    print('Stock added successfully.');
  }

  void viewStock() {
    if (stocks.isEmpty) {
      print('No inventory records available.');
      return;
    }

    for (Stock stock in stocks) {
      print('\n----------------');
      stock.showStock();
    }
  }

  void updateStock() {
    int id = readInt('Enter product ID: ');
    Stock? stock = findStock(id);

    if (stock == null) {
      print('Stock record not found.');
      return;
    }

    int quantity = readInt('Enter new quantity: ');

    if (quantity < 0) {
      print('Quantity cannot be negative.');
      return;
    }

    String vendor = readRequiredText('Enter vendor name: ');

    stock.quantity = quantity;
    stock.vendor = vendor;

    Product? product = findProduct(id);

    if (product != null) {
      product.available = quantity > 0;
    }

    print('Stock updated successfully.');
  }

  void deleteStock() {
    int id = readInt('Enter product ID: ');
    Stock? stock = findStock(id);

    if (stock == null) {
      print('Stock record not found.');
      return;
    }

    stock.quantity = 0;
    Product? product = findProduct(id);

    if (product != null) {
      product.available = false;
    }

    print('Stock quantity set to zero.');
  }

  void inventoryMenu() {
    while (true) {
      print('\n===== INVENTORY MENU =====');
      print('1. Add Stock');
      print('2. View Stock');
      print('3. Update Stock');
      print('4. Delete Stock');
      print('0. Back');

      int choice = readInt('Enter choice: ');

      if (choice == 1) {
        addStock();
      } else if (choice == 2) {
        viewStock();
      } else if (choice == 3) {
        updateStock();
      } else if (choice == 4) {
        deleteStock();
      } else if (choice == 0) {
        return;
      } else {
        print('Invalid choice.');
      }
    }
  }

  void createSale() {
    if (customers.isEmpty || products.isEmpty) {
      print('Add customers and products before creating a sale.');
      return;
    }

    int customerId = readInt('Enter customer ID: ');
    Customer? customer = findCustomerById(customerId);

    if (customer == null) {
      print('Customer not found.');
      return;
    }

    List<SaleItem> items = [];

    while (true) {
      viewProducts();

      int productId = readInt('Enter product ID (0 to finish): ');

      if (productId == 0) {
        break;
      }

      Product? product = findProduct(productId);
      Stock? stock = findStock(productId);

      if (product == null || stock == null || stock.quantity <= 0) {
        print('Product is not available in stock.');
        continue;
      }

      int quantity = readInt('Enter quantity: ');

      if (quantity <= 0 || quantity > stock.quantity) {
        print('Invalid quantity or insufficient stock.');
        continue;
      }

      SaleItem? existingItem;

      for (SaleItem item in items) {
        if (item.product.id == productId) {
          existingItem = item;
          break;
        }
      }

      int alreadySelected = existingItem?.quantity ?? 0;

      if (alreadySelected + quantity > stock.quantity) {
        print('Not enough stock for this quantity.');
        continue;
      }

      if (existingItem == null) {
        items.add(SaleItem(product, quantity));
      } else {
        existingItem.quantity += quantity;
      }

      print('Product added to sale.');
    }

    if (items.isEmpty) {
      print('Sale cancelled because no products were selected.');
      return;
    }

    double subtotal = 0;

    for (SaleItem item in items) {
      subtotal += item.totalPrice;
    }

    double total = subtotal - (subtotal * customer.discount);

    print('Subtotal: Rs. $subtotal');
    print('Customer Discount: ${customer.discount * 100}%');
    print('Total Bill: Rs. $total');

    print('1. Cash');
    print('2. Card');

    int paymentChoice = readInt('Select payment type: ');

    String paymentType;

    if (paymentChoice == 1) {
      paymentType = 'Cash';
    } else if (paymentChoice == 2) {
      paymentType = 'Card';
    } else {
      print('Invalid payment type.');
      return;
    }

    double received = readDouble('Enter received amount: ');

    if (received < total) {
      print('Received amount is less than the bill. Sale cancelled.');
      return;
    }

    Payment payment = Payment(paymentType, received, total);

    Sale sale = Sale(
      nextSaleId,
      customer,
      DateTime.now(),
      items,
      payment,
    );

    sales.add(sale);
    nextSaleId++;

    for (SaleItem item in items) {
      Stock? stock = findStock(item.product.id);

      if (stock != null) {
        stock.quantity -= item.quantity;
        item.product.available = stock.quantity > 0;
      }
    }

    print('Sale completed successfully.');
    sale.showSale();
  }

  void viewSales() {
    if (sales.isEmpty) {
      print('No sales available.');
      return;
    }

    for (Sale sale in sales) {
      sale.showSale();
    }
  }

  void updateSale() {
    int id = readInt('Enter sale ID to update: ');
    Sale? sale = findSale(id);

    if (sale == null) {
      print('Sale not found.');
      return;
    }

    DateTime date = readDate('Enter new sale date (YYYY-MM-DD): ');
    sale.date = date;

    print('Sale date updated successfully.');
  }

  void deleteSale() {
    int id = readInt('Enter sale ID to delete: ');
    Sale? sale = findSale(id);

    if (sale == null) {
      print('Sale not found.');
      return;
    }

    for (SaleItem item in sale.items) {
      Stock? stock = findStock(item.product.id);

      if (stock == null) {
        stocks.add(
          Stock(item.product.id, item.quantity, 'Unknown'),
        );
      } else {
        stock.quantity += item.quantity;
      }

      item.product.available = true;
    }

    receipts.removeWhere((receipt) => receipt.sale.id == id);
    sales.remove(sale);

    print('Sale deleted and stock restored successfully.');
  }

  void salesMenu() {
    while (true) {
      print('\n===== SALES MENU =====');
      print('1. Create Sale');
      print('2. View Sales');
      print('3. Update Sale Date');
      print('4. Delete Sale');
      print('0. Back');

      int choice = readInt('Enter choice: ');

      if (choice == 1) {
        createSale();
      } else if (choice == 2) {
        viewSales();
      } else if (choice == 3) {
        updateSale();
      } else if (choice == 4) {
        deleteSale();
      } else if (choice == 0) {
        return;
      } else {
        print('Invalid choice.');
      }
    }
  }

  void createReceipt() {
    int saleId = readInt('Enter sale ID: ');
    Sale? sale = findSale(saleId);

    if (sale == null) {
      print('Sale not found.');
      return;
    }

    for (Receipt receipt in receipts) {
      if (receipt.sale.id == saleId) {
        print('A receipt already exists for this sale.');
        return;
      }
    }

    Receipt receipt = Receipt(
      nextReceiptId,
      sale,
      'Thank you for shopping.',
    );

    receipts.add(receipt);
    nextReceiptId++;

    print('Receipt created successfully.');
    receipt.showReceipt();
  }

  void viewReceipts() {
    if (receipts.isEmpty) {
      print('No receipts available.');
      return;
    }

    for (Receipt receipt in receipts) {
      receipt.showReceipt();
    }
  }

  void updateReceipt() {
    int id = readInt('Enter receipt ID: ');
    Receipt? receipt = findReceipt(id);

    if (receipt == null) {
      print('Receipt not found.');
      return;
    }

    String note = readRequiredText('Enter new receipt note: ');
    receipt.note = note;

    print('Receipt updated successfully.');
  }

  void deleteReceipt() {
    int id = readInt('Enter receipt ID: ');
    Receipt? receipt = findReceipt(id);

    if (receipt == null) {
      print('Receipt not found.');
      return;
    }

    receipts.remove(receipt);

    print('Receipt deleted successfully.');
  }

  void receiptMenu() {
    while (true) {
      print('\n===== RECEIPT MENU =====');
      print('1. Create Receipt');
      print('2. View Receipts');
      print('3. Update Receipt');
      print('4. Delete Receipt');
      print('0. Back');

      int choice = readInt('Enter choice: ');

      if (choice == 1) {
        createReceipt();
      } else if (choice == 2) {
        viewReceipts();
      } else if (choice == 3) {
        updateReceipt();
      } else if (choice == 4) {
        deleteReceipt();
      } else if (choice == 0) {
        return;
      } else {
        print('Invalid choice.');
      }
    }
  }

  double totalSalesForMonth(int month, int year) {
    double total = 0;

    for (Sale sale in sales) {
      if (sale.date.month == month && sale.date.year == year) {
        total += sale.totalBill;
      }
    }

    return total;
  }

  double totalSalesForYear(int year) {
    double total = 0;

    for (Sale sale in sales) {
      if (sale.date.year == year) {
        total += sale.totalBill;
      }
    }

    return total;
  }

  void showMonthlySales() {
    int month = readInt('Enter month (1-12): ');
    int year = readInt('Enter year: ');

    if (month < 1 || month > 12) {
      print('Invalid month.');
      return;
    }

    print(
      'Total sales for $month/$year: '
      'Rs. ${totalSalesForMonth(month, year)}',
    );
  }

  void showYearlySales() {
    int year = readInt('Enter year: ');

    print(
      'Total sales for $year: Rs. ${totalSalesForYear(year)}',
    );
  }

  void highestSellingProduct() {
    if (sales.isEmpty) {
      print('No sales available.');
      return;
    }

    Map<int, int> quantities = {};

    for (Sale sale in sales) {
      for (SaleItem item in sale.items) {
        quantities[item.product.id] =
            (quantities[item.product.id] ?? 0) + item.quantity;
      }
    }

    int highestId = 0;
    int highestQuantity = 0;

    quantities.forEach((id, quantity) {
      if (quantity > highestQuantity) {
        highestQuantity = quantity;
        highestId = id;
      }
    });

    Product? product = findProduct(highestId);

    print('\nHighest Selling Product: ${product?.name ?? "Product ID $highestId"}');
    print('Quantity Sold: $highestQuantity');
  }

  void showInventoryStatus() {
    if (stocks.isEmpty) {
      print('No inventory records available.');
      return;
    }

    print('\n===== INVENTORY STATUS =====');

    for (Stock stock in stocks) {
      Product? product = findProduct(stock.productId);

      print('Product: ${product?.name ?? "Unknown"}');
      print('Product ID: ${stock.productId}');
      print('Quantity: ${stock.quantity}');
      print('Status: ${stock.quantity > 0 ? "In Stock" : "Out of Stock"}');
      print('Vendor: ${stock.vendor}');
      print('--------------------');
    }
  }

  void showProfitAndLoss() {
    double totalSales = 0;
    double totalCost = 0;

    for (Sale sale in sales) {
      totalSales += sale.totalBill;
      totalCost += sale.totalCost;
    }

    double result = totalSales - totalCost;

    print('\nTotal Sales: Rs. $totalSales');
    print('Total Cost: Rs. $totalCost');

    if (result > 0) {
      print('Total Profit: Rs. $result');
    } else if (result < 0) {
      print('Total Loss: Rs. ${result.abs()}');
    } else {
      print('No profit and no loss.');
    }
  }

  void reportMenu() {
    while (true) {
      print('\n===== REPORT MENU =====');
      print('1. Total Sales Per Month');
      print('2. Total Sales Per Year');
      print('3. Highest Selling Product');
      print('4. Inventory Status');
      print('5. Profit and Loss');
      print('0. Back');

      int choice = readInt('Enter choice: ');

      if (choice == 1) {
        showMonthlySales();
      } else if (choice == 2) {
        showYearlySales();
      } else if (choice == 3) {
        highestSellingProduct();
      } else if (choice == 4) {
        showInventoryStatus();
      } else if (choice == 5) {
        showProfitAndLoss();
      } else if (choice == 0) {
        return;
      } else {
        print('Invalid choice.');
      }
    }
  }

  void run() {
    while (true) {
      print('\n========== POINT OF SALE SYSTEM ==========');
      print('1. Product Management');
      print('2. Customer Management');
      print('3. Inventory Management');
      print('4. Sales Management');
      print('5. Receipt Management');
      print('6. Reports');
      print('0. Exit');

      int choice = readInt('Enter your choice: ');

      if (choice == 1) {
        productMenu();
      } else if (choice == 2) {
        customerMenu();
      } else if (choice == 3) {
        inventoryMenu();
      } else if (choice == 4) {
        salesMenu();
      } else if (choice == 5) {
        receiptMenu();
      } else if (choice == 6) {
        reportMenu();
      } else if (choice == 0) {
        print('Thank you for using POS System.');
        exit(0);
      } else {
        print('Invalid choice. Try again.');
      }
    }
  }
}

void main() {
  POSSystem pos = POSSystem();
  pos.run();
}
