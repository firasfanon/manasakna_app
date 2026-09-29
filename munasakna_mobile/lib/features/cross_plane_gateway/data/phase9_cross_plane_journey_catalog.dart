import '../../journey_contract/data/synthetic_journey_context_provider.dart';
import '../../journey_contract/domain/journey_context.dart';
import '../../journey_contract/domain/journey_context_provider.dart';
import '../../unified_journey/data/phase8_journey_catalog.dart';
import '../domain/cross_plane_gateway.dart';

class Phase9CrossPlaneJourneyCatalog implements Phase8JourneyCatalog {
  Phase9CrossPlaneJourneyCatalog({
    SyntheticCrossPlaneGatewayTransport? transport,
  }) : transport = transport ?? SyntheticCrossPlaneGatewayTransport();

  final SyntheticCrossPlaneGatewayTransport transport;

  @override
  Future<List<JourneyContext>> loadEligibleJourneys() async {
    final hajj = await const JourneyContextGateway(
      SyntheticJourneyContextProvider(type: JourneyType.hajj),
    ).load();

    final request = CrossPlaneGatewayRequest(
      contractVersion: phase9CrossPlaneContractVersion,
      requestId: 'phase9-preview-request-001',
      idempotencyKey: 'phase9-preview-idempotency-001',
      requestedAt: DateTime.utc(2026, 9, 23, 20),
      identity: const CrossPlaneServiceIdentity(
        serviceId: phase9ConsumerServiceId,
        audience: phase9BusinessAudience,
        scopes: {phase9TravelerProjectionScope},
      ),
      journeyType: 'umrah',
      tenantId: 'synthetic-tenant-001',
      bookingId: 'synthetic-booking-001',
      requestedFields: phase9AllowedProjectionFields,
    );

    final umrah = await JourneyContextGateway(
      CommercialUmrahCrossPlaneProvider(
        client: CrossPlaneGatewayClient(transport),
        request: request,
      ),
    ).load();

    return [hajj, umrah];
  }
}
