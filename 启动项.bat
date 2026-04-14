@echo off
chcp 65001 > nul
title hiwin-website 项目启动器
echo ========================================
echo       hiwin-website 项目启动中...
echo ========================================
cd /d "%~dp0"
npm run dev
pause