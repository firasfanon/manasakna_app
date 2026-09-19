import 'journey_context.dart';

abstract class JourneyContextProvider {
  String get providerId;
  Future<JourneyContext> loadJourneyContext();
}

class JourneyContextGateway {
  const JourneyContextGateway(this.provider);
  final JourneyContextProvider provider;
  Future<JourneyContext> load() async {
    final context = await provider.loadJourneyContext();
    context.validate();
    return context;
  }
}
