class RerollPoints {
  final int currentPoints;
  final int maxRolls;
  final int numberOfRolls;
  final int pointsCostToRoll;
  final int pointsToReroll;

  const RerollPoints({
    required this.currentPoints,
    required this.maxRolls,
    required this.numberOfRolls,
    required this.pointsCostToRoll,
    required this.pointsToReroll,
  });

  factory RerollPoints.fromJson(Map<String, dynamic> json) {
    return RerollPoints(
      currentPoints: json['currentPoints'] as int,
      maxRolls: json['maxRolls'] as int,
      numberOfRolls: json['numberOfRolls'] as int,
      pointsCostToRoll: json['pointsCostToRoll'] as int,
      pointsToReroll: json['pointsToReroll'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPoints': currentPoints,
      'maxRolls': maxRolls,
      'numberOfRolls': numberOfRolls,
      'pointsCostToRoll': pointsCostToRoll,
      'pointsToReroll': pointsToReroll,
    };
  }

  @override
  String toString() {
    return 'RerollPoints{currentPoints: $currentPoints, maxRolls: $maxRolls, numberOfRolls: $numberOfRolls}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RerollPoints &&
          runtimeType == other.runtimeType &&
          currentPoints == other.currentPoints &&
          maxRolls == other.maxRolls &&
          numberOfRolls == other.numberOfRolls &&
          pointsCostToRoll == other.pointsCostToRoll &&
          pointsToReroll == other.pointsToReroll;

  @override
  int get hashCode =>
      currentPoints.hashCode ^
      maxRolls.hashCode ^
      numberOfRolls.hashCode ^
      pointsCostToRoll.hashCode ^
      pointsToReroll.hashCode;
}