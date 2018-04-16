package com.cafe24.ourplanners.aop;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;

@Aspect
public class LoggerAspect {

	protected Log log = LogFactory.getLog(LoggerAspect.class);
    static String name = "";
    static String type = "";
     
    @Around("execution(* com.cafe24.ourplanners.*(..)..controller.*Controller.*(..)) or execution(* com.cafe24.ourplanners.*(..)..service.*Impl.*(..)) or execution(* com.cafe24.ourplanners.*(..)..persistence.*DAOImpl.*(..))")
    public Object logPrint(ProceedingJoinPoint joinPoint) throws Throwable {
        type = joinPoint.getSignature().getDeclaringTypeName();
         
        if (type.indexOf("Controller") > -1) {
            name = "Controller  \t:  ";
        }
        else if (type.indexOf("Service") > -1) {
            name = "ServiceImpl  \t:  ";
        }
        else if (type.indexOf("DAO") > -1) {
            name = "DAOImpl  \t:  ";
        }
        log.debug(name + type + "." + joinPoint.getSignature().getName() + "()");
        return joinPoint.proceed();
    }
}
