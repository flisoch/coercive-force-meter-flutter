enum Topic { from, connect, disconnect, gauss, mask, demagnetize }

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
    return this.toString().split('.').last;
  }
}
