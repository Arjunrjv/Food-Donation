import 'package:flutter/material.dart';
import 'package:fooddon/donor/donation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upi_india/upi_india.dart';

class ContributePage extends StatefulWidget {
  @override
  _ContributePageState createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> _apps = [];
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUpiApps();
  }

  Future<void> _getUpiApps() async {
    List<UpiApp> installedApps = await _upiIndia.getAllUpiApps(
      allowNonVerifiedApps: true,
      mandatoryTransactionId: false,
    );

    setState(() {
      _apps = installedApps;
    });
  }

  Future<void> initiatePayment(UpiApp selectedApp) async {
    if (_apps.isNotEmpty) {
      final response = await _initiateTransaction(selectedApp);
      _handlePaymentResponse(response);
    }
  }

  String _transactionRefId =
      DateTime.now().toUtc().millisecondsSinceEpoch.toString();

  Future<UpiResponse> _initiateTransaction(UpiApp app) async {
    String amount = _amountController.text;
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "ajayraveendran619@paytm",
      receiverName: 'Ajay Raveendran',
      transactionRefId: _transactionRefId,
      transactionNote: 'Contribution',
      amount: double.parse(amount),
    );
  }

  void _handlePaymentResponse(UpiResponse response) {
    if (response.status == UpiPaymentStatus.SUCCESS) {
      print('Payment successful');
    } else if (response.status == UpiPaymentStatus.FAILURE) {
      print('Payment failed');
    } else if (response.status == UpiPaymentStatus.FAILURE) {
      print('Payment cancelled');
    } else if (response.status == UpiPaymentStatus.FAILURE) {
      print('Payment error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyDonation(),
              ),
            );
          },
        ),
        elevation: 0,
        title: Text(
          'Donor Contribution',
          style: GoogleFonts.barlowSemiCondensed(
            color: const Color(0xffCDFF01),
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Text(
                  "Contribute",
                  style: GoogleFonts.barlowSemiCondensed(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),
                const SizedBox(height: 10),
                // Input field for the amount
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: GoogleFonts.barlowSemiCondensed(
                        color: const Color(0xffCDFF01)),
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: "Amount (Rs)",
                      labelStyle: GoogleFonts.barlowSemiCondensed(
                          color: const Color(0xffCDFF01)),
                      hintStyle: GoogleFonts.barlowSemiCondensed(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.w500), // Adjust opacity as needed
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.25)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xffCDFF01)),
                      ),
                    ),
                  ),
                ),
                if (_apps.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _apps.length,
                    itemBuilder: (context, index) {
                      UpiApp app = _apps[index];
                      return ListTile(
                        title: Text(
                          app.name,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: const Color(0xff54740E),
                          ),
                        ),
                        onTap: () {
                          initiatePayment(app);
                        },
                      );
                    },
                  ),
                if (_apps.isEmpty)
                  Text(
                    'No UPI apps found on your device',
                    style: GoogleFonts.barlowSemiCondensed(color: Colors.white),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
