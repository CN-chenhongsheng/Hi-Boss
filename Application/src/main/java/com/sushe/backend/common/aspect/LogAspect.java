package com.sushe.backend.common.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sushe.backend.common.annotation.Log;
import com.sushe.backend.common.context.UserContext;
import com.sushe.backend.entity.SysOperLog;
import com.sushe.backend.service.SysOperLogService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.lang.reflect.Method;
import java.time.LocalDateTime;

/**
 * 操作日志切面
 * 
 * @author 陈鸿昇
 * @since 2025-01-01
 */
@Slf4j
@Aspect
@Component
public class LogAspect {

    @Autowired
    private SysOperLogService operLogService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 配置织入点
     */
    @Pointcut("@annotation(com.sushe.backend.common.annotation.Log)")
    public void logPointCut() {
    }

    /**
     * 环绕通知
     */
    @Around("logPointCut()")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        long beginTime = System.currentTimeMillis();
        SysOperLog operLog = new SysOperLog();
        Object result = null;
        Exception exception = null;

        try {
            // 执行方法
            result = point.proceed();
            return result;
        } catch (Exception e) {
            exception = e;
            throw e;
        } finally {
            // 记录日志
            try {
                recordLog(point, result, exception, operLog, beginTime);
            } catch (Exception e) {
                log.error("记录操作日志异常", e);
            }
        }
    }

    /**
     * 记录日志
     */
    private void recordLog(ProceedingJoinPoint point, Object result, Exception exception,
                          SysOperLog operLog, long beginTime) {
        try {
            // 获取注解信息
            MethodSignature signature = (MethodSignature) point.getSignature();
            Method method = signature.getMethod();
            Log logAnnotation = method.getAnnotation(Log.class);

            if (logAnnotation != null) {
                // 设置操作模块
                operLog.setTitle(logAnnotation.title());

                // 设置业务类型
                operLog.setBusinessType(logAnnotation.businessType());
            }

            // 设置方法名称
            String className = point.getTarget().getClass().getName();
            String methodName = point.getSignature().getName();
            operLog.setMethod(className + "." + methodName + "()");

            // 获取请求信息
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes != null) {
                HttpServletRequest request = attributes.getRequest();

                // 设置请求方式
                operLog.setRequestMethod(request.getMethod());

                // 设置请求URL
                operLog.setOperUrl(request.getRequestURI());

                // 设置IP地址
                String ip = getIpAddr(request);
                operLog.setOperIp(ip);

                // 设置操作地点（可以调用IP地址库获取地理位置，这里简化处理）
                operLog.setOperLocation("");

                // 设置请求参数
                if (logAnnotation != null && logAnnotation.saveRequestData()) {
                    String params = getRequestParams(point);
                    operLog.setOperParam(params);
                }

                // 设置响应参数
                if (logAnnotation != null && logAnnotation.saveResponseData() && result != null) {
                    try {
                        String jsonResult = objectMapper.writeValueAsString(result);
                        // 限制响应参数长度
                        if (jsonResult.length() > 2000) {
                            jsonResult = jsonResult.substring(0, 2000) + "...";
                        }
                        operLog.setJsonResult(jsonResult);
                    } catch (Exception e) {
                        log.warn("序列化响应参数失败", e);
                    }
                }
            }

            // 设置操作人信息
            String username = UserContext.getUsername();
            if (username != null) {
                operLog.setOperName(username);
            }
            operLog.setOperatorType(1); // 后台用户

            // 设置操作状态
            if (exception != null) {
                operLog.setStatus(1); // 异常
                String errorMsg = exception.getMessage();
                if (errorMsg != null && errorMsg.length() > 2000) {
                    errorMsg = errorMsg.substring(0, 2000);
                }
                operLog.setErrorMsg(errorMsg);
            } else {
                operLog.setStatus(0); // 正常
            }

            // 设置操作时间
            operLog.setOperTime(LocalDateTime.now());

            // 设置消耗时间
            long costTime = System.currentTimeMillis() - beginTime;
            operLog.setCostTime(costTime);

            // 异步保存日志
            operLogService.saveOperLog(operLog);
        } catch (Exception e) {
            log.error("构建操作日志失败", e);
        }
    }

    /**
     * 获取请求参数
     */
    private String getRequestParams(ProceedingJoinPoint point) {
        try {
            Object[] args = point.getArgs();
            if (args == null || args.length == 0) {
                return "";
            }

            StringBuilder params = new StringBuilder();
            for (Object arg : args) {
                // 跳过HttpServletRequest和HttpServletResponse
                if (arg instanceof jakarta.servlet.http.HttpServletRequest ||
                    arg instanceof jakarta.servlet.http.HttpServletResponse) {
                    continue;
                }

                try {
                    String jsonStr = objectMapper.writeValueAsString(arg);
                    params.append(jsonStr).append(" ");
                } catch (Exception e) {
                    params.append(arg != null ? arg.toString() : "null").append(" ");
                }
            }

            String result = params.toString().trim();
            // 限制参数长度
            if (result.length() > 2000) {
                result = result.substring(0, 2000) + "...";
            }
            return result;
        } catch (Exception e) {
            log.warn("获取请求参数失败", e);
            return "";
        }
    }

    /**
     * 获取客户端IP地址
     */
    private String getIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 处理多个IP的情况（取第一个）
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}

