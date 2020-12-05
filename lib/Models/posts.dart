class Posts {
  String date;
  String description;
  String image;
  String time;
  String title;
  String id;
  bool fav;

  Posts(this.date, this.description, this.image, this.time, this.title, this.id,
      this.fav);

  Posts.fromMap(Map snapshot, String id)
      : id = id ?? '',
        date = snapshot['date'] ?? '',
        description = snapshot['description'] ?? '',
        image = snapshot['image'] ?? '',
        time = snapshot['time'] ?? '',
        title = snapshot['title'] ?? '',
        fav = snapshot['fav'] ?? '';

  toJson() {
    return {
      'id': id,
      'date': date,
      'description': description,
      'image': image,
      'time': time,
      'title': title,
      'fav': fav,
    };
  }
}
