import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/productManagement/addproduct_controller.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/foundation.dart';

class CreateAddProductsForm extends StatefulWidget {
  const CreateAddProductsForm({super.key});

  @override
  _CreateAddProductsFormState createState() => _CreateAddProductsFormState();
}

class _CreateAddProductsFormState extends State<CreateAddProductsForm> {
  final ProductsController _controller = Get.find<ProductsController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  String? selectedParentProduct;
  bool isFeatured = false;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TSizes.sm),
            Text('Create New Products',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Image Upload Section
            _buildImageUploader(),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Input nama produk
            TextFormField(
              controller: productNameController,
              validator: (value) => TValidator.validateEmptyText('Product Name', value),
              decoration: const InputDecoration(
                  labelText: 'Products Name',
                  prefixIcon: Icon(Iconsax.shopping_bag)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Input harga produk
            TextFormField(
              controller: priceController,
              validator: (value) => TValidator.validateEmptyText('Price', value),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Price', prefixIcon: Icon(Iconsax.dollar_square)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Input total produk
            TextFormField(
              controller: totalController,
              validator: (value) => TValidator.validateEmptyText('Total', value),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Total', prefixIcon: Icon(Iconsax.add)),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Dropdown untuk memilih ParentProduct
           

            // Checkbox untuk menentukan apakah produk "featured"
            Row(
              children: [
                Checkbox(
                  value: isFeatured,
                  onChanged: (value) {
                    setState(() {
                      isFeatured = value!;
                    });
                  },
                ),
                const Text('Featured')
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // Tombol untuk membuat produk
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Product'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploader() {
    return Column(
      children: [
        Text(
          'Product Image',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: TSizes.sm),
        Obx(() => Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _controller.isImageSelected
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: kIsWeb 
                    ? Image.memory(
                        _controller.selectedImageBytes.value!,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      )
                    : Image.file(
                        _controller.selectedImageFile.value!,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        'No Image',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
        )),
        const SizedBox(height: TSizes.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _controller.pickImage(),
              icon: const Icon(Icons.photo_library, size: 16),
              label: const Text('Gallery'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          
           
          ],
        ),
        if (_controller.isImageSelected)
          TextButton(
            onPressed: () => _controller.clearImage(),
            child: const Text('Remove Image'),
          ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (productNameController.text.isEmpty ||
          priceController.text.isEmpty ||
          totalController.text.isEmpty) {
        TLoaders.errorSnackBar(
          title: 'Validation Error',
          message: 'Please fill all required fields',
        );
        return;
      }

      await _controller.createProduct(
        productName: productNameController.text,
        price: priceController.text,
        total: totalController.text,
        parentProduct: selectedParentProduct ?? '',
        isFeatured: isFeatured,
        context: context,
      );
      
      // Reset form setelah berhasil
      _resetForm();
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    productNameController.clear();
    priceController.clear();
    totalController.clear();
    setState(() {
      selectedParentProduct = '';
      isFeatured = false;
    });
    _controller.clearImage();
  }

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    totalController.dispose();
    super.dispose();
  }
}