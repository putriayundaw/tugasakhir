import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/models/borrowed_models.dart';
import 'package:iconsax/iconsax.dart';
import 'package:absensi/features/authentication/controller/productManagement/borrowed_controller.dart';

class BorrowedProductForm extends StatefulWidget {
  @override
  _BorrowedProductFormState createState() => _BorrowedProductFormState();
}

class _BorrowedProductFormState extends State<BorrowedProductForm> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _borrowerNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
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
      final products = await BorrowedProductController.fetchProducts();
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
    // Validasi form
    if (_productNameController.text.isEmpty ||
        _borrowerNameController.text.isEmpty ||
        _totalController.text.isEmpty) {
      TLoaders.errorSnackBar(
        title: 'Validation Error',
        message: 'Harap isi semua field yang wajib diisi',
      );
      return;
    }

    // Validasi produk dipilih
    if (!_allProducts.any((product) => product.name == _productNameController.text)) {
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

    // Validasi stock
    final selectedProduct = _allProducts.firstWhere(
      (product) => product.name == _productNameController.text,
    );
    
    if (total > selectedProduct.stock) {
      TLoaders.errorSnackBar(
        title: 'Validation Error',
        message: 'Total tidak boleh melebihi stok yang tersedia: ${selectedProduct.stock}',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Buat objek BorrowedProductModels
      BorrowedProductModels borrowedProduct = BorrowedProductModels(
        id: 0, // ID akan digenerate oleh server
        namaBarang: _productNameController.text,
        namaPeminjam: _borrowerNameController.text,
        total: total,
        tanggal: _selectedDate,
        deskripsi: _descriptionController.text,
      );

      // Panggil controller untuk menambah data peminjaman
      var result = await BorrowedProductController.addBorrowedProduct(borrowedProduct);

      setState(() {
        _isSubmitting = false;
      });

      if (result['success']) {
        TLoaders.successSnackBar(title: 'Sukses', message: result['message']);
        // Reset form
        _resetForm();
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
    _descriptionController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Tambah Peminjaman Barang',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Form Peminjaman
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search dan Pilih Produk
                  Text(
                    'Pilih Barang yang Dipinjam',
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
                                  subtitle: Text('Stok: ${product.stock} | Harga: Rp ${product.price}'),
                                  onTap: () => _selectProduct(product),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Nama Barang (otomatis terisi)
                  // TextFormField(
                  //   controller: _productNameController,
                  //   readOnly: true,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Nama Barang',
                  //     border: OutlineInputBorder(),
                  //     prefixIcon: Icon(Iconsax.box),
                  //   ),
                  // ),
                  // const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Harga (otomatis terisi)
          
                  // Nama Peminjam
                  TextFormField(
                    controller: _borrowerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Peminjam ',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.user),
                    ),
                    validator: (value) => TValidator.validateEmptyText('Nama Peminjam', value),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Total Barang Dipinjam
                  TextFormField(
                    controller: _totalController,
                    decoration: const InputDecoration(
                      labelText: 'Total Dipinjam ',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.additem),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => TValidator.validateEmptyText('Total', value),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Tanggal Peminjaman
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Peminjaman *',
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
                      child: const Text('Tambah Peminjaman'),
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
    _descriptionController.dispose();
    super.dispose();
  }
}