# Unified Journey Contract V1

`JourneyContext` is a normalization boundary, not an ownership merger.

Required invariants:
- schema version = 1.0.
- journey type is explicit: Hajj or Umrah.
- every authoritative section carries source authority/provenance.
- Hajj cannot be owned by a commercial-company authority.
- ambiguous external authority fails closed.
- stale/offline state is explicit.
- optional sections may be absent without inventing data.
- adapters remain provider-agnostic.
- no real Nusuk, real data, production, or cross-plane DB access is enabled by this contract.
