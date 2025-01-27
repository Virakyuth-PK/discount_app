import 'package:flutter/material.dart';

void main() {
  runApp(DiscountApp());
}

class DiscountApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discount Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DiscountCalculator(),
    );
  }
}

class DiscountCalculator extends StatefulWidget {
  @override
  _DiscountCalculatorState createState() => _DiscountCalculatorState();
}

class _DiscountCalculatorState extends State<DiscountCalculator> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _customDiscountController = TextEditingController();
  final TextEditingController _discountedPriceController = TextEditingController();

  double? _calculatedPrice;
  bool _isReverseMode = false; // false: Calculate discounted price, true: Calculate original price
  List<String> _history = [];

  void _calculatePrice(double discount) {
    if (_isReverseMode) {
      // Calculate original price from discounted price
      double? discountedPrice = double.tryParse(_discountedPriceController.text);
      if (discountedPrice != null && discount > 0) {
        setState(() {
          _calculatedPrice = discountedPrice / (1 - discount / 100);
          _addToHistory(discountedPrice, discount, _calculatedPrice!);
        });
      }
    } else {
      // Calculate discounted price from original price
      double? origin = double.tryParse(_originController.text);
      if (origin != null) {
        setState(() {
          _calculatedPrice = origin * (1 - discount / 100);
          _addToHistory(origin, discount, _calculatedPrice!);
        });
      }
    }
  }

  void _calculateCustomPrice() {
    double? origin = double.tryParse(_originController.text);
    double? customDiscount = double.tryParse(_customDiscountController.text);

    if (_isReverseMode) {
      // Reverse mode for custom input
      double? discountedPrice = double.tryParse(_discountedPriceController.text);
      if (discountedPrice != null && customDiscount != null) {
        setState(() {
          _calculatedPrice = discountedPrice / (1 - customDiscount / 100);
          _addToHistory(discountedPrice, customDiscount, _calculatedPrice!);
        });
      }
    } else {
      // Normal mode for custom input
      if (origin != null && customDiscount != null) {
        setState(() {
          _calculatedPrice = origin * (1 - customDiscount / 100);
          _addToHistory(origin, customDiscount, _calculatedPrice!);
        });
      }
    }
  }

  void _addToHistory(double value, double discount, double result) {
    String entry = _isReverseMode
        ? 'Discounted: \$ ${value.toStringAsFixed(2)}\n'
        'Discount: $discount%\n'
        'Original: \$ ${result.toStringAsFixed(2)}'
        : 'Original: \$ ${value.toStringAsFixed(2)}\n'
        'Discount: $discount%\n'
        'Discounted: \$ ${result.toStringAsFixed(2)}';

    _history.insert(0, entry);
    if (_history.length > 5) {
      _history = _history.sublist(0, 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discount Calculator'),
        actions: [
          Switch(
            value: _isReverseMode,
            onChanged: (value) {
              setState(() {
                _isReverseMode = value;
                _calculatedPrice = null; // Clear the result when mode changes
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isReverseMode)
                TextField(
                  controller: _originController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Original Price',
                    border: OutlineInputBorder(),
                  ),
                )
              else
                TextField(
                  controller: _discountedPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Discounted Price',
                    border: OutlineInputBorder(),
                  ),
                ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(20, (index) {
                  int discount = (index + 1) * 5;
                  return ElevatedButton(
                    onPressed: () => _calculatePrice(discount.toDouble()),
                    child: Text('$discount%'),
                  );
                }),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _customDiscountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Custom Discount (%)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateCustomPrice,
                child: Text('Apply Custom Discount'),
              ),
              SizedBox(height: 16),
              if (_calculatedPrice != null)
                Text(
                  _isReverseMode
                      ? 'Original Price: \$ ${_calculatedPrice!.toStringAsFixed(2)}'
                      : 'Discounted Price: \$ ${_calculatedPrice!.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 16),
              Text(
                'History:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5,
                ),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.blue[50],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, color: Colors.blue, size: 20),
                          SizedBox(height: 4),
                          Wrap(
                            children: [
                              Text(
                                _history[index],
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
