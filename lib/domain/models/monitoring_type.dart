enum MonitoringType {
  solar('solar'),
  house('house'),
  battery('battery');

  /// A descriptive label for each enum value.
  final String label;

  /// Constructor to initialize the [label] for each enum value.
  const MonitoringType(this.label);
}
