import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/models/student_model.dart';
import 'package:edu_smart_assistant/models/report_model.dart';
import 'package:edu_smart_assistant/services/parent_service.dart';

class ParentProvider extends ChangeNotifier {
  List<StudentModel> _children = [];
  StudentModel? _selectedChild;
  ReportModel? _weeklyReport;
  ReportModel? _monthlyReport;
  bool _isLoading = false;
  String? _errorMessage;
  final ParentService _parentService = ParentService();

  List<StudentModel> get children => _children;
  StudentModel? get selectedChild => _selectedChild;
  ReportModel? get weeklyReport => _weeklyReport;
  ReportModel? get monthlyReport => _monthlyReport;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasChildren => _children.isNotEmpty;

  Future<void> fetchChildren() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _children = await _parentService.getChildren();
      if (_children.isNotEmpty) {
        _selectedChild = _children.first;
        await fetchReport(_selectedChild!.id, 'weekly');
      }
    } catch (e) {
      _errorMessage = null;
      _children = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectChild(StudentModel child) {
    _selectedChild = child;
    notifyListeners();
    fetchReport(child.id, 'weekly');
  }

  Future<void> fetchReport(String childId, String type) async {
    try {
      if (type == 'weekly') {
        _weeklyReport = await _parentService.getWeeklyReport(childId);
      } else {
        _monthlyReport = await _parentService.getMonthlyReport(childId);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل في تحميل التقرير';
      notifyListeners();
    }
  }

  Future<bool> addChild(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final child = await _parentService.addChild(data);
      _children.add(child);
      _selectedChild ??= child;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
