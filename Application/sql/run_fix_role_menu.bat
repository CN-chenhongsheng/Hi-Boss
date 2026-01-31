@echo off
chcp 65001 >nul
echo ============================================================
echo 修复 sys_role_menu 表重复数据问题
echo ============================================================
echo.
echo 此脚本将：
echo 1. 查看当前问题
echo 2. 备份现有数据
echo 3. 清理重复的软删除记录
echo 4. 修复唯一索引
echo 5. 验证修复结果
echo.
echo 警告：执行前请确保已备份数据库！
echo.
pause

echo.
echo 正在执行修复脚本...
echo.

mysql -u root -p project_management < fix_role_menu_duplicates.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================================
    echo 修复成功！
    echo ============================================================
    echo.
    echo 已完成：
    echo ✓ 清理重复的软删除记录
    echo ✓ 修复唯一索引（包含 deleted 字段）
    echo ✓ 创建备份表 sys_role_menu_backup_20260131
    echo.
    echo 下一步：
    echo 1. 重启后端 Spring Boot 服务
    echo 2. 重新测试"分配权限"功能
    echo 3. 如果仍有问题，检查日志输出
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
    echo 4. 查看上方的错误信息
    echo.
)

pause
