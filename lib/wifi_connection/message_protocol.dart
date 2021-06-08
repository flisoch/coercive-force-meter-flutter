enum Topic { from, connect, disconnect, gauss, mask, demagnetize }

extension TopicIndex on Topic {
  // Overload the [] getter to get the name of the topic.
  operator[](String key) => (name){
    switch(name) {
      case 'disconnect': return Topic.disconnect;
      case 'gauss':  return Topic.gauss;
      case 'connect': return Topic.connect;
      case 'mask': return Topic.mask;
      case 'demagnetize': return Topic.demagnetize;
      default:       throw RangeError("enum Fruit contains no value '$name'");
    }
  }(key);
}

extension ParseToString on Topic {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
