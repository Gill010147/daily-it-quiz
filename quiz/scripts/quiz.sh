#!/usr/bin/env bash
set -euo pipefail

if [ ! -t 0 ]; then
  echo "[$(date --iso-8601=seconds)] no TTY; skipping interactive quiz" >> "$HOME/quiz/logs/quiz.cron.log"
  exit 0
fi


ROOT="$HOME/quiz"
BANK="$ROOT/questions/bank.tsv"
ANS="$ROOT/data/answers.log"
SESS="$ROOT/data/sessions.log"
mkdir -p "$ROOT/data" "$ROOT/reports" "$ROOT/logs"

session_id="$(/usr/bin/date +%F-%H%M)"
ts="$(/usr/bin/date --iso-8601=seconds)"
start_ts="$(( $(/usr/bin/date +%s) ))"

# 문제 5개 샘플링
mapfile -t lines < <(/usr/bin/shuf -n 5 "$BANK")

correct=0
idx=0
for line in "${lines[@]}"; do
  idx=$((idx+1))
  IFS=$'\t' read -r qid category question choices answer <<<"$line"

  echo ""
  echo "[$idx/5] ($category) Q$qid: $question"
  echo "$choices"
  read -rp "정답 입력 (A/B/C/D): " user
  user="$(echo "$user" | /usr/bin/tr '[:lower:]' '[:upper:]' | /usr/bin/tr -d ' ')"

  if [[ "$user" == "$answer" ]]; then
    is_correct=true
    correct=$((correct+1))
    echo "✅ 정답!"
  else
    is_correct=false
    echo "❌ 오답! 정답은 $answer"
  fi

  printf '{"ts":"%s","session_id":"%s","qid":%d,"category":"%s","user":"%s","correct":%s}\n' "$ts" "$session_id" "$qid" "$category" "$user" "$is_correct" >> "$ANS"
done

pass=false
if (( correct >= 3 )); then pass=true; fi
dur="$(( $(/usr/bin/date +%s) - start_ts ))"

printf '{"ts":"%s","session_id":"%s","count":5,"correct":%d,"pass":%s,"duration_sec":%d}\n' "$ts" "$session_id" "$correct" "$pass" "$dur" >> "$SESS"

echo ""
echo "세션 결과: $correct/5 정답, 통과: $pass, 소요: ${dur}s"
echo "로그 저장: $SESS, $ANS"chmod +x ~/quiz/scripts/quiz.sh