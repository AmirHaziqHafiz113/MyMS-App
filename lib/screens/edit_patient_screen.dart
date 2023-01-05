import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/patient.dart';
import '../providers/patients_provider.dart';

class EditPatientScreen extends StatefulWidget {
  static const routeName = '/edit-patient_screen';

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _priceFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _diagnosisFocusNode = FocusNode();
  final _treatmentFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedPatient = Patient(
    id: null,
    name: '',
    price: 0,
    age: 0,
    diagnosis: '',
    treatment: '',
    image: '',
  );

  var _initValues = {
    'name': '',
    'price': '',
    'age': '',
    'diagnosis': '',
    'treatment': '',
    'image': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final patientId = ModalRoute.of(context).settings.arguments as String;
      if (patientId != null) {
        _editedPatient = Provider.of<Patients_Provider>(context, listen: false)
            .findById(patientId);
        _initValues = {
          'name': _editedPatient.name,
          'price': _editedPatient.price.toString(),
          'age': _editedPatient.age.toString(),
          'diagnosis': _editedPatient.diagnosis,
          'treatment': _editedPatient.treatment,
          'image': _editedPatient.image,
        };
        _imageController.text = _editedPatient.image;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _ageFocusNode.dispose();
    _diagnosisFocusNode.dispose();
    _treatmentFocusNode.dispose();
    _imageController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imageController.text.startsWith('http') &&
              !_imageController.text.startsWith('https')) ||
          (!_imageController.text.endsWith('.png') &&
              !_imageController.text.endsWith('.jpg') &&
              !_imageController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _savePatient() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedPatient.id != null) {
      await Provider.of<Patients_Provider>(context, listen: false)
          .updatePatient(_editedPatient.id, _editedPatient);
    } else {
      try {
        await Provider.of<Patients_Provider>(context, listen: false)
            .addPatient(_editedPatient);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Patient'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savePatient,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['name'],
                        decoration: InputDecoration(labelText: 'Name'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedPatient = Patient(
                            name: value,
                            price: _editedPatient.price,
                            age: _editedPatient.age,
                            diagnosis: _editedPatient.diagnosis,
                            treatment: _editedPatient.treatment,
                            image: _editedPatient.image,
                            id: _editedPatient.id,
                            isMarked: _editedPatient.isMarked,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_ageFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedPatient = Patient(
                            name: _editedPatient.name,
                            price: double.parse(value),
                            age: _editedPatient.age,
                            diagnosis: _editedPatient.diagnosis,
                            treatment: _editedPatient.treatment,
                            image: _editedPatient.image,
                            id: _editedPatient.id,
                            isMarked: _editedPatient.isMarked,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['age'],
                        decoration: InputDecoration(labelText: 'Age'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _ageFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_diagnosisFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an age.';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (int.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedPatient = Patient(
                            name: _editedPatient.name,
                            price: _editedPatient.price,
                            age: int.parse(value),
                            diagnosis: _editedPatient.diagnosis,
                            treatment: _editedPatient.treatment,
                            image: _editedPatient.image,
                            id: _editedPatient.id,
                            isMarked: _editedPatient.isMarked,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['diagnosis'],
                        decoration: InputDecoration(labelText: 'Diagnosis'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _diagnosisFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_treatmentFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a diagnosis.';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedPatient = Patient(
                            name: _editedPatient.name,
                            price: _editedPatient.price,
                            age: _editedPatient.age,
                            diagnosis: value,
                            treatment: _editedPatient.treatment,
                            image: _editedPatient.image,
                            id: _editedPatient.id,
                            isMarked: _editedPatient.isMarked,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['treatment'],
                        decoration: InputDecoration(labelText: 'Treatment'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _treatmentFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a treatment.';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedPatient = Patient(
                            name: _editedPatient.name,
                            price: _editedPatient.price,
                            age: _editedPatient.age,
                            diagnosis: _editedPatient.diagnosis,
                            treatment: value,
                            image: _editedPatient.image,
                            id: _editedPatient.id,
                            isMarked: _editedPatient.isMarked,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              image: _imageController.text.isEmpty
                                  ? null
                                  : DecorationImage(
                                      image:
                                          NetworkImage(_imageController.text),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image Link'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageController,
                              focusNode: _imageFocusNode,
                              onFieldSubmitted: (_) {
                                _savePatient();
                              },
                              onSaved: (value) {
                                _editedPatient = Patient(
                                  name: _editedPatient.name,
                                  price: _editedPatient.price,
                                  age: _editedPatient.age,
                                  diagnosis: _editedPatient.diagnosis,
                                  treatment: _editedPatient.treatment,
                                  image: value,
                                  id: _editedPatient.id,
                                  isMarked: _editedPatient.isMarked,
                                );
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
