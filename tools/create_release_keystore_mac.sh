#!/bin/zsh
set -e

PROJECT_DIR="${1:-$HOME/Desktop/nafas_app}"
SIGNING_DIR="$HOME/.nafas-signing"
KEYSTORE="$SIGNING_DIR/nafas-release.jks"
KEY_ALIAS="nafas"

if [[ -n "$JAVA_HOME" && -x "$JAVA_HOME/bin/keytool" ]]; then
  KEYTOOL="$JAVA_HOME/bin/keytool"
else
  KEYTOOL="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool"
fi

if [[ ! -x "$KEYTOOL" ]]; then
  echo "❌ keytool پیدا نشد. Android Studio/JDK 17 را بررسی کن."
  exit 1
fi

mkdir -p "$SIGNING_DIR"
chmod 700 "$SIGNING_DIR"

if [[ -f "$KEYSTORE" ]]; then
  echo "❌ فایل کلید از قبل وجود دارد: $KEYSTORE"
  echo "برای جلوگیری از خراب‌شدن کلید انتشار، اسکریپت آن را بازنویسی نمی‌کند."
  exit 1
fi

read -s "STORE_PASSWORD?یک رمز قوی برای Keystore وارد کن: "
echo
read -s "CONFIRM_PASSWORD?رمز را دوباره وارد کن: "
echo

if [[ "$STORE_PASSWORD" != "$CONFIRM_PASSWORD" ]]; then
  echo "❌ رمزها یکسان نیستند."
  exit 1
fi

if [[ ${#STORE_PASSWORD} -lt 8 ]]; then
  echo "❌ رمز حداقل ۸ کاراکتر باشد."
  exit 1
fi

"$KEYTOOL" -genkeypair -v \
  -keystore "$KEYSTORE" \
  -storepass "$STORE_PASSWORD" \
  -keypass "$STORE_PASSWORD" \
  -alias "$KEY_ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -dname "CN=Nafas, OU=PULSE, O=PULSE"

cat > "$PROJECT_DIR/android/key.properties" <<EOF2
storePassword=$STORE_PASSWORD
keyPassword=$STORE_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=$KEYSTORE
EOF2
chmod 600 "$PROJECT_DIR/android/key.properties"

printf '%s' "$STORE_PASSWORD" > "$SIGNING_DIR/store_password.txt"
chmod 600 "$SIGNING_DIR/store_password.txt"

base64 < "$KEYSTORE" | tr -d '\n' > "$SIGNING_DIR/keystore_base64.txt"
chmod 600 "$SIGNING_DIR/keystore_base64.txt"

echo
 echo "✅ Release Keystore ساخته شد: $KEYSTORE"
echo "✅ android/key.properties فقط روی همین مک ساخته شد و داخل Git commit نمی‌شود."
echo
 echo "GitHub Secrets:"
echo "  ANDROID_KEY_ALIAS = $KEY_ALIAS"
echo "  ANDROID_KEY_PASSWORD = همان رمز"
echo "  ANDROID_STORE_PASSWORD = همان رمز"
echo "  ANDROID_KEYSTORE_BASE64 = محتوای فایل:"
echo "  $SIGNING_DIR/keystore_base64.txt"
echo
 echo "⚠️ خود فایل $KEYSTORE و رمز آن را در یک محل امن جداگانه بکاپ بگیر."
