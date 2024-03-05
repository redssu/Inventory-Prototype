class InvalidInventoryCellIndex implements Exception {
  final int cellIndex;
  final int minCellIndex;
  final int maxCellIndex;

  InvalidInventoryCellIndex({
    required this.cellIndex,
    required this.minCellIndex,
    required this.maxCellIndex,
  });

  @override
  String toString() {
    return 'InvalidInventoryCellIndex: $cellIndex is not in the range of $minCellIndex and $maxCellIndex';
  }
}
