import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // FilteringTextInputFormatter

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F3_221A010861', // TODO: thay bằng MSSV của bạn
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0468D7)),
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Chìa khóa để điều khiển Form: validate(), reset(), save()
  final _formKey = GlobalKey<FormState>();

  // Controller đọc nội dung ô nhập — nhớ dispose()
  final _hoTenCtrl = TextEditingController();
  final _mssvCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  static const _monHocs = ['Lập trình di động', 'Cơ sở dữ liệu', 'Trí tuệ nhân tạo', 'Kiểm thử phần mềm'];
  static const _buoiHocs = ['Sáng', 'Chiều', 'Tối'];

  String? _monHoc; // giá trị của Dropdown (null = chưa chọn)
  String _heDaoTao = 'Chính quy'; // giá trị của nhóm Radio
  final Set<String> _buoiDaChon = {}; // các Checkbox đã tick
  bool _nhanThongBao = true; // Switch
  double _soTinChi = 15; // Slider

  @override
  void dispose() {
    _hoTenCtrl.dispose();
    _mssvCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  // ---------------- Kiểm tra hợp lệ ----------------
  String? _kiemTraHoTen(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Vui lòng nhập họ tên';
    if (s.length < 3) return 'Họ tên phải có ít nhất 3 ký tự';
    return null; // null = hợp lệ
  }

  String? _kiemTraMssv(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Vui lòng nhập MSSV';
    if (!RegExp(r'^\d{10}$').hasMatch(s)) return 'MSSV phải gồm đúng 10 chữ số';
    return null;
  }

  String? _kiemTraEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Vui lòng nhập email';
    if (!RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$').hasMatch(s)) return 'Email không đúng định dạng';
    return null;
  }

  void _dangKy() {
    // 1) Kiểm tra các trường của Form
    final hopLe = _formKey.currentState!.validate();

    // 2) Kiểm tra các thành phần nằm ngoài Form
    if (_buoiDaChon.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hãy chọn ít nhất một buổi học')),
      );
      return;
    }

    // NC2: Kiểm tra phụ thuộc (Vừa làm vừa học bắt buộc chọn buổi Tối)
    if (_heDaoTao == 'Vừa làm vừa học' && !_buoiDaChon.contains('Tối')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hệ Vừa làm vừa học bắt buộc phải chọn buổi Tối')),
      );
      return;
    }

    if (!hopLe) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng ký'),
        content: Text(
          'Họ tên: ${_hoTenCtrl.text.trim()}\n'
          'MSSV: ${_mssvCtrl.text.trim()}\n'
          'Email: ${_emailCtrl.text.trim()}\n'
          'Học phần: $_monHoc\n'
          'Hệ đào tạo: $_heDaoTao\n'
          'Buổi học: ${(_buoiDaChon.toList()..sort()).join(", ")}\n'
          'Số tín chỉ: ${_soTinChi.round()}\n'
          'Nhận thông báo: ${_nhanThongBao ? "Có" : "Không"}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
        ],
      ),
    );
  }

  void _lamLai() {
    _formKey.currentState!.reset(); // xóa nội dung và thông báo lỗi của các trường trong Form
    _hoTenCtrl.clear();
    _mssvCtrl.clear();
    _emailCtrl.clear();
    setState(() {
      _monHoc = null;
      _heDaoTao = 'Chính quy';
      _buoiDaChon.clear();
      _nhanThongBao = true;
      _soTinChi = 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab F3 – Đăng ký học phần'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction, // báo lỗi ngay khi gõ
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // NC3: Giới hạn tối đa 50 ký tự và có bộ đếm tự động
              TextFormField(
                controller: _hoTenCtrl,
                textInputAction: TextInputAction.next,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: _kiemTraHoTen,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mssvCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  labelText: 'Mã số sinh viên *',
                  prefixIcon: Icon(Icons.badge_outlined),
                  helperText: 'Gồm đúng 10 chữ số',
                ),
                validator: _kiemTraMssv,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                validator: _kiemTraEmail,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey(_monHoc),
                initialValue: _monHoc,
                decoration: const InputDecoration(
                  labelText: 'Học phần đăng ký *',
                  prefixIcon: Icon(Icons.menu_book_outlined),
                ),
                items: _monHocs
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => _monHoc = v),
                validator: (v) => v == null ? 'Hãy chọn một học phần' : null,
              ),
              const SizedBox(height: 20),
              Text('Hệ đào tạo', style: Theme.of(context).textTheme.titleMedium),
              RadioGroup<String>(
                groupValue: _heDaoTao,
                onChanged: (v) => setState(() => _heDaoTao = v ?? 'Chính quy'),
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      value: 'Chính quy',
                      title: Text('Chính quy'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      value: 'Vừa làm vừa học',
                      title: Text('Vừa làm vừa học'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('Buổi học mong muốn (chọn ≥ 1)', style: Theme.of(context).textTheme.titleMedium),
              ..._buoiHocs.map((b) => CheckboxListTile(
                    value: _buoiDaChon.contains(b),
                    title: Text(b),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (chon) => setState(() {
                      if (chon == true) {
                        _buoiDaChon.add(b);
                      } else {
                        _buoiDaChon.remove(b);
                      }
                    }),
                  )),
              const SizedBox(height: 8),
              Text('Số tín chỉ đăng ký: ${_soTinChi.round()}', style: Theme.of(context).textTheme.titleMedium),
              Slider(
                value: _soTinChi,
                min: 10,
                max: 24,
                divisions: 14,
                label: '${_soTinChi.round()}',
                onChanged: (v) => setState(() => _soTinChi = v),
              ),
              SwitchListTile(
                value: _nhanThongBao,
                title: const Text('Nhận thông báo qua email'),
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => _nhanThongBao = v),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _dangKy,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('ĐĂNG KÝ'),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: _lamLai, child: const Text('Làm lại')),
            ],
          ),
        ),
      ),
    );
  }
}