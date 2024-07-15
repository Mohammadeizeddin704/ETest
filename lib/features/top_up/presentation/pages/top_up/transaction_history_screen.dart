import 'package:etest/features/top_up/presentation/bloc/top_up/top_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopUpBloc, TopUpState>(
      builder: (context, state) {
        if (state is LoadingTransactionsState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadedTransactionsState) {
          if (state.transactions.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(20.sp),
              child: Center(child: const Text("No transactions have been created yet.")),
            );
          }
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 20.sp),
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
                return Card(
                  margin: EdgeInsets.all(8.sp),
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Amount: AED ${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.sp),
                        Text(
                          'Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(transaction.date)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('Failed to load Transactions'));
        }
      },
    );
    return const Center(
      child: Text('Transaction History'),
    );
  }
}
