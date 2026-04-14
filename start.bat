@echo off

REM 一键启动HIWIN网站Vue项目
REM 作者: Trae AI
REM 日期: 2026-04-13

echo ===========================
echo HIWIN 网站项目启动脚本
echo ===========================

echo 正在检查Node.js环境...
echo.

REM 检查Node.js是否安装
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 未检测到Node.js
    echo 请先安装Node.js: https://nodejs.org/
    pause
    exit /b 1
)

echo ✓ Node.js已安装

REM 检查npm是否可用
npm -v >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 未检测到npm
    echo 请重新安装Node.js并确保勾选"Add to PATH"
    pause
    exit /b 1
)

echo ✓ npm已安装

echo.
echo 正在安装项目依赖...
echo.
npm install

if %errorlevel% neq 0 (
    echo 错误: 依赖安装失败
    pause
    exit /b 1
)

echo ✓ 依赖安装成功

echo.
echo 正在启动开发服务器...
echo 启动后请在浏览器中访问: http://localhost:3000
echo ===========================
echo.

npm run dev

pause
