=== הוראות ===
1. צור ריפו חדש בגיט האב (Public!) והעלה את heart.ps1 ו-index.html
2. החלף USER ו-REPO בפקודות למטה

--- גרסת CMD (לב בתוך החלון) ---
powershell -NoP -EP Bypass -c "irm https://raw.githubusercontent.com/USER/REPO/main/heart.ps1 | iex"

--- גרסת דפדפן (לב עם חלקיקים) ---
1. בריפו: Settings > Pages > Branch: main > Save
2. הפקודה:
start https://USER.github.io/REPO/

עצירה בגרסת CMD: Ctrl+C
