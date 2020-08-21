import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit_adapter_rx/dartrofit_adapter_rx.dart';
import 'package:dartrofit_converter_json/dartrofit_converter_json.dart';
import 'package:dartrofit_converter_xml/dartrofit_converter_xml.dart';

final dartrofit = Dartrofit(Uri.parse('http://0.0.0.0:7777/'))
  ..adapterFactories.add(SubjectAdaptFactory())
  ..converterFactories.addAll([XmlConverterFactory(), JsonConverterFactory()]);
