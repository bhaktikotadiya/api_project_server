class student
{
    String? id,name,contact,city,image;

    @override   //right click ->generate ->to string
    String toString() {
      return 'student{id: $id, name: $name, contact: $contact, city: $city, image: $image}';
    }

    student(this.id, this.name, this.contact, this.city, this.image);  //right click ->generate ->constructor

    factory student.fromMap(Map m)
    {
      return student(m['id'],m['name'],m['contact'],m['city'],m['image']);
    }
}