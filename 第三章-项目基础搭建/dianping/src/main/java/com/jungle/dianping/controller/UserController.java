package com.jungle.dianping.controller;


import com.jungle.dianping.common.BusinessException;
import com.jungle.dianping.common.CommonError;
import com.jungle.dianping.common.CommonRes;
import com.jungle.dianping.common.EmBusinessError;
import com.jungle.dianping.model.UserModel;
import com.jungle.dianping.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller("/user")
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/test")
    @ResponseBody
    public String test() {
        return "test";
    }

    @RequestMapping("/get")
    @ResponseBody
    public CommonRes getUser(@RequestParam(name="id") Integer id) throws BusinessException {
        UserModel user = userService.getUser(id);
        if (user!=null) {
            return CommonRes.create(user);
        } else  {
            // return CommonRes.create(new CommonError(EmBusinessError.UNKNOWN_ERROR),"fail");
            throw new BusinessException(EmBusinessError.BIND_EXCEPTION_ERROR);
        }

    }

    @RequestMapping("/index")
    public ModelAndView index(){
        String userName = "imooc";
        ModelAndView modelAndView = new ModelAndView("/index.html");
        modelAndView.addObject("name",userName);
        return modelAndView;
    }

}
