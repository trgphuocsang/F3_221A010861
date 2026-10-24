# Lab F3 – Nhập liệu & Form trong Flutter — đăng ký học phần

- **Họ và tên:** Trương Phước Sang
- **Mã số sinh viên (MSSV):** 221A010861

---

## 1. Giới thiệu dự án
Ứng dụng Flutter xây dựng form đăng ký học phần hoàn chỉnh, áp dụng cơ chế validate dữ liệu, quản lý trạng thái (`Form State`), xử lý thông báo qua `SnackBar` & `AlertDialog`, cùng việc tối ưu hóa bộ nhớ với `dispose()`.

---

## 2. Các bài nâng cao đã thực hiện (Phần 8)
Trong bài lab này, em đã hoàn thành 2 bài nâng cao:

* **NC2 (Kiểm tra phụ thuộc):** 
  * *Yêu cầu:* Nếu người dùng chọn hệ đào tạo *"Vừa làm vừa học"* nhưng lại không chọn buổi *"Tối"*, hệ thống sẽ chặn lại.
  * *Cách thực hiện:* Bổ sung điều kiện kiểm tra trong hàm `_dangKy()` trước khi hiển thị hộp thoại, nếu vi phạm sẽ kích hoạt `SnackBar` nhắc nhở.
* **NC3 (Giới hạn ký tự Họ tên):** 
  * *Yêu cầu:* Đếm và giới hạn ký tự cho ô nhập "Họ tên".
  * *Cách thực hiện:* Thêm thuộc tính `maxLength: 50` vào `TextFormField` của trường Họ và tên để Flutter tự động giới hạn độ dài và hiển thị bộ đếm ký tự trực quan.