class SeatRowEntity {
  String id;
  String rowId;
  String seatId;
  int count;
  List<int> offs = [];
  List<int> booked = [];

  SeatRowEntity({
    required this.id,
    required this.seatId,
    required this.rowId,
    required this.count,
    required this.offs,
    required this.booked,
  });

  @override
  String toString() {
    return 'SeatRow{rowId: $rowId}';
  }
}
