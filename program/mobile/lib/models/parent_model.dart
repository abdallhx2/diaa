import 'package:edu_smart_assistant/models/student_model.dart';
 
class ParentModel {
  final String             id;
  final String             userId;
  final String             name;
  final String             email;
  final String             phone;
  final int                numChildren;
  final List<StudentModel> children;
 
  ParentModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    this.phone       = '',
    this.numChildren = 0,
    this.children    = const [],
  });
 
  factory ParentModel.fromJson(Map<String, dynamic> json) => ParentModel(
    id:          json['id']           ?? '',
    userId:      json['user_id']      ?? '',
    name:        json['name']         ?? '',
    email:       json['email']        ?? '',
    phone:       json['phone']        ?? '',
    numChildren: json['num_children'] ?? 0,
    children:    (json['children'] as List<dynamic>?)
                   ?.map((e) => StudentModel.fromJson(e as Map<String, dynamic>))
                   .toList() ?? [],
  );
 
  Map<String, dynamic> toJson() => {
    'id':           id,
    'user_id':      userId,
    'name':         name,
    'email':        email,
    'phone':        phone,
    'num_children': numChildren,
    'children':     children.map((e) => e.toJson()).toList(),
  };
}
 