/*generate dummy data*/

import 'ModelImage.dart';

class Dummy {
  static const List<String> images_header_auto = [
    "banner1.jpg",
    "banner2.jpg",
    "banner3.jpg",
    "banner4.jpg",
    "banner5.jpg"
  ];
  static const List<String> title_header_auto = [
    "Dui fringilla ornare finibus, orci odio",
    "Mauris sagittis non elit quis fermentum",
    "Mauris ultricies augue sit amet est sollicitudin",
    "Suspendisse ornare est ac auctor pulvinar",
    "Vivamus laoreet aliquam ipsum eget pretium",
  ];
  static const List<String> subtitle_header_auto = [
    "Foggy Hill",
    "The Backpacker",
    "River Forest",
    "Mist Mountain",
    "Side Park",
  ];

  static List<ModelImage> getModelImage() {
    final List<ModelImage> items = [];
    for (int i = 0; i < images_header_auto.length; i++) {
      ModelImage obj = new ModelImage();
      obj.image = images_header_auto[i];
      obj.name = title_header_auto[i];
      obj.brief = subtitle_header_auto[i];
      items.add(obj);
    }
    return items;
  }
}
