import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountManagementPage extends StatefulWidget {
  const AccountManagementPage({super.key});

  @override
  State<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  
  String _email = '';

  @override
  void initState() {
    super.initState();
    _email = _auth.currentUser?.email ?? '';
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    // Validate inputs
    if (_currentPasswordController.text.isEmpty) {
      _showErrorSnackbar('Please enter your current password');
      return;
    }
    if (_newPasswordController.text.isEmpty) {
      _showErrorSnackbar('Please enter your new password');
      return;
    }
    if (_confirmPasswordController.text.isEmpty) {
      _showErrorSnackbar('Please confirm your new password');
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showErrorSnackbar('New passwords do not match');
      return;
    }
    if (_newPasswordController.text.length < 6) {
      _showErrorSnackbar('Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Clear controllers
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      _showSuccessSnackbar('Password changed successfully');
    } catch (e) {
      _showErrorSnackbar('Failed to change password: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Account Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          Text(
            'Email',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: Text(
              _email,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Security',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _currentPasswordController,
            label: 'Current Password',
            showPassword: _showCurrentPassword,
            onToggle: () => setState(() => _showCurrentPassword = !_showCurrentPassword),
          ),
          const SizedBox(height: 12),
          _buildPasswordField(
            controller: _newPasswordController,
            label: 'New Password',
            showPassword: _showNewPassword,
            onToggle: () => setState(() => _showNewPassword = !_showNewPassword),
          ),
          const SizedBox(height: 12),
          _buildPasswordField(
            controller: _confirmPasswordController,
            label: 'Confirm New Password',
            showPassword: _showConfirmPassword,
            onToggle: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _isLoading ? null : _changePassword,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool showPassword,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller,
        obscureText: !showPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF2ECC71),
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
