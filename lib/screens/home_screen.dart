import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/screens/add_expenses_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All','Food' , 'Health' , 'Shopping' , 'Transport' , 'Other'];
  @override
  Widget build(BuildContext context ) {
    final expenses = ref.watch(expenseProvider);
      final filtered = selectedCategory == 'All' ?expenses
      :expenses.where((e)=>e.category==selectedCategory).toList();
    double total = expenses.fold(0.0, (sum , expense) => sum +expense.amount);
      return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo.withValues(alpha: 0.3),
          actions: [
            IconButton(onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            }, icon: Icon(Icons.logout , color: Colors.black,))
          ],
        ),
        body:
        expenses.isEmpty
        ?   Container(
          height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white54 , Colors.indigoAccent , Colors.white12])
        ),child: Center(
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Icon(Icons.dangerous_outlined , size: 30,),
    Text('No expenses yet' , style: TextStyle(fontSize: 25 , color: Colors.black),),
    Text('Click + to add new ones' , style: TextStyle(fontSize: 15 , color: Colors.black),)
    ],
    ),
    ))
       : Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white54 , Colors.indigoAccent , Colors.white12])
        ),
          child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.indigoAccent,
          border: Border.symmetric(),
          borderRadius: BorderRadius.circular(10)
        ),
        child:

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              for(String cat in categories)
                GestureDetector(
                  onTap:()=> setState(()=>selectedCategory = cat ),
                  child: Column(
                    children: [
                      Text(cat , style: TextStyle(color: selectedCategory==cat ? Colors.black : Colors.white ),),
                    ],
                  ),
                )
              ],
            )),
           const SizedBox(height: 25,),
            Container(
              padding: EdgeInsets.all(14),
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              border: Border.all(color: Colors.black.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(10)),
             child:   Text('Total Amount: ${total.toStringAsFixed(3)} DT ' , style: TextStyle(
            color: Colors.black ),),
            ),
            const SizedBox(height: 10,),

                Text("Your Expenses" , style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold ,color: Colors.black
            ),
            ),
                        Expanded(child:Container(
                          padding: EdgeInsets.all(14),
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.6),
                              border: Border.all(color: Colors.black.withValues(alpha: 0.4)),
                              borderRadius: BorderRadius.circular(10)),
                          child:
                        ListView.builder(
                            itemCount:filtered.length,
                            itemBuilder: (context , index) {
                              return ListTile(
                                 trailing:Row(
                                  mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(onPressed: (){Navigator.push(context,
                                          MaterialPageRoute(builder: (context)=> AddExpensesScreen(expense: filtered[index],)));}, icon: Icon(Icons.edit , color: Colors.blue[600],)),
                                      TextButton(onPressed: (){
                                        ref.read(expenseProvider.notifier).deleteExpense(filtered[index].id);
                                      }
                                          , child: Icon(Icons.delete , color: Colors.red,)),
]),
                                leading:  Text('${filtered[index].date.day}/${filtered[index].date.month}/${filtered[index].date.year} ', style: TextStyle(
                                    fontSize: 13
                                ),),
                                title: Text(filtered[index].category , style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(filtered[index].note,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis, // cuts long text with ...
                                    ),
                                    Text('${filtered[index].amount.toStringAsFixed(3)} DT',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );

                            }),

                        ),
                        ),
                      ]
        ),

      ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.pushNamed(context, '/addexpenses' , );

        }, child: Icon(Icons.add),),
      );
   }
  }
