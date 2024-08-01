import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reso/core/secure_storage/hive_storage/restaurant_model.dart';
import 'package:reso/providers/user_data_provider.dart';

class SetupHotelScreen extends ConsumerStatefulWidget {
  const SetupHotelScreen({super.key});

  @override
  ConsumerState<SetupHotelScreen> createState() => _SetupHotelScreenState();
}

class _SetupHotelScreenState extends ConsumerState<SetupHotelScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Setup Your Hotel',
          style: GoogleFonts.ptSans(
            textStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Text(
                    'We are glad to have you here.',
                    style: GoogleFonts.ptSans(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black26,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _nameController,
              label: 'Name of Hotel',
              icon: Icons.hotel,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email of Hotel',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an email address';
                } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              icon: Icons.location_on,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Create',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator ??
          (value) {
            if (value!.isEmpty) {
              return 'Please enter $label.toLowerCase()';
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.ptSans(),
        prefixIcon: Icon(icon),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  void _handleSubmit() {
    final Restaurant restaurant = Restaurant(
      image: '',
      about: '',
      name: _nameController.text,
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ownerId: ref.watch(userDataProvider).userData!.id,
      email: _emailController.text,
      pushToken: '',
      seats: 0,
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      designation: '',
      isApproved: 0,
      tourPage: '',
      isNewUser: true,
    );
    FirebaseFirestore.instance
        .collection('restaurant')
        .doc(restaurant.id)
        .set(restaurant.toJson())
        .then(
      (value) {
        context.push('/');
      },
    );
    // final userdata = ref.watch(userDataProvider).userData!;
    // userdata.isNewUser = false;
    // ref.watch(userDataProvider).updateUserData(userdata);
    // // Navigate to owner screen
  }
}
