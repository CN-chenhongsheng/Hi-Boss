@echo off
chcp 65001 >nul
echo ============================================================
echo 修复软删除唯一索引脚本
echo ============================================================
echo.
echo 此脚本将修复数据库中所有唯一索引，使其支持软删除
echo.
echo 警告：执行前请确保已备份数据库！
echo.
pause

echo.
echo 正在执行修复脚本...
echo.

mysql -u root -p project_management < fix_unique_index_with_deleted.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================================
    echo 修复成功！
    echo ============================================================
    echo.
    echo 已修复的表包括：
    echo - sys_role_menu （角色菜单关联）
    echo - sys_user_role （用户角色关联）
    echo - sys_user_menu （用户菜单关联）
    echo - 以及其他所有相关表
    echo.
    echo 请重新启动后端服务，然后重试分配权限操作
    echo.
) else (
    echo.
    echo ============================================================
    echo 修复失败！错误代码: %ERRORLEVEL%
    echo ============================================================
    echo.
    echo 请检查：
    echo 1. MySQL 服务是否运行
    echo 2. 数据库连接信息是否正确
    echo 3. 是否有足够的权限
    echo.
)

pause
