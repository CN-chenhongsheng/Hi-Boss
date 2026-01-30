@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo ========================================
echo 数据库优化脚本执行（QUICKSTART）
echo ========================================
echo.

:: 若 MySQL 不在 PATH，请取消下面一行并改为你的 MySQL bin 路径
:: set PATH=C:\Program Files\MySQL\MySQL Server 8.0\bin;%PATH%

where mysql >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 mysql 命令，请将 MySQL 的 bin 目录加入 PATH，或在本文件顶部设置 set PATH=...
    pause
    exit /b 1
)

echo [1/2] 备份数据库 project_management ...
mysqldump -u root -p project_management -r backup_%date:~0,4%%date:~5,2%%date:~8,2%.sql
if errorlevel 1 (
    echo [错误] 备份失败，已中止。
    pause
    exit /b 1
)
echo 备份完成: backup_%date:~0,4%%date:~5,2%%date:~8,2%.sql
echo.

echo [2/2] 执行优化脚本 01 -> 02 -> 03 -> 04 -> 验证 ...
mysql -u root -p project_management < run_all_optimization.sql
if errorlevel 1 (
    echo [错误] 执行脚本失败，请查看上方错误信息。可用 database_optimization_rollback.sql 回滚。
    pause
    exit /b 1
)

echo.
echo ========================================
echo 全部执行完成。请按 QUICKSTART.md 做「快速验证」。
echo ========================================
pause
