import 'package:absensi/utils/constans/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/productManagement/inStock_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/models/inStock_models.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

class EditInStockForm extends StatefulWidget {
  const EditInStockForm({super.key, required this.product});

  final InStockProductModel product;

  @override
  State<EditInStockForm> createState() => _EditInStockFormState();
}

class _EditInStockFormState extends State<EditInStockForm> {
  final InstockController _controller = Get.find<InstockController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _totalController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.product.product);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _totalController = TextEditingController(text: widget.product.total.toString());
    _descriptionController = TextEditingController(text: widget.product.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _totalController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        double price = double.tryParse(_priceController.text) ?? 0.0;
        int total = int.tryParse(_totalController.text) ?? 0;

        if (price <= 0) {
          throw Exception('Price must be greater than 0');
        }

        if (total < 0) {
          throw Exception('Total cannot be negative');
        }

        await _controller.updateProduct(
          id: widget.product.id,
          productName: _nameController.text.trim(),
          price: price,
          total: total,
          description: _descriptionController.text.trim(),
          context: context, 
        );

        // Navigate back after successful update
        Get.back(result: true); // Return true to trigger refresh
      } catch (e) {
        // Handle error properly (e.g., show error message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update Product Information', 
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Product Name field
                TextFormField(
                  controller: _nameController,
                  validator: (value) => TValidator.validateEmptyText('Product Name', value),
                  decoration: const InputDecoration(
                    labelText: 'Product Name', 
                    prefixIcon: Icon(Iconsax.box),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Price field
                TextFormField(
                  controller: _priceController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    final price = double.tryParse(value);
                    if (price == null) {
                      return 'Please enter a valid number';
                    }
                    if (price <= 0) {
                      return 'Price must be greater than 0';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Price', 
                    prefixIcon: Icon(Iconsax.dollar_circle),
                    prefixText: 'Rp ',
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Total field
                TextFormField(
                  controller: _totalController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total stock';
                    }
                    final total = int.tryParse(value);
                    if (total == null) {
                      return 'Please enter a valid number';
                    }
                    if (total < 0) {
                      return 'Total cannot be negative';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Stock', 
                    prefixIcon: Icon(Iconsax.add),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Description field
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description', 
                    prefixIcon: Icon(Iconsax.note_text),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields * 2),

                // Update button
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: _controller.isLoading.value ? null : _updateProduct,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: TSizes.lg),
                      ),
                      child: _controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text('Update Product'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}