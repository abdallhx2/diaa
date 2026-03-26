import 'package:flutter/material.dart';

class StudentModel {
  final String id;
  final String name;
  final String? role;
  const StudentModel({required this.id, required this.name, this.role});
}

class ReportModel {
  final String type;
  final Map<String, dynamic> data;
  const ReportModel({required this.type, required this.data});
}

class ParentService {
  Future<List<StudentModel>> getChildren() async => [];
  Future<ReportModel>         getWeeklyReport(String childId)  async => const ReportModel(type: 'weekly',  data: {});
  Future<ReportModel>         getMonthlyReport(String childId) async => const ReportModel(type: 'monthly', data: {});
  Future<StudentModel>         addChild(Map<String, dynamic> data) async =>
      StudentModel(id: data['id'] as String? ?? '', name: data['name'] as String? ?? '');
}

class ParentProvider extends ChangeNotifier {
  List<StudentModel> _children      = [];
  StudentModel?      _selectedChild;
  ReportModel?       _weeklyReport;
  ReportModel?       _monthlyReport;
  bool               _isLoading     = false;
  String?            _errorMessage;
  final ParentService _parentService = ParentService();

  List<StudentModel> get children      => List.unmodifiable(_children);
  StudentModel?      get selectedChild => _selectedChild;
  ReportModel?       get weeklyReport  => _weeklyReport;
  ReportModel?       get monthlyReport => _monthlyReport;
  bool               get isLoading     => _isLoading;
  String?            get errorMessage  => _errorMessage;
  bool               get hasChildren   => _children.isNotEmpty;

  Future<void> fetchChildren() async {
    _errorMessage = null;
    _isLoading    = true;
    notifyListeners();

    try {
      final List<StudentModel> result = await _parentService.getChildren();
      _children = result;
      _selectedChild = _children.isNotEmpty ? _children.first : null;
    } catch (e) {
      _errorMessage = 'تعذّر تحميل قائمة الأطفال. يرجى المحاولة مجدداً.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectChild(StudentModel child) async {
    _selectedChild = child;
    _weeklyReport  = null;
    _monthlyReport = null;
    notifyListeners();

    await Future.wait([
      fetchReport(child.id, 'weekly'),
      fetchReport(child.id, 'monthly'),
    ]);
  }

  Future<void> fetchReport(String childId, String type) async {
    _errorMessage = null;

    try {
      if (type == 'weekly') {
        _weeklyReport  = await _parentService.getWeeklyReport(childId);
      } else if (type == 'monthly') {
        _monthlyReport = await _parentService.getMonthlyReport(childId);
      } else {
        _errorMessage = 'نوع التقرير غير معروف: $type';
      }
    } catch (e) {
      _errorMessage = type == 'weekly'
          ? 'تعذّر تحميل التقرير الأسبوعي. يرجى المحاولة مجدداً.'
          : 'تعذّر تحميل التقرير الشهري. يرجى المحاولة مجدداً.';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> addChild(Map<String, dynamic> data) async {
    _errorMessage = null;
    _isLoading    = true;
    notifyListeners();

    try {
      final StudentModel newChild = await _parentService.addChild(data);
      _children = [..._children, newChild];
      if (_children.length == 1) _selectedChild = newChild;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'تعذّر إضافة الطفل. يرجى التحقق من البيانات والمحاولة مجدداً.';
      _isLoading    = false;
      notifyListeners();
      return false;
    }
  }

  void clearReports() {
    _weeklyReport  = null;
    _monthlyReport = null;
    _errorMessage  = null;
    notifyListeners();
  }

  void reset() {
    _children      = [];
    _selectedChild = null;
    _weeklyReport  = null;
    _monthlyReport = null;
    _isLoading     = false;
    _errorMessage  = null;
    notifyListeners();
  }
}