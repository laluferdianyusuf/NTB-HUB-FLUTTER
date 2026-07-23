import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

abstract final class InterestIconMapper {
  static IconData iconForName(String name) {
    final key = name.toLowerCase();

    if (key.contains('caffe') ||
        key.contains('resto') ||
        key.contains('coffee')) {
      return Iconsax.coffee;
    }
    if (key.contains('education') || key.contains('training')) {
      return Iconsax.book;
    }
    if (key.contains('entertain')) return Iconsax.music;
    if (key.contains('food')) return Iconsax.coffee;
    if (key.contains('health') || key.contains('medical')) {
      return Iconsax.hospital;
    }
    if (key.contains('hotel') || key.contains('stay')) return Iconsax.building;
    if (key.contains('shop')) return Iconsax.shop;
    if (key.contains('sport') || key.contains('fitness')) {
      return Iconsax.activity;
    }
    if (key.contains('tech')) return Iconsax.cpu;
    if (key.contains('travel') || key.contains('tourism'))
      return Iconsax.global;
    if (key.contains('event')) return Iconsax.calendar;
    if (key.contains('community') || key.contains('komunitas')) {
      return Iconsax.people;
    }
    if (key.contains('culture') || key.contains('budaya')) return Iconsax.book;
    if (key.contains('booking')) return Iconsax.ticket;

    return Iconsax.heart;
  }
}
