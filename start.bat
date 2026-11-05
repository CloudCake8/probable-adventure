@echo off
rem Starts the table tennis server and a Cloudflare quick tunnel (HTTPS) so phones can send motion data.
cd /d "%~dp0"
if not exist node_modules ( echo Installing dependencies... & call npm install )
start "" http://localhost:47831
node server\index.js
pause
