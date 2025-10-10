import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/models/borrowed_models.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:absensi/features/authentication/controller/productManagement/borrowed_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';

class EditBorrowedProductForm extends StatefulWidget {
  const EditBorrowedProductForm({
    super.key,
    required this.borrowedItem,
  });

  final BorrowedProductModels borrowedItem;

  @override
  State<EditBorrowedProductForm> createState() => _EditBorrowedProductFormState();
}

class _EditBorrowedProductFormState extends State<EditBorrowedProductForm> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _borrowerNameController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  List<AllProductModel> _allProducts = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
    setState(() {
      _isLoading = true;
    });

    // Pre-fill fields with existing data
    _productNameController.text = widget.borrowedItem.namaBarang;
    _borrowerNameController.text = widget.borrowedItem.namaPeminjam ?? '';
    _totalController.text = widget.borrowedItem.total.toString();
    _descriptionController.text = widget.borrowedItem.deskripsi ?? '';
    _selectedDate = widget.borrowedItem.tanggal ?? DateTime.now();

    // Load products for potential product selection (though namaBarang might be readonly)
    try {
      final products = await BorrowedProductController.fetchProducts();
      setState(() {
        _allProducts = products;
      });
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat data produk: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    // Validation
    if (_productNameController.text.isEmpty ||
        _borrowerNameController.text.isEmpty ||
        _totalController.text.isEmpty) {
      TLoaders.errorSnackBar(
        title: 'Validation Error',
        message: 'Harap isi semua field yang wajib diisi',
      );
      return;
    }

    int total;
    try {
      total = int.parse(_totalController.text);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Validation Error',
        message: 'Total harus berupa angka yang valid',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create updated BorrowedProductModels
      BorrowedProductModels updatedProduct = BorrowedProductModels(
        id: widget.borrowedItem.id,
        namaBarang: _productNameController.text,
        namaPeminjam: _borrowerNameController.text,
        total: total,
        tanggal: _selectedDate,
        deskripsi: _descriptionController.text.isEmpty ? '' : _descriptionController.text,
      );

      // Call controller to update
      var result = await BorrowedProductController.updateBorrowedProduct(updatedProduct);

      setState(() {
        _isSubmitting = false;
      });

      if (result['success']) {
        TLoaders.successSnackBar(title: 'Sukses', message: result['message']);
        Navigator.pop(context); // Close the edit dialog/screen
      } else {
        TLoaders.errorSnackBar(title: 'Error', message: result['message']);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      TLoaders.errorSnackBar(title: 'Error', message: 'Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Edit Peminjaman Barang',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Form
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Barang (readonly, or allow change via search if needed)
                  TextFormField(
                    controller: _productNameController,
                    readOnly: true, // Set to false if you want to allow editing
                    decoration: const InputDecoration(
                      labelText: 'Nama Barang',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.box),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Nama Peminjam
                  TextFormField(
                    controller: _borrowerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Peminjam',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.user),
                    ),
                    validator: (value) => TValidator.validateEmptyText('Nama Peminjam', value),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Total
                  TextFormField(
                    controller: _totalController,
                    decoration: const InputDecoration(
                      labelText: 'Total Dipinjam',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.additem),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => TValidator.validateEmptyText('Total', value),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Tanggal
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Peminjaman',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Iconsax.calendar),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          ),
                          const Icon(Iconsax.arrow_down_1),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Deskripsi
                  TextFormField(
                    maxLines: 3,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi (Optional)',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Update Peminjaman'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _borrowerNameController.dispose();
    _totalController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
