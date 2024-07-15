import 'package:etest/features/auth/domain/entities/user_entity.dart';
import 'package:etest/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserSuccessfullyState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ErrorUserState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is LoadedUserState) {
              final UserEntity user = state.user;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${user.name}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Verification Status: ',
                              style: TextStyle(fontSize: 18)),
                          Switch(
                            value: user.isVerified,
                            onChanged: (newValue) {
                              context.read<AuthBloc>().add(
                                  UpdateUserVerificationEvent(
                                      isVerify: newValue));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Balance: AED ${user.balance.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Enter amount to add',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an amount';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final amount =
                                    double.parse(_amountController.text);
                                context
                                    .read<AuthBloc>()
                                    .add(AddFundEvent(amount: amount));
                                // Un focus keyboard after fund added
                                FocusScope.of(context).unfocus();
                                // Clear amount input field
                                _amountController.clear();
                              }
                            },
                            child: const Text('Add Fund'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
