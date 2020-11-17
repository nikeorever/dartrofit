import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit_converter_xml/dartrofit_converter_xml.dart';
import 'package:wedzera/core.dart';

final dartrofit =
    Dartrofit(Uri.parse('http://0.0.0.0:7777/')).also((dartrofit) {
        dartrofit.addConverterFactory(XmlConverterFactory());
    });
