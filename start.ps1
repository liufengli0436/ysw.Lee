# 一键启动HIWIN网站Vue项目
# 作者: Trae AI
# 日期: 2026-04-13

Write-Host "===========================" -ForegroundColor Green
Write-Host "HIWIN 网站项目启动脚本" -ForegroundColor Green
Write-Host "===========================" -ForegroundColor Green

# 检查Node.js是否安装
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "✓ Node.js已安装" -ForegroundColor Green
} else {
    Write-Host "错误: 未检测到Node.js" -ForegroundColor Red
    Write-Host "请先安装Node.js: https://nodejs.org/" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}

# 检查npm是否可用
if (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Host "✓ npm已安装" -ForegroundColor Green
} else {
    Write-Host "错误: 未检测到npm" -ForegroundColor Red
    Write-Host "请重新安装Node.js并确保勾选'Add to PATH'" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}

# 安装依赖
Write-Host "正在安装项目依赖..." -ForegroundColor Cyan
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: 依赖安装失败" -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}

Write-Host "✓ 依赖安装成功" -ForegroundColor Green

# 启动开发服务器
Write-Host "正在启动开发服务器..." -ForegroundColor Cyan
Write-Host "启动后请在浏览器中访问: http://localhost:3000" -ForegroundColor Yellow
Write-Host "===========================" -ForegroundColor Green

npm run dev

Read-Host "按回车键退出"
