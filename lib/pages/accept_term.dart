import 'package:firebase_integrated_app/pages/add_inventory_Data.dart';
import 'package:firebase_integrated_app/utils/navigation.dart';
import 'package:flutter/material.dart';

import '../utils/dialog.dart';

class AcceptTerm extends StatefulWidget {
  const AcceptTerm({super.key});

  @override
  State<AcceptTerm> createState() => _AcceptTermState();
}

class _AcceptTermState extends State<AcceptTerm> {
  bool isChecked = true;
  bool isChecked2 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
            child: Container(
              height: 170,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 146, 146, 146)),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 12.0, top: 20, bottom: 2),
                          child: Text('Çalışan Adı'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Cem Eren Badur',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 12.0, top: 10, bottom: 2),
                          child: Text('Çalışan Kodu'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              '20290229',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://avatars.githubusercontent.com/u/82811515?v=4',
                        width: MediaQuery.of(context).size.width / 2.8,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: InkWell(
                    onTap: () {
                      isChecked = !isChecked;
                      setState(() {});
                    },
                    child: isChecked
                        ? const Icon(Icons.check_box_outline_blank)
                        : const Icon(Icons.check_box_outlined)),
              ),
              TextButton(
                  onPressed: () {}, child: const Text('Sorumluluk metnini')),
              const Text("okudum onaylıyorum."),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: InkWell(
                    onTap: () {
                      isChecked2 = !isChecked2;
                      setState(() {});
                    },
                    child: isChecked2
                        ? const Icon(Icons.check_box_outline_blank)
                        : const Icon(Icons.check_box_outlined)),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Yukarıdaki bilgiler doğrudur."),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: MaterialButton(
                      onPressed: () {
                        if (!isChecked && !isChecked2) {
                          Navigation.addRoute(
                              context, const AddInventoryData());
                        } else {
                          showMyDialog(context, "Lütfen koşulları onaylayın");
                        }
                      },
                      child: const Icon(Icons.arrow_forward)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
