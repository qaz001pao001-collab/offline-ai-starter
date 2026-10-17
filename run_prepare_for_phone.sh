#!/usr/bin/env bash
# ตัวอย่างคำสั่ง (บนเครื่องคอมพิวเตอร์) เพื่อเตรียมโมเดลสำหรับมือถือ
# แนวคิด: แปลงโมเดลเป็นรูปแบบ ggml/gguf (สำหรับ llama.cpp) บีบอัด/quantize แล้วคัดลอกไปมือถือ

set -e

# 1) ดาวน์โหลดโมเดลต้นทาง (ตัวอย่างใช้ Hugging Face CLI) - ทำบนคอมพิวเตอร์ที่มีทรัพยากร
# pip install huggingface-hub
# hf login
# ตัวอย่าง: hf repo download หรือ git lfs clone ขึ้นอยู่กับโมเดล

# 2) แปลงเป็น ggml (ตัวอย่างสมมติว่า repo llama.cpp มีสคริปต์ convert)
# ปรับ PATHS ให้ตรงกับเครื่องของคุณ
MODEL_DIR="$HOME/models/original"
OUT_DIR="$HOME/models/ggml"
mkdir -p "$OUT_DIR"

# ตัวอย่างคำสั่งแปลง (สคริปต์แปลงของแต่ละ repo จะแตกต่างกัน)
# python3 convert.py --input "$MODEL_DIR" --output "$OUT_DIR/ggml-model.bin" --quantize 4

# 3) ตรวจสอบขนาดไฟล์ แล้วคัดลอกไปมือถือ (ผ่าน USB หรือ scp)
# ตัวอย่างคัดลอกผ่าน ADB (Android):
# adb push "$OUT_DIR/ggml-model.bin" /sdcard/Download/models/

# 4) บนมือถือ: ติดตั้ง Termux (Android) และวางไฟล์ไว้ในโฟลเดอร์ที่เข้าถึงได้
# 5) บนมือถือใน Termux ให้รัน binary ที่ build ไว้ (แนะนำ build บนคอมพิวเตอร์เป็น cross-compile สำหรับ Android แล้วคัดลอก binary)
# ตัวอย่างการรัน (บนมือถือ/Termux):
# ./main -m /sdcard/Download/models/ggml-model.bin -p "สวัสดี" -t 2

# หมายเหตุสำคัญ:
# - การคอมไพล์ llama.cpp สำหรับ Android ต้องใช้ Android NDK (ยากบนมือถือ) — แนะนำคอมไพล์บนคอมพิวเตอร์แล้วคัดลอก binary
# - ถ้าไม่ต้องการคอมไพล์เอง ให้ค้นหา prebuilt Android binaries ของโปรเจกต์ที่เชื่อถือได้
# - ปรับเธร็ด (-t) ให้เหมาะกับจำนวนคอร์ CPU ของมือถือ

echo "สคริปต์ตัวอย่างเสร็จสิ้น: ใช้วิธีแปลงบนคอมพิวเตอร์ แล้วคัดลอกไฟล์ไปมือถือตามคำแนะนำในไฟล์ phone_setup.md"
