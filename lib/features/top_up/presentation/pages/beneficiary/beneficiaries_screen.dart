import 'package:etest/features/top_up/presentation/bloc/beneficiary/beneficiary_bloc.dart';
import 'package:etest/features/top_up/presentation/pages/top_up/recharge_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BeneficiariesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      child: BlocBuilder<BeneficiaryBloc, BeneficiaryState>(
        builder: (context, state) {
          if (state is LoadingBeneficiaryState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedBeneficiariesState) {
            if (state.beneficiaries.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(20.sp),
                child: Center(child: const Text("No beneficiaries have been added yet.")),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.only(top: 20.sp),
              scrollDirection: Axis.horizontal,
              itemCount: state.beneficiaries.length,
              itemBuilder: (context, index) {
                final beneficiary = state.beneficiaries[index];
                return Card(
                  margin: EdgeInsetsDirectional.only(start: 8.sp),
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(beneficiary.name),
                        Text(beneficiary.phone),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RechargeScreen(
                                      beneficiaryId: beneficiary.id ?? ""),
                                ));
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.blueAccent),
                          ),
                          child: const Text(
                            'Recharge now',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Failed to load beneficiaries'));
          }
        },
      ),
    );
  }
}
