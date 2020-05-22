package com.jungle.dianping.common;

import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.NoHandlerFoundException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by hzllb on 2019/7/9.
 */
// 这个注解表示所有执行的controller都会被这个页面所包含
@ControllerAdvice
public class GlobalExceptionHandler {

    // 处理规则
    // 抛出的异常或继承Exception.class都会来到这里被处理
    // 这里返回的是CommonRes
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public CommonRes doError(HttpServletRequest servletRequest, HttpServletResponse httpServletResponse,Exception ex){
        if(ex instanceof BusinessException){
            return CommonRes.create(((BusinessException)ex).getCommonError(),"fail");
        }else if(ex instanceof NoHandlerFoundException){ // 处理404异常
            CommonError commonError = new CommonError(EmBusinessError.NO_HANDLER_FOUND);
            return CommonRes.create(commonError,"fail");
        }else if(ex instanceof ServletRequestBindingException){ // 请求参数错误
            CommonError commonError = new CommonError(EmBusinessError.BIND_EXCEPTION_ERROR);
            return CommonRes.create(commonError,"fail");
        } else {
            CommonError commonError = new CommonError(EmBusinessError.UNKNOWN_ERROR);
            return CommonRes.create(commonError,"fail");
        }

    }
}
