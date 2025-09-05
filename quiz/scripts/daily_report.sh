#!/usr/bin/env bash
set -euo pipefail

ROOT="$HOME/quiz"
ANS="$ROOT/data/answers.log"
SESS="$ROOT/data/sessions.log"
OUT="$ROOT/reports/$(/usr/bin/date +%F).md"
mkdir -p "$ROOT/reports"

today="$(/usr/bin/date +%F)"

{
  echo "# 일일 퀴즈 리포트 ($today)"
  echo ""

  total=$(/usr/bin/jq -r --arg d "$today" 'select(.ts|startswith($d))' "$SESS" 2>/dev/null | /usr/bin/wc -l || true)
  pass=$(/usr/bin/jq -r --arg d "$today" 'select(.ts|startswith($d) and (.pass==true or .pass=="true"))' "$SESS" | /usr/bin/wc -l || true)

  if (( total > 0 )); then
    pass_rate=$(awk -v p="$pass" -v t="$total" 'BEGIN{printf("%.1f",(p/t)*100)}')
  else
    pass_rate="0.0"
  fi

  avg_correct=$(/usr/bin/jq -r --arg d "$today" 'select(.ts|startswith($d)) | .correct' "$SESS" 2>/dev/null | awk '{s+=$1;n++} END{if(n>0) printf("%.2f", s/n); else print "0.00"}')
  avg_dur=$(/usr/bin/jq -r --arg d "$today" 'select(.ts|startswith($d)) | .duration_sec' "$SESS" 2>/dev/null | awk '{s+=$1;n++} END{if(n>0) printf("%.1f", s/n); else print "0.0"}')

  echo "- 총 세션: $total, 통과: $pass (${pass_rate}%)"
  echo "- 평균 점수: $avg_correct, 평균 소요: ${avg_dur}s"
  echo ""
  echo "## 카테고리 정답률(당일)"
  echo ""
  echo "| 카테고리 | 정답수 | 총문항 | 정답률 |"
  echo "|---|---:|---:|---:|"

  /usr/bin/jq -r --arg d "$today" 'select(.ts|startswith($d)) | .category+" "+(.correct|tostring)' "$ANS" 2>/dev/null | \
  awk '{tot[$1]++; if($2=="true") cor[$1]++} END{for(k in tot){r=(cor[k]/tot[k])*100; printf("| %s | %d | %d | %.1f%% |\n", k, cor[k]+0, tot[k], r)}}' | \
  sort
} > "$OUT"

echo "생성: $OUT"
