class CarStatus {
  final String strtgYn;
  final String doorYn;
  final String wndwYn;
  final String emgncLmpYn;
  final String tailgateYn;
  final String hoodYn;
  final String cdysmYn;
  final String handleYn;
  final String frontmirrorYn;
  final String backmirrorHeatYn;
  final String sidemirrorHeatYn;

  CarStatus({
    required this.strtgYn,
    required this.doorYn,
    required this.wndwYn,
    required this.emgncLmpYn,
    required this.tailgateYn,
    required this.hoodYn,
    required this.cdysmYn,
    required this.handleYn,
    required this.frontmirrorYn,
    required this.backmirrorHeatYn,
    required this.sidemirrorHeatYn,
  });

  CarStatus copyWith({
    String? strtgYn,
    String? doorYn,
    String? wndwYn,
    String? emgncLmpYn,
    String? tailgateYn,
    String? hoodYn,
    String? cdysmYn,
    String? handleYn,
    String? frontmirrorYn,
    String? backmirrorHeatYn,
    String? sidemirrorHeatYn,
  }) {
    return CarStatus(
      strtgYn: strtgYn ?? this.strtgYn,
      doorYn: doorYn ?? this.doorYn,
      wndwYn: wndwYn ?? this.wndwYn,
      emgncLmpYn: emgncLmpYn ?? this.emgncLmpYn,
      tailgateYn: tailgateYn ?? this.tailgateYn,
      hoodYn: hoodYn ?? this.hoodYn,
      cdysmYn: cdysmYn ?? this.cdysmYn,
      handleYn: handleYn ?? this.handleYn,
      frontmirrorYn: frontmirrorYn ?? this.frontmirrorYn,
      backmirrorHeatYn: backmirrorHeatYn ?? this.backmirrorHeatYn,
      sidemirrorHeatYn: sidemirrorHeatYn ?? this.sidemirrorHeatYn,
    );
  }
}
