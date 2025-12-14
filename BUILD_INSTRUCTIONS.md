# دليل بناء تطبيق C2 Panel كـ EXE

## المتطلبات
1. **Node.js** - الإصدار 18 أو أحدث ([تحميل](https://nodejs.org/))
2. **Git** - لنسخ المشروع ([تحميل](https://git-scm.com/))
3. **Windows 10/11** - لبناء ملف exe
4. **Visual Studio Build Tools** - مطلوب لتجميع better-sqlite3

## خطوات البناء

### 1. تحميل المشروع
- اضغط على زر "Download as ZIP" من Replit
- فك الضغط عن الملف في مجلد على جهازك

### 2. تثبيت أدوات البناء (مرة واحدة فقط)
```bash
npm install -g windows-build-tools
# أو
npm install -g node-gyp
```

### 3. إنشاء أيقونة Windows
قبل البناء، تحتاج إلى إنشاء ملف أيقونة Windows:
1. افتح الموقع: https://convertio.co/png-ico/
2. ارفع ملف `client/public/favicon.png`
3. حوله إلى `.ico` (اختر حجم 256x256)
4. أنشئ مجلد `build` واحفظ الملف كـ `build/icon.ico`

### 4. تثبيت الحزم
افتح Command Prompt أو PowerShell في مجلد المشروع:
```bash
npm install
```

### 5. تثبيت Electron
```bash
npm install --save-dev electron electron-builder
```

### 6. إعادة بناء better-sqlite3 لـ Electron
```bash
npx electron-rebuild -f -w better-sqlite3
```

### 7. بناء التطبيق
```bash
# بناء الـ frontend و backend
npm run build

# بناء ملف exe
npx electron-builder --win
```

### أو استخدم السكريبت التلقائي
```bash
# شغّل ملف build-windows.bat بالنقر المزدوج عليه
```

### 8. موقع الملفات
بعد البناء، ستجد الملفات في مجلد `release`:
- `C2 Panel-1.0.0-x64.exe` - ملف التثبيت
- `C2 Panel-Portable-1.0.0.exe` - النسخة المحمولة (لا تحتاج تثبيت)

## قاعدة البيانات

التطبيق يستخدم **SQLite** كقاعدة بيانات محلية. لا تحتاج إلى إعداد أي شيء!

- قاعدة البيانات تُنشأ تلقائياً عند أول تشغيل
- البيانات تُحفظ في:
  - Windows: `%APPDATA%\C2Panel\c2panel.db`
  - macOS: `~/Library/Application Support/C2Panel/c2panel.db`
  - Linux: `~/.local/share/C2Panel/c2panel.db`

## تشغيل في وضع التطوير

```bash
# نافذة 1: تشغيل السيرفر
npm run dev

# نافذة 2: تشغيل Electron
set NODE_ENV=development
npx electron .
```

## هيكل الملفات المهمة
```
├── electron/
│   ├── main.js      # ملف Electron الرئيسي
│   └── preload.js   # ملف الأمان
├── build/
│   └── icon.ico     # أيقونة Windows (يجب إنشاؤها)
├── dist/            # الملفات المبنية
├── client/          # واجهة المستخدم
├── server/          # السيرفر
└── shared/          # الكود المشترك
```

## المشاكل الشائعة

### خطأ: "Cannot find module 'better-sqlite3'"
```bash
npm install better-sqlite3
npx electron-rebuild -f -w better-sqlite3
```

### خطأ: "node-gyp rebuild failed"
تأكد من تثبيت Visual Studio Build Tools:
```bash
npm install -g windows-build-tools
```

### خطأ في Electron
```bash
npm uninstall electron electron-builder
npm install --save-dev electron electron-builder
npx electron-rebuild
```

### الأيقونة لا تظهر
تأكد من وجود ملف `build/icon.ico` بالصيغة الصحيحة

### التطبيق لا يفتح
1. تأكد من بناء التطبيق: `npm run build`
2. تحقق من وجود مجلد `dist` وملف `dist/index.cjs`

## الميزات
- يعمل بدون إنترنت (قاعدة بيانات محلية)
- لا يحتاج إعداد قاعدة بيانات
- يحفظ البيانات تلقائياً

## الدعم
- [Electron Documentation](https://www.electronjs.org/docs)
- [Electron Builder](https://www.electron.build/)
- [Better-SQLite3](https://github.com/WiseLibs/better-sqlite3)
- [Drizzle ORM](https://orm.drizzle.team/)
