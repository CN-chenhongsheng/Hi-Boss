@echo off
chcp 65001 >nul
echo ========================================
echo 菜单路径规范化 - 目录重命名脚本
echo ========================================
echo.

echo [提示] 此脚本将重命名以下目录：
echo   manager/src/views/repair/list  →  manager/src/views/repair/manage
echo.

echo [警告] 请确保：
echo   1. 已关闭 VS Code/Cursor 中相关文件
echo   2. 没有其他程序占用这些文件
echo   3. 已备份重要数据
echo.

pause

cd /d "%~dp0.."

echo.
echo [执行] 正在重命名目录...
echo.

:: 检查源目录是否存在
if not exist "manager\src\views\repair\list" (
    echo [错误] 源目录不存在: manager\src\views\repair\list
    echo 可能已经重命名过了，请检查
    pause
    exit /b 1
)

:: 检查目标目录是否已存在
if exist "manager\src\views\repair\manage" (
    echo [错误] 目标目录已存在: manager\src\views\repair\manage
    echo 请手动删除或重命名后再试
    pause
    exit /b 1
)

:: 尝试使用 Git 重命名
git mv manager\src\views\repair\list manager\src\views\repair\manage >nul 2>&1
if %errorlevel% equ 0 (
    echo [成功] 使用 Git 重命名成功
    goto success
)

:: Git 失败，尝试普通重命名
echo [提示] Git 重命名失败，尝试普通重命名...
move "manager\src\views\repair\list" "manager\src\views\repair\manage" >nul 2>&1
if %errorlevel% equ 0 (
    echo [成功] 目录重命名成功
    goto success
)

:: 重命名失败
echo [错误] 重命名失败，可能文件被占用
echo.
echo 请手动执行以下操作：
echo   1. 关闭所有相关文件
echo   2. 在文件管理器中重命名目录：
echo      manager\src\views\repair\list  →  manage
pause
exit /b 1

:success
echo.
echo ========================================
echo [完成] 目录重命名成功！
echo ========================================
echo.
echo 接下来请执行：
echo   1. 执行数据库更新脚本：
echo      mysql -u root -p project_management ^< Application\sql\fix_menu_path_naming.sql
echo.
echo   2. 重启前端开发服务器：
echo      cd manager
echo      pnpm dev
echo.
echo   3. 重新登录后台管理系统测试
echo.

pause
