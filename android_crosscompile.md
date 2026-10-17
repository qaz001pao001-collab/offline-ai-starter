# Cross‑compile llama.cpp (ARM64) สำหรับ Android (คำแนะนำ)

หมายเหตุสำคัญ: ขั้นตอนต่อไปนี้เป็นแนวทางทั่วไป — ขึ้นกับเวอร์ชันของ llama.cpp และเครื่องมือบนเครื่องของคุณ อาจต้องปรับบ้าง

1) เตรียมเครื่องบนคอมพิวเตอร์
- ติดตั้ง Android NDK (r25 หรือเวอร์ชันที่ใหม่กว่า) จาก https://developer.android.com/ndk/downloads
- ติดตั้ง CMake, git, build-essential

2) ดึงโค้ด llama.cpp
- git clone https://github.com/ggerganov/llama.cpp.git
- cd llama.cpp

3) สร้าง build directory และรัน CMake ด้วย toolchain ของ Android
- ตัวอย่าง (ปรับ ANDROID_NDK_PATH ให้ตรงกับเครื่องของคุณ):

  export ANDROID_NDK_PATH=/path/to/android-ndk
  mkdir -p build-android && cd build-android
  cmake .. \
    -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_PATH/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-21 \
    -DANDROID_STL=c++_static

- ถ้ารันสำเร็จ ให้รัน: make -j$(nproc)
- ผลลัพธ์ควรเป็น binary สำหรับ ARM64 (เช่น main)

4) ทดสอบบนเครื่อง Android
- คัดลอก binary ไปยังมือถือ (adb push build-android/main /sdcard/Download/models/)
- ใช้ Termux หรือ adb shell เพื่อรัน binary (หา Permission/SELinux อาจต้อง chmod +x)

5) ปัญหาที่อาจพบ
- บางโพรเจกต์ไม่มี CMake หรือใช้ Makefile เฉพาะ — ในกรณีนั้นให้ดู README ของโพรเจกต์หรือค้นหาคำว่า "android" ใน Issues/PR ของ repo
- หาก binary รันแต่ติดปัญหาไลบรารี ให้ตรวจสอบว่าคุณได้ตั้งค่า STL และ platform ให้ถูกต้อง
- การคอมไพล์ด้วย NDK บางครั้งต้องระบุ FLAG เพิ่มเติม เช่น -DGGML_USE_ACCELERATE=ON หรืออื่น ๆ ขึ้นกับฟีเจอร์ที่ต้องการ

ถ้าต้องการ ผมสามารถเขียนสคริปต์ cross‑compile ที่ทำงานบน Ubuntu/X86 ให้คุณได้ (ต้องระบุ path ของ NDK และเวอร์ชัน)