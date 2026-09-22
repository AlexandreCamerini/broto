#!/usr/bin/env bash
# Prova que nenhuma tela usa valor cru de estilo fora do kit. E o que torna o prototipo reutilizavel.
#   kit.sh <ios|web|flutter>
set -uo pipefail
PACK="${1:-}"; KIT=""; PAT=""; EXT=""
case "$PACK" in
  ios)     KIT='Kit/';        EXT='--include=*.swift'
           PAT='Color\(red:|Color\(hex:|Color\(#colorLiteral|\.font\(\.system\(size:|\.padding\([0-9]|\.cornerRadius\([0-9]|Font\.custom\(|\.frame\(height: [0-9]{3}';;
  web)     KIT='src/kit/';    EXT='--include=*.tsx --include=*.jsx --include=*.css'
           PAT='#[0-9a-fA-F]{3,8}\b|rgba?\([0-9]|font-size: *[0-9]|padding: *[0-9]|border-radius: *[0-9]';;
  flutter) KIT='lib/kit/';    EXT='--include=*.dart'
           PAT='Color\(0x|TextStyle\(fontSize:|EdgeInsets\.(all|symmetric|only)\([^)]*[0-9]|BorderRadius\.circular\([0-9]';;
  *) echo "uso: kit.sh <ios|web|flutter>"; exit 2;;
esac
[ -d "$KIT" ] || { echo "kit ausente em $KIT — o estado 'kit' nao foi concluido"; exit 1; }
hits=$(grep -rnE $EXT "$PAT" . 2>/dev/null \
  | grep -vE "^\./($KIT|\.git/|node_modules/|build/|\.build/|Pods/|DerivedData/)" \
  | grep -viE '(Tests?|Preview|Mock|Exemplo)' | head -20)
if [ -n "$hits" ]; then
  echo "valor cru de estilo fora do kit (use token de $KIT):"; echo "$hits"; exit 1
fi
# toda tela da jornada existe em codigo e se declara
falta=""
for t in $(python3 -c "import yaml,sys;print(' '.join(x['id'] for x in yaml.safe_load(open('.broto/journey.yaml'))['telas']))" 2>/dev/null); do
  grep -rq "broto:tela $t" . --include='*.swift' --include='*.tsx' --include='*.dart' 2>/dev/null || falta="$falta $t"
done
[ -z "$falta" ] || { echo "telas da jornada sem arquivo marcado com 'broto:tela <id>':$falta"; exit 1; }
echo "kit ok: zero valor cru fora de $KIT, todas as telas presentes"
