enum Topic { from, connect, disconnect, gauss, mask, demagnetize }

const GaussPointsAmount = 8;

extension TopicIndex on Topic {
  // Overload the [] getter to get the name of the topic.
  operator[](String key) => (name){
    switch(name) {
      case 'x': return Topic.disconnect;
      case 'g':  return Topic.gauss;
      case 'c': return Topic.connect;
      case 'm': return Topic.mask;
      case 'd': return Topic.demagnetize;
      default:       throw RangeError("enum Fruit contains no value '$name'");
    }
  }(key);
}

extension ParseToString on Topic {
  String toShortString() {
    switch(this) {
      case Topic.connect:
        return 'c';
        break;
      case Topic.from:
        return '-';
        break;
      case Topic.disconnect:
        return 'x';
        break;
      case Topic.gauss:
        return 'g';
        break;
      case Topic.mask:
        return 'm';
        break;
      case Topic.demagnetize:
        return 'd';
        break;
    }
    return this.toString().split('.').last[0];
  }
}
