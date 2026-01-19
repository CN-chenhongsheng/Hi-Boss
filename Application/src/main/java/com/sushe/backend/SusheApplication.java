package com.sushe.backend;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

/**
 * 宿舍管理系统后端启动类
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@SpringBootApplication
@ComponentScan(basePackages = {"com.sushe.backend", "com.sushe.mobile"})
@MapperScan({
    "com.sushe.backend.mapper",
    "com.sushe.backend.accommodation.mapper",
    "com.sushe.backend.approval.mapper",
    "com.sushe.backend.room.mapper",
    "com.sushe.backend.organization.mapper",
    "com.sushe.backend.school.mapper",
    "com.sushe.backend.system.mapper"
})
public class SusheApplication {

    public static void main(String[] args) {
        SpringApplication.run(SusheApplication.class, args);
        System.out.println("\n=================================");
        System.out.println("  宿舍管理系统后端启动成功！");
        System.out.println("  接口文档地址: http://localhost:8080/api/doc.html");
        System.out.println("  接口地址: http://localhost:8080/api");
        System.out.println("=================================\n");
    }
}
