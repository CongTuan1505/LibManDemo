# LibMan – Quản lý thư viện

Ứng dụng web Java hỗ trợ hai nghiệp vụ: **tìm kiếm tài liệu** dành cho bạn đọc và **cho mượn tài liệu** dành cho nhân viên thư viện.

## Chức năng

- Đăng nhập, đăng xuất và kiểm tra quyền theo vai trò `READER` / `LIBRARIAN`.
- Bạn đọc: tìm tài liệu theo tên, xem kết quả, thông tin tài liệu và các bản sao.
- Nhân viên: tìm bạn đọc theo mã thẻ hoặc mã bạn đọc, xác nhận bạn đọc, tra cứu và chọn bản sao để mượn.
- Lập phiếu mượn, xem chi tiết và in phiếu; hạn trả hiển thị bằng ngày mượn cộng 14 ngày.
- Lưu phiếu, chi tiết phiếu và cập nhật trạng thái bản sao trong cùng một giao dịch; kiểm tra lại tình trạng bản sao trước khi lưu.

## Công nghệ và cấu trúc

Project sử dụng Java, JSP/JSTL, JDBC và MySQL; đóng gói bằng Maven thành file WAR. JSP xử lý yêu cầu và gọi DAO; các lớp trong package `module` biểu diễn thực thể dữ liệu.

```text
pom.xml                              Cấu hình Maven và các thư viện
sql/LibMan8.sql                       Khởi tạo 9 bảng và dữ liệu mẫu
src/main/java/
  module/                            9 lớp thực thể
  dao/                               DAO8 và các DAO nghiệp vụ
src/main/resources/
  db.properties                      Cấu hình kết nối MySQL
src/main/webapp/
  index.jsp                          Chuyển đến trang đăng nhập
  assets/Style8.css                  CSS dùng chung
  view/
    LoginPage8.jsp                    Đăng nhập
    LogoutPage8.jsp                   Đăng xuất
    common/Auth8.jspf                 Kiểm tra phiên đăng nhập và vai trò
    BanDoc/                          Trang chủ, tìm kiếm, kết quả, chi tiết tài liệu
    NhanVienThuVien/                  Trang chủ, chọn bạn đọc, mượn, tra cứu bản sao, phiếu mượn
  WEB-INF/web.xml                    Cấu hình ứng dụng web
```

Tên lớp, DAO và trang JSP sử dụng hậu tố `8` theo quy ước của project.

## Giao diện

Giao diện dùng nền xám nhạt, khung nội dung trắng và điểm nhấn xanh trầm. Bảng, nút, ô nhập và thông báo được định dạng thống nhất bằng `Style8.css`, không cần thư viện giao diện bên ngoài.

- Trang đăng nhập có nhãn ô nhập, hỗ trợ tự điền thông tin và kiểm tra trường bắt buộc.
- Cả 11 trang giao diện có cấu hình viewport cho thiết bị di động; bảng rộng có thể cuộn ngang trên màn hình nhỏ.
- Chế độ in ẩn các thành phần có lớp `noprint` và đơn giản hóa khung trang.

## Cài đặt và chạy

### 1. Chuẩn bị

- JDK 8 trở lên; cấu hình biên dịch trong `pom.xml` là Java 8.
- Maven, với lệnh `mvn` có trong `PATH`.
- MySQL 8.
- Tomcat 9 để chạy ứng dụng dùng `javax.servlet` và cấu hình Servlet 4.0 hiện tại.

### 2. Khởi tạo cơ sở dữ liệu

Mở `sql/LibMan8.sql` bằng MySQL Workbench hoặc công cụ quản lý MySQL và chạy script. Script tạo cơ sở dữ liệu `libman8`, các bảng và dữ liệu mẫu.

**Lưu ý:** script xóa rồi tạo lại 9 bảng của ứng dụng trong `libman8`. Chỉ chạy khi muốn khởi tạo hoặc đặt lại dữ liệu demo.

### 3. Cấu hình kết nối

Sửa các khóa trong `src/main/resources/db.properties` theo MySQL trên máy:

```properties
jdbc.url=jdbc:mysql://localhost:3306/libman8?useSSL=false&serverTimezone=UTC
jdbc.username=YOUR_MYSQL_USER
jdbc.password=YOUR_MYSQL_PASSWORD
```

Thay các giá trị mẫu bằng tài khoản MySQL thực tế. Sau khi thay đổi cấu hình, cần build và triển khai lại ứng dụng.

### 4. Build và triển khai

Chạy tại thư mục chứa `pom.xml`:

```shell
mvn clean package
```

Sao chép `target/LibMan.war` vào thư mục `webapps` của Tomcat, khởi động Tomcat rồi truy cập:

```text
http://localhost:8080/LibMan/
```

Địa chỉ trên giả định Tomcat chạy ở cổng `8080` và ứng dụng có context path `/LibMan`. Nếu chạy bằng IDE, dùng cổng và context path đã cấu hình trong IDE.

## Tài khoản demo

| Vai trò | Tên đăng nhập | Mật khẩu |
|---|---|---|
| Bạn đọc | `reader1` | `123456` |
| Nhân viên thư viện | `librarian1` | `123456` |

Mật khẩu trong dữ liệu mẫu được lưu dưới dạng SHA-256, tương ứng với cách kiểm tra trong `UserDAO8`.

## Kiểm tra thủ công

### Tìm kiếm tài liệu

1. Đăng nhập bằng `reader1`.
2. Chọn **Tìm tài liệu**, nhập `Cơ sở dữ liệu`, nhấn **Tìm kiếm**.
3. Mở chi tiết tài liệu và kiểm tra danh sách bản sao.
4. Thử từ khóa không có kết quả và thử gửi biểu mẫu tìm kiếm trống.

### Cho mượn tài liệu

1. Đăng nhập bằng `librarian1`, chọn **Cho mượn tài liệu**.
2. Nhập mã thẻ `THE001` hoặc mã bạn đọc `BD001`, nhấn **Tìm bạn đọc**.
3. Kiểm tra thông tin và chọn **Xác nhận & vào cho mượn**.
4. Nhập mã tài liệu `TL001`, nhấn **Tra cứu**, chọn bản sao còn sẵn như `BS001` hoặc `BS004` rồi thêm vào danh sách mượn.
5. Lập phiếu mượn, kiểm tra thông tin phiếu và thử in.
6. Kiểm tra bản sao vừa mượn chuyển sang trạng thái `BORROWED`.

Trong dữ liệu mẫu ban đầu, `BS007` đã có trạng thái `BORROWED` để kiểm tra trường hợp bản sao không còn sẵn. Sau khi lập phiếu thành công, các bản sao đã chọn sẽ không còn sẵn cho lần thử tiếp theo.

### Giao diện

- Kiểm tra trang đăng nhập, trang chủ của hai vai trò, biểu mẫu và bảng kết quả.
- Thu nhỏ cửa sổ để kiểm tra ô nhập và cuộn ngang bảng trên màn hình nhỏ.
- Kiểm tra bản xem trước khi in phiếu mượn.

Các bước trên là hướng dẫn kiểm tra thủ công, không phải kết quả kiểm thử đã thực hiện.

## Phạm vi hiện tại

Project tập trung vào hai nghiệp vụ tìm kiếm và cho mượn tài liệu. Chưa có giao diện quản lý trả tài liệu, nhập tài liệu, nhà cung cấp hoặc quản trị tài khoản.