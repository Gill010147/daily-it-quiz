# Daily IT Quiz
 매일매일 IT 문제풀이로 CS 지식 완벽 복습하기!

---

## 🖥️ 프로젝트 개요
우리FIS 아카데미에서 인프라 엔지니어를 꿈꾸는 두 명이 리눅스(Ubuntu)를 이용하여 만들어낸 CS 역량테스트를 대비하기 위한 프로젝트입니다.
### 👥 구성원
<table align="center">
  <tr>
    <td align="center">
       <a href="https://github.com/GodNowoon">
        <img src="https://github.com/GodNowoon.png" width="100px;" alt="godnowoon"/><br />
        <sub><b>이노운</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Gill010147">
        <img src="https://github.com/Gill010147.png" width="100px;" alt="Gill010147"/><br />
        <sub><b>황병길</b></sub>
      </a>
    </td>
  </tr>
</table>

## 📝 프로젝트 주제
면접 대비의 필요성을 느꼈고, 이제까지 공부해온 지식을 복습하기 위해 제작한 CS 문제은행 서비스입니다.

---

### ⚙ 사용 기술 및 도구 (Tech Stack & Tools)

> **IDE / OS**: VS Code / Ubuntu 22.04 <br>
> **가상 환경**: VirtualBox (Linux VM 구동) <br>
> **버전 관리**: Git / GitHub <br>
> **협업**: Notion <br>

---

### 📝 프로젝트 구조
```
Daily-IT-Quiz/
├─ quiz.sh # 메인 쉘스크립트
├─ bank.tsv # 문제 파일 (TSV)
├─ quiz_log.tsv # 문제 풀이 관련 로그
└─ README.md
```

## 📂 프로젝트 설명 (Project Description)

Daily IT Quiz는 **TSV 기반 문제은행과 쉘스크립트**를 활용하여 매일 랜덤한 문제들을 출력하고, 정답 여부를 체크하며 풀이 기록을 보관하는 시스템입니다. 학생 및 취업 준비생이 **CS 지식을 반복 학습**하는 데 적합하며, 특히 이번 하반기 공채 기술면접에 있어서 CS 지식을 복습하고 취약점을 확인할 때 바로 이용할 수 있습니다.<br>
하루에 3번, 문제은행(bank.tsv)에 있는 문제들을 5문제씩 제시합니다. 객관식 문제 출력/정답 체크 기능을 구현하였고 문제를 푼 기록들은 로그(quiz_log.tsv)로 저장됩니다. <br>
수집한 로그를 기반으로 awk를 이용해서 주제별 정답률 확인이 가능합니다. <br>

---

## 📷 스크린샷

> 프로젝트 주요 화면을 캡처해서 아래에 첨부

![screenshot](./itquiz.png)

---

### ✅ 구현 기능 (Implemented Features)

- [x] 정해진 시간마다 랜덤한 문제 자동 출력(Cron 활용)
- [x] TSV 정보 받아오기 및 출력
- [x] TSV 데이터 처리 (AWK 활용)

---

### 😎 트러블슈팅 (Troubleshooting)

| 문제 상황 | 원인 | 해결 방법 |
|-----------|------|-----------|
| 문제 파일이 정상적으로 읽히지 않음 | TSV 경로가 잘못 지정됨 + TSV를 이용한 문법이 CSV와 다름 | 파일 경로를 스크립트와 동일하게 설정했고, 차이를 인지하였다 |
| 정답 비교 시 에러 발생 | 쉘에서 변수 값이 비어 있었음 | TSV 필드 구분자(`\t`) 확인 및 awk 사용 시 따옴표 제거 |

---

## 🧠 회고

- **노운**: 
- **병길**: 

---


<br>


## 😍 향후 확장 가능성

-  웹서버와 연동하여 웹/모바일 환경에서의 문제풀이 서비스 구축  
- 문제 카테고리별 통계 및 맞춤형 문제 추천 기능 추가  
- 문제 은행 확장 및 난이도별 학습 관리 기능 추가
