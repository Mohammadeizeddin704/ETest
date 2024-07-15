import 'package:etest/features/top_up/domain/entities/beneficiary_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/beneficiary/beneficiary_bloc.dart';

class AddBeneficiaryScreen extends StatefulWidget {
  @override
  _AddBeneficiaryScreenState createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final phone = _phoneController.text;

      // Dispatch the add beneficiary event
      BlocProvider.of<BeneficiaryBloc>(context).add(AddBeneficiaryEvent(
        beneficiary: BeneficiaryEntity(
            name: name, phone: phone, id: DateTime.now().toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Beneficiary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<BeneficiaryBloc, BeneficiaryState>(
          listener: (context, state) {
            if (state is MessageBeneficiaryState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pop(context);
            } else if (state is ErrorBeneficiaryState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is MaxBeneficiariesLimitState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              BlocProvider.of<BeneficiaryBloc>(context)
                  .add(const GetBeneficiariesEvent());
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<BeneficiaryBloc, BeneficiaryState>(
            builder: (context, state) {
              if (state is LoadingBeneficiaryState) {
                return const Center(child: CircularProgressIndicator());
              }

              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the name';
                        } else if (value.length > 20) {
                          return 'Name cannot be more than 20 characters';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the phone number';
                        } else if (value.length != 10) {
                          return 'Phone number must be exactly 10 digits';
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Phone number must contain only digits';
                        }
                        return null;
                      },
                    ),
                    20.verticalSpace,
                    ElevatedButton(
                      onPressed: _onSubmit,
                      child: const Text('Add Beneficiary'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
