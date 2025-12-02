# Deploy TutorHub Backend to Render

## Prerequisites
- GitHub account với repository được push
- Render account (render.com)
- Database trên Render hoặc External MySQL

## Step 1: Push Code to GitHub

```bash
git add .
git commit -m "Prepare for Render deployment"
git push origin dev
```

## Step 2: Tạo Web Service trên Render

1. Vào https://render.com/dashboard
2. Click "New +" → "Web Service"
3. Select "Build and deploy from a Git repository"
4. Connect GitHub account
5. Choose repository `tutorhub-be`
6. Branch: `dev`

## Step 3: Cấu hình Deployment

**Name:** tutorhub-be-api
**Environment:** Docker
**Region:** Singapore (hoặc gần nhất)
**Branch:** dev

### Build & Deploy Settings:
- **Build Command:** Sẽ tự động detect từ Dockerfile
- **Start Command:** Sẽ tự động detect từ Dockerfile

## Step 4: Configure Environment Variables

Thêm các biến môi trường sau trong Render dashboard:

```
PORT=8080
SPRING_PROFILES_ACTIVE=prod

# Database Configuration (từ external database hoặc Render PostgreSQL)
SPRING_DATASOURCE_URL=jdbc:mysql://[HOST]:[PORT]/[DB]?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
SPRING_DATASOURCE_USERNAME=[USERNAME]
SPRING_DATASOURCE_PASSWORD=[PASSWORD]

# JWT Secret (Đổi thành giá trị bảo mật)
JWT_SECRET=your-secure-jwt-secret-key-here-change-this-in-production
```

## Step 5: Deploy Database

### Option A: Sử dụng External MySQL (khuyến nghị)
- Sử dụng MySQL ngoài (ví dụ: AWS RDS, Digital Ocean, etc.)
- Cập nhật `SPRING_DATASOURCE_URL` với connection string

### Option B: Sử dụng Render PostgreSQL
1. Trong Render dashboard, click "New +" → "PostgreSQL"
2. Tạo database
3. Lấy connection string
4. Cập nhật environment variables

**Lưu ý:** Spring Boot app hiện được cấu hình cho MySQL. Nếu dùng PostgreSQL, cần thay đổi:
- Driver
- Dialect trong application.properties

## Step 6: Deploy

1. Click "Deploy"
2. Theo dõi build logs
3. Chờ deployment hoàn thành

## Step 7: Test

```bash
curl https://[YOUR-SERVICE-NAME].onrender.com/api/welcome
```

## Troubleshooting

### Build Failed
- Check logs trong Render dashboard
- Đảm bảo Maven dependency có thể download (kết nối internet)
- Kiểm tra Java version

### Database Connection Error
- Verify connection string
- Kiểm tra firewall/whitelist IP
- Ensure database đã tạo và chạy

### Port Binding Error
- Render tự động gán PORT, không cần config cứng
- Sử dụng `${PORT:8080}` trong application.properties

## Scaling & Monitoring

- **Scaling:** Render dashboard → Instance Type
- **Logs:** Real-time logs trong dashboard
- **Metrics:** CPU, Memory, Requests

## CI/CD (Optional)

Render tự động deploy khi có push vào branch được chọn. Để tắt:
- Settings → Auto-Deploy → Off

## Production Checklist

- [ ] Thay đổi JWT_SECRET thành giá trị bảo mật
- [ ] Bật HTTPS (Render tự động)
- [ ] Cấu hình CORS cho frontend
- [ ] Test tất cả endpoints
- [ ] Setup monitoring/alerts
- [ ] Backup database

## Rollback

Render giữ lại các deployment trước. Để rollback:
1. Dashboard → select previous build
2. Click "Deploy"
