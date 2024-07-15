import 'package:etest/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:etest/features/auth/presentation/pages/profile_screen.dart';
import 'package:etest/features/top_up/presentation/pages/beneficiary/add_beneficiary_screen.dart';
import 'package:etest/features/top_up/presentation/pages/beneficiary/beneficiaries_screen.dart';
import 'package:etest/features/top_up/presentation/pages/top_up/transaction_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const TransactionHistoryScreen(),
    BeneficiariesScreen(),
  ];

  void _onToggleButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddBeneficiaryPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBeneficiaryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is LoadedUserState) {
              return Row(
                children: [
                  Text('Hi, ${state.user.name}'),
                  5.horizontalSpace,
                  Icon(
                    Icons.verified,
                    color: state.user.isVerified ? Colors.green : Colors.grey,
                  )
                ],
              );
            }
            return const Text('Hi');
          },
        ),
        actions: [IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
        }, icon: Icon(Icons.person))],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is LoadedUserState) {
                  return Text(
                    'Current Balance: AED ${state.user.balance.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                }
                return const Text('Hi');
              },
            ),
          ),


          ToggleButtons(
            isSelected: [_selectedIndex == 0, _selectedIndex == 1],
            onPressed: _onToggleButtonPressed,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Transaction History'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Beneficiaries'),
              ),
            ],
          ),
          _pages[_selectedIndex],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddBeneficiaryPressed,
        tooltip: 'Add New Beneficiary',
        child: const Icon(Icons.add),
      ),
    );
  }
}

