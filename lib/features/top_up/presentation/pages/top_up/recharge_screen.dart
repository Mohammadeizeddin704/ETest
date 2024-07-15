import 'package:etest/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:etest/features/top_up/presentation/bloc/beneficiary/beneficiary_bloc.dart';
import 'package:etest/features/top_up/presentation/bloc/top_up/top_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RechargeScreen extends StatefulWidget {
  final String beneficiaryId;

  RechargeScreen({super.key, required this.beneficiaryId});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final _formKey = GlobalKey<FormState>();
  double? amount;
  final List<double> topUpOptions = [5, 10, 20, 30, 50, 75, 100];

  @override
  void dispose() {
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate() && amount != null) {
      BlocProvider.of<TopUpBloc>(context).add(RequestTopUpEvent(
        amount: amount!,
        beneficiaryId: widget.beneficiaryId,
        user: BlocProvider.of<AuthBloc>(context).user,
        beneficiaries: BlocProvider.of<BeneficiaryBloc>(context).beneficiaries,
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
        child: BlocListener<TopUpBloc, TopUpState>(
          listener: (context, state) {
            if (state is TopUpSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Top-Up successful!')),
              );
              //Transaction fee
              BlocProvider.of<AuthBloc>(context)
                  .add(AddFundEvent(amount: -state.totalAmount));
              Navigator.pop(context);
            } else if (state is TopUpFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<TopUpBloc, TopUpState>(
            builder: (context, state) {
              if (state is LoadingTransactionsState) {
                return const Center(child: CircularProgressIndicator());
              }

              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text(
                      'Select Top-Up Amount',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    DropdownButtonFormField<double>(
                      hint: const Text('Select Amount'),
                      value: amount,
                      onChanged: (double? newValue) {
                        setState(() {
                          amount = newValue;
                        });
                      },
                      items: topUpOptions.map((double value) {
                        return DropdownMenuItem<double>(
                          value: value,
                          child: Text('AED $value'),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: _onSubmit,
                      child: const Text('Submit'),
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
