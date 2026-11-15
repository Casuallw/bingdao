#!/bin/bash
# 冰岛 APK 正版鉴定脚本
# 用法：bash verify_apk.sh <apk文件路径>
# 判断该 APK 是否为作者签名的官方版本。

EXPECTED="8855b99976db7cf8dfb97a95bbd19a74a594cde5cce449275b4423eded6d4fc3"
EXPECTED_PRETTY="88:55:B9:99:76:DB:7C:F8:DF:B9:7A:95:BB:D1:9A:74:A5:94:CD:E5:CC:E4:49:27:5B:44:23:ED:ED:6D:4F:C3"

if [ -z "$1" ]; then
  echo "用法: bash verify_apk.sh <apk文件路径>"
  exit 2
fi
if [ ! -f "$1" ]; then
  echo "找不到文件: $1"
  exit 2
fi

APKSIGNER=$(command -v apksigner 2>/dev/null)
if [ -z "$APKSIGNER" ]; then
  APKSIGNER=$(ls -d /root/sdk/build-tools/*/apksigner 2>/dev/null | head -1)
fi
if [ -z "$APKSIGNER" ]; then
  echo "未找到 apksigner，请先安装 Android build-tools"
  exit 2
fi

echo "正在校验: $1"
OUT=$("$APKSIGNER" verify --print-certs "$1" 2>&1)
RC=$?

if [ $RC -ne 0 ]; then
  echo ""
  echo "❌ 签名校验失败（APK 可能被篡改或未签名）"
  echo "$OUT" | head -5
  exit 1
fi

ACTUAL=$(echo "$OUT" | grep -i "SHA-256 digest" | head -1 | sed 's/.*digest: //' | tr -d ' ')
ACTUAL_PRETTY=$(echo "$OUT" | grep -i "SHA-256" | head -1 | sed 's/.*SHA-256[^:]*: *//')

echo ""
if [ "$ACTUAL" = "$EXPECTED" ]; then
  echo "✅ 正版：签名与作者证书一致"
  echo "   指纹: $ACTUAL_PRETTY"
  exit 0
else
  echo "❌ 非正版：签名与作者证书不一致"
  echo "   实际: $ACTUAL_PRETTY"
  echo "   应为: $EXPECTED_PRETTY"
  echo ""
  echo "这个 APK 被他人重新打包过，可能被植入广告或恶意代码。"
  echo "请从官方地址重新下载: https://gitee.com/casual-wear/bingdao"
  exit 1
fi
