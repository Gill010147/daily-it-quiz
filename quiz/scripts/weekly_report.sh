#!/usr/bin/env bash
set -euo pipefail

ROOT="$HOME/quiz"
ANS="$ROOT/data/answers.log"
SESS="$ROOT/data/sessions.log"
week="$((/usr/bin/date +%G-W%V))" # subshell 예방용 괄호 제거
week="$(/usr/bin/date +%G-W%V)"
OUT="$ROOT/reports/weekly-$week.md"
mkdir -p "$ROOT/reports"

since="$(/usr/bin/date -d '7 days ago' --iso-8601=seconds)"

{
echo "# 주간 퀴즈 리포트 ($week)"
echo ""

total=$(/usr/bin/jq -r --arg s "$since" 'select(.ts >= $s)' "$SESS" 2>/dev/null | /usr/bin/wc -l || true)
pass=$(/usr/bin/jq -r --arg s "$since" 'select(.ts >= $s and .pass==true)' "$SESS" 2>/dev/null | /usr/bin/wc -l || true)
if (( total > 0 )); then
pass_rate=$(awk -v p="$pass" -v t="$total" 'BEGIN{printf("%.1f",(p/t)*100)}')
else
pass_rate="0.0"
fi
avg_correct=$(/usr/bin/jq -r --arg s "$since" 'select(.ts >= $s) | .correct' "$SESS" 2>/dev/null | awk '{s+=$1;n++} END{if(n>0) printf("%.2f", s/n); else print "0.00"}')
avg_dur=$(/usr/bin/jq -r --arg s "$since" 'select(.ts >= $s) | .duration_sec' "$SESS" 2>/dev/null | awk '{s+=$1;n++} END{if(n>0) printf("%.1f", s/n); else print "0.0"}')

echo "- 최근 7일 세션: $total, 통과: $pass (${pass_rate}%), 평균 점수: $avg_correct, 평균 소요: ${avg_dur}s"
echo ""
echo "## 카테고리 정답률(최근 7일)"
echo ""
echo "| 카테고리 | 정답수 | 총문항 | 정답률 |"
echo "|---|---:|---:|---:|"

/usr/bin/jq -r --arg s "$since" 'select(.ts >= $s) | .category+" "+(.correct|tostring)' "$ANS" 2>/dev/null
| awk '{tot[$1]++; if($2=="true") cor[$1]++} END{for(k in tot){r=(cor[k]/tot[k])*100; printf("| %s | %d | %d | %.1f%% |\n", k, cor[k]+0, tot[k], r)}}'
| sort
} > "$OUT"

echo "생성: $OUT"
