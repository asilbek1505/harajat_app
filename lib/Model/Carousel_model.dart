class CarouselModel{
String? image;
String id='';

CarouselModel({required this.image});

CarouselModel.fromJson(Map<String,dynamic>json )
    :image=json['image'],
id=json['id'];


Map<String,dynamic>toJson()=>{
 'image':image,
 'id':id,
};
}