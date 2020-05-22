package com.jungle.dianping.service;

import com.jungle.dianping.common.BusinessException;
import com.jungle.dianping.model.UserModel;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;

/**
 * Created by hzllb on 2019/7/7.
 */
public interface UserService {

    UserModel getUser(Integer id);

    UserModel register(UserModel register) throws BusinessException, UnsupportedEncodingException, NoSuchAlgorithmException;

    UserModel login(String telphone,String password) throws UnsupportedEncodingException, NoSuchAlgorithmException, BusinessException;

    Integer countAllUser();
}
