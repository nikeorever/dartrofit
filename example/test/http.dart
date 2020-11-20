import 'package:dartrofit/dartrofit.dart';
import 'package:dartrofit_adapter_rx/dartrofit_adapter_rx.dart';
import 'package:dartrofit_converter_xml/dartrofit_converter_xml.dart';
import 'package:mockserver/mockserver.dart';
import 'package:wedzera/core.dart';

final mockServer = HttpMockServer();

final dartrofit = Dartrofit(mockServer.url('api/')).also((dartrofit) {
  dartrofit
    ..addCallAdapterFactory(RxDartCallAdapterFactory())
    ..addConverterFactory(XmlConverterFactory());
});
