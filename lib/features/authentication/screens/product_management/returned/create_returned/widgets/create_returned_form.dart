import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/productManagement/returned_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/models/returned_models.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ReturnedProductForm extends StatefulWidget {
  @override
  _ReturnedProductFormState createState() => _ReturnedProductFormState();
}

class _ReturnedProductFormState extends State<ReturnedProductForm> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _borrowerNameController = TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  List<AllProductModel> _allProducts = [];
  List<AllProductModel> _filteredProducts = [];
  bool _isSearching = false;
  bool _isLoading = false;
  bool _isSubmitting = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
  }

  Future<void> _loadAllProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final products = await ReturnedProductController.fetchProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat data produk: $e',
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectProduct(AllProductModel product) {
    setState(() {
      _productNameController.text = product.name;
      _searchController.text = product.name;
      _isSearching = false;
    });
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validasi produk dipilih
    if (_productNameController.text.isEmpty) {
      TLoaders.errorSnackBar(
        title: 'Validation Error',
        message: 'Pilih produk yang valid dari daftar',
      );
      return;
    }

    // Parse values
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

    // Validasi: total harus positif
    if (total <= 0) {
      TLoaders.errorSnackBar(
        title: 'Validation Error',
        message: 'Total harus lebih dari 0',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Buat objek ReturnedProductModels
      ReturnedProductModels returnedProduct = ReturnedProductModels(
        namaBarang: _productNameController.text,
        namaPeminjam: _borrowerNameController.text,
        total: total,
        tanggal: _selectedDate,
        id:1,
      );

      // Panggil controller untuk menambah data pengembalian
      var result = await ReturnedProductController.addReturnedProduct(returnedProduct);

      setState(() {
        _isSubmitting = false;
      });

      if (result['success'] == true) {
        TLoaders.successSnackBar(title: 'Sukses', message: result['message']);
        // Reset form
        _resetForm();
        // Kembali ke halaman sebelumnya dengan result
        Get.back(result: true);
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

  void _resetForm() {
    _searchController.clear();
    _productNameController.clear();
    _totalController.clear();
    _borrowerNameController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Tambah Pengembalian Barang',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Form Pengembalian
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search dan Pilih Produk
                  Text(
                    'Pilih Barang yang Dikembalikan *',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: TSizes.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _searchController,
                        onChanged: _filterProducts,
                        decoration: const InputDecoration(
                          labelText: 'Cari Produk',
                          hintText: 'Ketik nama produk...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Iconsax.search_normal),
                        ),
                      ),
                      const SizedBox(height: TSizes.sm),

                      // Dropdown untuk hasil pencarian
                      if (_isSearching && _filteredProducts.isNotEmpty)
                        TRoundedContainer(
                          padding: const EdgeInsets.all(0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = _filteredProducts[index];
                                return ListTile(
                                  title: Text(product.name),
                                  subtitle: Text('Stok: ${product.stock}'),
                                  onTap: () => _selectProduct(product),
                                );
                              },
                            ),
                          ),
                        ),

                      // Loading indicator
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.all(TSizes.sm),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  
                  // Nama Peminjam
                  TextFormField(
                    controller: _borrowerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Peminjam *',
                      hintText: 'Masukkan nama peminjam',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.user),
                    ),
                    validator: (value) => TValidator.validateEmptyText('Nama Peminjam', value),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Total Barang Dikembalikan
                  TextFormField(
                    controller: _totalController,
                    decoration: const InputDecoration(
                      labelText: 'Total Dikembalikan *',
                      hintText: 'Masukkan jumlah barang yang dikembalikan',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.additem),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Total harus diisi';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Total harus berupa angka';
                      }
                      if (int.parse(value) <= 0) {
                        return 'Total harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Tanggal Pengembalian
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Pengembalian *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Iconsax.calendar),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy').format(_selectedDate),
                          ),
                          const Icon(Iconsax.arrow_down_1),
                        ],
                      ),
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
                      child: const Text('Tambah Pengembalian'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _productNameController.dispose();
    _totalController.dispose();
    _borrowerNameController.dispose();
    super.dispose();
  }
}