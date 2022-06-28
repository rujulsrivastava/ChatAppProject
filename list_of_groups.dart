Map<int, Chat> groupsList = {1 : Chat(title: 'Foodies', description: 'Khana banana nahi khana pasand hai'), 2 : Chat(title: 'Booksters', description: 'For all the book lovers!')};

class Chat {
  late String title;
  late String? description;
  Chat({required this.title, this.description});
}