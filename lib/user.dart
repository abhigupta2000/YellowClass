class User{
  final int id;
  final String title;
  final String videoUrl;
  final String coverPicture;

  const User({
    required this.id,
  required this.title,
  required this.videoUrl,
  required this.coverPicture
});
   static User fromJson(json) => User(
     id: json['id'],
     title: json['title'],
     videoUrl: json['videoUrl'],
     coverPicture: json['coverPicture']
   );


}