import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorator/controller/database.dart';
import 'package:decorator/controller/shared_pref.dart';
import 'package:decorator/model/order_model.dart';
import 'package:decorator/shared/constants.dart';
import 'package:decorator/shared/loading.dart';
import 'package:decorator/shared/snackbar.dart';
import 'package:decorator/shared/widget_des.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({Key? key}) : super(key: key);

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  bool _loading = true;
  bool _error = false;
  bool _itemsSelected = true;
  bool _datesSelected = true;
  bool _buttonLoading = false;
  bool _amountCalc = false;

  final ScrollController _controller = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cltNameController = TextEditingController();
  final TextEditingController _cltPhoneController = TextEditingController();
  final TextEditingController _cltAddressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _cltNameFocus = FocusNode();
  final FocusNode _cltPhoneFocus = FocusNode();
  final FocusNode _cltAddressFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();

  Map<String, int> countMap = <String, int>{};
  Map<String, int> rateMap = <String, int>{};
  Map<String, int> remMap = <String, int>{};
  List<String> _selectedItems = <String>[];
  List<int> _selectedItemCount = <int>[];
  int _grandTotal = 0;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _nameController.text =
        UserSharedPreferences.getDetailedUseData()?.name ?? "";
    _phoneController.text =
        UserSharedPreferences.getDetailedUseData()?.phone ?? "";
    loadCount(() {
      if (!mounted) return;
      commonSnackbar("Failed to load item counts", context);
    }).whenComplete(() => setState(() => _loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Order"),
      ),
      body: !_error
          ? !_loading
              ? GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: SingleChildScrollView(
                    controller: _controller,
                    padding: pagePadding,
                    physics: bouncingScroll,
                    child: Form(
                      key: _formKey,
                      // items
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            "Item details\n",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _selectedItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            prefixText:
                                                "${_selectedItems[index]}(s): ",
                                            label: Text(
                                                "${_selectedItems[index]}(s)"),
                                            suffix: Text(
                                                "/ ${remMap[_selectedItems[index]].toString()}"),
                                            contentPadding:
                                                const EdgeInsets.all(20.0),
                                            fillColor: formFieldCol,
                                            filled: true,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            border: textFieldBorder(),
                                            focusedBorder: textFieldBorder(),
                                            errorBorder: textFieldBorder(),
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            _selectedItemCount[index] =
                                                int.parse(value);
                                            _amountCalc
                                                ? setState(
                                                    () => _amountCalc = false)
                                                : null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Tooltip(
                                        message: "Remove item",
                                        child: InkWell(
                                          child: const Icon(
                                              Icons.do_not_disturb_on,
                                              size: 32.0),
                                          onTap: () {
                                            _selectedItems.removeAt(index);
                                            _selectedItemCount.removeAt(index);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                ],
                              );
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: buttonCol,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              itemBuilder: (context) {
                                return <PopupMenuItem<String>>[
                                  for (String elem in ITEMS)
                                    PopupMenuItem(
                                      value: elem,
                                      child: Text(elem,
                                          style: const TextStyle(
                                              color: buttonTextCol)),
                                    ),
                                ];
                              },
                              onSelected: (String value) {
                                if (_selectedItems.contains(value)) {
                                } else {
                                  _selectedItems.add(value);
                                  _selectedItemCount.add(0);
                                  _itemsSelected = true;
                                  setState(() {});
                                }
                              },
                              color: buttonCol,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const <Widget>[
                                  Icon(
                                    Icons.add,
                                    color: buttonTextCol,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text("Add Item",
                                      style: TextStyle(
                                          color: buttonTextCol,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          _itemsSelected
                              ? const SizedBox(height: 0.0, width: 0.0)
                              : const Text(
                                  "Please select atleast one item",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.red),
                                ),
                          const SizedBox(height: 20.0),
                          const Text(
                            "Order dates\n",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _startDate != null
                                  ? InkWell(
                                      onTap: () => datePicker(context, true)
                                          .then((value) => setState(
                                              () => _startDate = value)),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: formFieldCol,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            const Text(
                                              "Start Date:    ",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              DateFormat("dd/MM/yyyy, E")
                                                  .format(_startDate!),
                                              style: const TextStyle(
                                                  fontSize: 16.0),
                                            ),
                                            const Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(Icons.edit,
                                                    color: Colors.black45),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : TextButton(
                                      style: authSignInBtnStyle(),
                                      onPressed: () => datePicker(context, true)
                                          .then((value) => setState(
                                              () => _startDate = value)),
                                      child: Row(
                                        children: const <Widget>[
                                          Icon(Icons.date_range),
                                          SizedBox(width: 10.0),
                                          Text("Select start date",
                                              style: TextStyle(fontSize: 15.0)),
                                        ],
                                      ),
                                    ),
                              const SizedBox(height: 10.0),
                              _endDate != null
                                  ? InkWell(
                                      onTap: () => datePicker(context, false)
                                          .then((value) =>
                                              setState(() => _endDate = value)),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: formFieldCol,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            const Text(
                                              "End Date:    ",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              DateFormat("dd/MM/yyyy, E")
                                                  .format(_endDate!),
                                              style: const TextStyle(
                                                  fontSize: 16.0),
                                            ),
                                            const Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(Icons.edit,
                                                    color: Colors.black45),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : TextButton(
                                      style: authSignInBtnStyle(),
                                      onPressed: () => datePicker(
                                              context, false)
                                          .then((value) =>
                                              setState(() => _endDate = value)),
                                      child: Row(
                                        children: const <Widget>[
                                          Icon(Icons.date_range),
                                          SizedBox(width: 10.0),
                                          Text("Select end date",
                                              style: TextStyle(fontSize: 15.0)),
                                        ],
                                      ),
                                    ),
                              const SizedBox(height: 5.0),
                              _datesSelected
                                  ? const SizedBox(height: 0.0, width: 0.0)
                                  : const Text(
                                      "Please select both the dates correctly",
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.red),
                                    ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            "Client details\n",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // client name
                          TextFormField(
                            controller: _cltNameController,
                            decoration: authTextInputDecoration(
                                "Client's Name", Icons.person_outline, null),
                            focusNode: _cltNameFocus,
                            validator: (val) => val!.isEmpty
                                ? "Please enter client's name"
                                : null,
                            maxLength: 20,
                            keyboardType: TextInputType.name,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (val) => FocusScope.of(context)
                                .requestFocus(_cltPhoneFocus),
                            onChanged: (value) => _amountCalc
                                ? setState(() => _amountCalc = false)
                                : null,
                          ),
                          const SizedBox(height: 10.0),
                          // client phone number
                          TextFormField(
                            controller: _cltPhoneController,
                            decoration: authTextInputDecoration(
                                "Client's Phone", Icons.phone_outlined, "+91 "),
                            focusNode: _cltPhoneFocus,
                            validator: (val) => val!.isEmpty
                                ? "Please enter client's number"
                                : null,
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (val) => FocusScope.of(context)
                                .requestFocus(_cltAddressFocus),
                            onChanged: (value) => _amountCalc
                                ? setState(() => _amountCalc = false)
                                : null,
                          ),
                          const SizedBox(height: 10.0),
                          // client address
                          TextFormField(
                            controller: _cltAddressController,
                            decoration: authTextInputDecoration(
                                "Client's Address", Icons.house_outlined, null),
                            focusNode: _cltAddressFocus,
                            validator: (val) => val!.isEmpty
                                ? "Please enter client's address"
                                : null,
                            maxLines: 2,
                            keyboardType: TextInputType.streetAddress,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (val) =>
                                FocusScope.of(context).requestFocus(_nameFocus),
                            onChanged: (value) => _amountCalc
                                ? setState(() => _amountCalc = false)
                                : null,
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            "Employee details\n",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // employee name
                          TextFormField(
                            controller: _nameController,
                            decoration: authTextInputDecoration(
                                "Name", Icons.person, null),
                            focusNode: _nameFocus,
                            validator: (val) =>
                                val!.isEmpty ? "Please enter your name" : null,
                            maxLength: 20,
                            keyboardType: TextInputType.name,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (val) => FocusScope.of(context)
                                .requestFocus(_phoneFocus),
                            onChanged: (value) => _amountCalc
                                ? setState(() => _amountCalc = false)
                                : null,
                          ),
                          const SizedBox(height: 10.0),
                          // employee phone number
                          TextFormField(
                            controller: _phoneController,
                            decoration: authTextInputDecoration(
                                "Phone", Icons.phone, "+91 "),
                            focusNode: _phoneFocus,
                            validator: (val) => val!.isEmpty
                                ? "Please enter your number"
                                : null,
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (val) =>
                                FocusScope.of(context).requestFocus(_noteFocus),
                            onChanged: (value) => _amountCalc
                                ? setState(() => _amountCalc = false)
                                : null,
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            "Notes\n",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          // notes
                          TextFormField(
                            controller: _noteController,
                            decoration: authTextInputDecoration(
                                "Note", Icons.note, null),
                            focusNode: _noteFocus,
                            maxLines: 2,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (val) =>
                                FocusScope.of(context).unfocus(),
                            onChanged: (value) => _amountCalc
                                ? setState(() => _amountCalc = false)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(child: Loading(white: false, rad: 14.0))
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 10.0),
                  Text(
                    "Something went wrong, couldn't load data\n\n"
                    "Please go back and try again later.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: buttonCol,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _amountCalc
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Grand Total:",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: buttonTextCol),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        "??? $_grandTotal",
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent),
                      ),
                    ],
                  )
                : const SizedBox(height: 0.0, width: 0.0),
            SizedBox(height: _amountCalc ? 10.0 : 0.0),
            _amountCalc
                ? ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black,
                      ],
                      stops: [0.0, 0.04, 0.96, 1.0],
                    ).createShader(bounds),
                    blendMode: BlendMode.dstOut,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: bouncingScroll,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          for (int i = 0; i < _selectedItems.length; i++)
                            Text(
                              i == (_selectedItems.length - 1)
                                  ? "${_selectedItems[i]}: ${_selectedItemCount[i]}"
                                  : "${_selectedItems[i]}: ${_selectedItemCount[i]}    |    ",
                              style: const TextStyle(color: buttonTextCol),
                            ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(height: 0.0, width: 0.0),
            SizedBox(height: _amountCalc ? 10.0 : 0.0),
            _amountCalc
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(DateFormat("dd/MM/yyyy").format(_startDate!),
                          style: const TextStyle(color: buttonTextCol)),
                      const Text("    -    ",
                          style: TextStyle(color: buttonTextCol)),
                      Text(DateFormat("dd/MM/yyyy").format(_endDate!),
                          style: const TextStyle(color: buttonTextCol))
                    ],
                  )
                : const SizedBox(height: 0.0, width: 0.0),
            SizedBox(height: _amountCalc ? 5.0 : 0.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(buttonTextCol),
                    foregroundColor: MaterialStateProperty.all(buttonCol),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                    alignment: Alignment.center),
                onPressed: () => orderLogic(
                  () {
                    if (!mounted) return;
                    commonSnackbar("Order placed successfully", context);
                    Navigator.of(context).pop();
                  },
                  () {
                    if (!mounted) return;
                    commonSnackbar(
                        "Failed to request order\n"
                        "Please try again",
                        context);
                  },
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: _buttonLoading
                      ? const Loading(white: false)
                      : Text(
                          _amountCalc ? "Add Order Request" : "Calculate Costs",
                          style: const TextStyle(
                              color: buttonCol,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> datePicker(BuildContext context, bool start) {
    _amountCalc ? setState(() => _amountCalc = false) : null;

    final DateTime now = start
        ? _startDate ?? DateTime.now()
        : _endDate ?? _startDate ?? DateTime.now();

    final DateTime firstDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return showDatePicker(
      context: context,
      initialDate: now,
      firstDate: start ? firstDate : _startDate ?? firstDate,
      lastDate: DateTime(DateTime.now().year + 2),
    );
  }

  Future<void> orderLogic(VoidCallback route, VoidCallback snackbar) async {
    if (_formKey.currentState!.validate() &&
        _selectedItems.isNotEmpty &&
        _startDate != null &&
        _endDate != null) {
      if (_amountCalc) {
        try {
          setState(() => _buttonLoading = true);
          await DatabaseController(uid: UserSharedPreferences.getUid())
              .setOrderData(OrderModel(
            empName: _nameController.text,
            empPhone: _phoneController.text,
            cltName: _cltNameController.text,
            cltPhone: _cltPhoneController.text,
            cltAddress: _cltAddressController.text,
            amount: _grandTotal.toString(),
            item: Map.fromIterables(_selectedItems, _selectedItemCount),
            status: STATUSES[0],
            orderDate: Timestamp.now(),
            startDate: Timestamp.fromDate(_startDate!),
            endDate: Timestamp.fromDate(_endDate!),
            note: _noteController.text,
          ));
          route.call();
        } catch (e) {
          setState(() => _buttonLoading = false);
          snackbar.call();
        }
      } else {
        for (int i = 0; i < _selectedItems.length; i++) {
          _grandTotal +=
              _selectedItemCount[i] * rateMap[_selectedItems[i]]!.toInt();
        }
        _amountCalc = true;
        setState(() {});
      }
    }
    if (_selectedItems.isEmpty) {
      setState(() => _itemsSelected = false);
    }
    if (_startDate == null || _endDate == null) {
      setState(() => _datesSelected = false);
    }
  }

  Future<void> loadCount(VoidCallback snackbar) async {
    try {
      countMap = await DatabaseController().getItemCount();
      remMap = await DatabaseController().getItemRem();
      rateMap = await DatabaseController().getItemRate();
    } catch (e) {
      snackbar.call();
      setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _nameController.dispose();
    _phoneFocus.dispose();
    _phoneController.dispose();
    _cltNameFocus.dispose();
    _cltNameController.dispose();
    _cltPhoneFocus.dispose();
    _cltPhoneController.dispose();
    _cltAddressFocus.dispose();
    _cltAddressController.dispose();
    _noteController.dispose();
    _noteFocus.dispose();
    super.dispose();
  }
}
