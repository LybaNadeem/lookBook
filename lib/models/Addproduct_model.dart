class AddProductModel {
  String? id;
  String? title;
  List<String>? categories;
  String? DressTitle;
  String? price;
  String? projectDescription;
  List<String>? image;
  String? minimumorder;
  String? instagram;
  String? linkedin;
  String? barcode;
  String? Eventdate;
  String? Event;
  String? Colors;
  List<String>? Sizes;
  AddProductModel({
    this.id,
    required this.title,
    this.categories,
    this.DressTitle,
    this.price,
    this.projectDescription,
    this.image,
    this.minimumorder,
    this.instagram,
    this.linkedin,
    this.barcode,
    this.Eventdate,
    this.Event,
    this.Colors,
    this.Sizes,
  });
  AddProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    categories = json['categories'].cast<String>();
    DressTitle = json['DressTitle'];
    price = json['price'];
    projectDescription = json['projectDescription'];
    image = json['image'].cast<String>();
    minimumorder = json['minimumorder'];
    instagram = json['instagram'];
    linkedin = json['linkedin'];
    barcode = json['barcode'];
    Eventdate = json['Eventdate'];
    Event = json['Event'];
    Colors = json['Colors'];
    Sizes = json['Sizes'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['categories'] = this.categories;
    data['DressTitle'] = this.DressTitle;
    data['price'] = this.price;
    data['projectDescription'] = this.projectDescription;
    data['image'] = this.image;
    data['minimumorder'] = this.minimumorder;
    data['instagram'] = this.instagram;
    data['linkedin'] = this.linkedin;
    data['barcode'] = this.barcode;
    data['Eventdate'] = this.Eventdate;
    data['Event'] = this.Event;
    data['Colors'] = this.Colors;
    data['Sizes'] = this.Sizes;

    return data;
  }
}
