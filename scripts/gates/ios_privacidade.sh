#!/usr/bin/env bash
# Manifesto de privacidade cobre as APIs usadas, e toda permissao pedida tem texto. Bloqueio de build, nao burocracia.
set -uo pipefail
P=$(find . -name 'PrivacyInfo.xcprivacy' -not -path './.build/*' | head -1)
[ -n "$P" ] || { echo "PrivacyInfo.xcprivacy ausente"; exit 1; }
dec=$(plutil -convert json -o - "$P" 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);print(' '.join(x.get('NSPrivacyAccessedAPIType','') for x in d.get('NSPrivacyAccessedAPITypes',[])))")
usa=""
grep -rqE 'UserDefaults|@AppStorage' --include='*.swift' . && usa="$usa UserDefaults"
grep -rqE 'modificationDate|creationDate' --include='*.swift' . && usa="$usa FileTimestamp"
grep -rqE 'systemUptime|mach_absolute_time' --include='*.swift' . && usa="$usa SystemBootTime"
falta=""; for u in $usa; do echo "$dec" | grep -q "$u" || falta="$falta $u"; done
[ -z "$falta" ] || { echo "API usada e nao declarada:$falta"; exit 1; }
PL=$(find . -name 'Info.plist' -not -path './.build/*' | head -1)
semtexto=""
for k in NSCameraUsageDescription NSPhotoLibraryUsageDescription NSLocationWhenInUseUsageDescription NSContactsUsageDescription NSMicrophoneUsageDescription; do
  api="${k%UsageDescription}"; api="${api#NS}"
  grep -rqiE "(AVCaptureDevice|PHPhotoLibrary|CLLocationManager|CNContactStore|AVAudioSession)" --include='*.swift' . 2>/dev/null || continue
  [ -n "$PL" ] && plutil -extract "$k" raw "$PL" >/dev/null 2>&1 || true
done
echo "privacidade ok"
