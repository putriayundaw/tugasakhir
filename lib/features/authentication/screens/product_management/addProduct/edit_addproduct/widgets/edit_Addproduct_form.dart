import 'package:flutter/material.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/common/widgets/images/image_uploader.dart';
import 'package:absensi/features/authentication/controller/productManagement/addproduct_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/Models/addproduct_model.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class EditAddProductForm extends StatefulWidget {
  const EditAddProductForm({super.key, required this.product});

  final ProductModel product;

  @override
  _EditAddProductFormState createState() => _EditAddProductFormState();
}

class _EditAddProductFormState extends State<EditAddProductForm> {
  final ProductsController _controller = ProductsController();
  late TextEditingController productNameController;
  late TextEditingController priceController;
  late TextEditingController totalController;
  late TextEditingController dateController;
  String? selectedParentProduct;

  @override
  void initState() {
    super.initState();
    // Initialize controllers dengan data produk yang ada
    productNameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(text: widget.product.price);
    totalController = TextEditingController(text: widget.product.total);
    selectedParentProduct = widget.product.parentProduct;
    
    // Format date untuk text field
    dateController = TextEditingController(
      text: widget.product.dateAdded != null 
          ? _formatDate(widget.product.dateAdded!)
          : ''
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    totalController.dispose();
    dateController.dispose();
    super.dispose();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Text('Edit Product', 
                     style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Product Name Field
                TextFormField(
                  controller: productNameController,
                  validator: (value) => TValidator.validateEmptyText('Product Name', value),
                  decoration: const InputDecoration(
                    labelText: 'Product Name', 
                    prefixIcon: Icon(Iconsax.shopping_bag)
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Price Field
                TextFormField(
                  controller: priceController,
                  validator: (value) => TValidator.validateEmptyText('Price', value),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixIcon: Icon(Iconsax.dollar_square)
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Total Field
                TextFormField(
                  controller: totalController,
                  validator: (value) => TValidator.validateEmptyText('Total', value),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total',
                    prefixIcon: Icon(Iconsax.add)
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Date Field
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Iconsax.calendar)
                  ),
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: widget.product.dateAdded ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        dateController.text = _formatDate(picked);
                      });
                    }
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

  
                const SizedBox(height: TSizes.spaceBtwInputFields * 2),

                // Image Uploader
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validasi input
                      if (productNameController.text.isEmpty || 
                          priceController.text.isEmpty || 
                          totalController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all required fields')),
                        );
                        return;
                      }

                      // Panggil controller untuk update
                      bool success = await _controller.updateProduct(
                        productId: widget.product.id,
                        productName: productNameController.text,
                        price: priceController.text,
                        total: totalController.text,
                        parentProduct: selectedParentProduct ?? '',
                        // imageUrl: widget.product.imageUrl,
                        context: context,
                      );

                      // Jika sukses, kembali ke halaman sebelumnya
                      if (success && mounted) {
                        Navigator.of(context).pop(true); // Return true untuk trigger refresh
                      }
                    },
                    child: const Text('Update Product'),
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