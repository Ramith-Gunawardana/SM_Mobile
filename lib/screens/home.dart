import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final txtInput = TextEditingController();
  late FocusNode focuNodetxtInput;
  bool isLoading = false;

  @override
  void initState() {
    focuNodetxtInput = FocusNode();
    super.initState();
  }

  void createRecord() async {
    if (txtInput.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('Data').doc().set({
          'data': txtInput.text.trim(),
          'datetime': DateTime.now().toString(),
        });
        print('data sent');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data sent successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        txtInput.clear();
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
      // DatabaseReference databaseReference =
      //     FirebaseDatabase.instance.ref().child('users');

      // await databaseReference.push().set({
      //   'data': txtInput.text,
      // });
    } else {
      focuNodetxtInput.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Type something to send'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile App'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: txtInput,
              focusNode: focuNodetxtInput,
              decoration: InputDecoration(
                hintText: 'Type something',
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      12,
                    ),
                  ),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      12,
                    ),
                  ),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: createRecord,
                style: const ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                child: !isLoading
                    ? const Text('Send')
                    : const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
