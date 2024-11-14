/// A simple timer class that creates a periodic stream for polling purposes.
class PoolingTimer {
  const PoolingTimer();

  /// Starts a polling stream that emits events at regular intervals.
  ///
  /// The stream will emit an integer incrementing from `0` at each interval
  /// specified by [duration]. The emitted value represents the count of
  /// intervals that have elapsed.
  ///
  /// - [duration]: The time interval between each event.
  ///
  /// Returns a `Stream<int>` that emits values indefinitely at each interval.
  Stream<int> pooling({required Duration duration}) =>
      Stream.periodic(duration, (count) => count);
}
