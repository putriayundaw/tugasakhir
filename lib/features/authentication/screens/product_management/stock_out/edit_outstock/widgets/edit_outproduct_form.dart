import 'package:absensi/features/authentication/controller/productManagement/outStock_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/add_outStock/models/OutStock_models.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

class EditOutStockForm extends StatefulWidget {
  const EditOutStockForm({super.key, required this.product});

  final OutStockProductModel product;

  @override
  State<EditOutStockForm> createState() => _EditOutStockFormState(); // Fixed class name
}

class _EditOutStockFormState extends State<EditOutStockForm> {
  final OutstockController _controller = Get.find<OutstockController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _totalController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.product.product);
    _totalController = TextEditingController(text: widget.product.total.toString());
    _descriptionController = TextEditingController(text: widget.product.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _totalController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        int total = int.tryParse(_totalController.text) ?? 0;

        if (total <= 0) {
          throw Exception('Total must be greater than 0');
        }

        await _controller.updateProduct(
          id: widget.product.id,
          productName: _nameController.text.trim(),
          total: total,
          description: _descriptionController.text.trim(),
          context: context,
        );

        // Navigate back after successful update
        // Get.back() sudah dipanggil di controller, jadi tidak perlu di sini
      } catch (e) {
        // Error handling sudah dilakukan oleh controller
        // Tidak perlu showSnackBar di sini karena controller sudah menampilkan TLoaders
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Out Stock Product'),
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
                  'Update Out Stock Product Information', 
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

                // Price field (Read-only, for display only)
                TextFormField(
                  initialValue: 'Rp ${_formatPrice(widget.product.price)}',
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Price (Read-only)', 
                    prefixIcon: Icon(Iconsax.dollar_circle),
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
                    if (total <= 0) {
                      return 'Total must be greater than 0';
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

                // Parent Product (Read-only, for display only)
                TextFormField(
                  initialValue: widget.product.parentProduct.isNotEmpty 
                      ? widget.product.parentProduct 
                      : 'No parent product',
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Parent Product (Read-only)', 
                    prefixIcon: Icon(Iconsax.category),
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
                  child: ElevatedButton(
                    onPressed: _updateProduct,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: TSizes.lg),
                    ),
                    child: const Text('Update Out Stock Product'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method untuk format harga
  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}