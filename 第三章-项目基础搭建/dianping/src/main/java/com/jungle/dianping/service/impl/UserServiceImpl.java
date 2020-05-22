package com.jungle.dianping.service.impl;

import com.jungle.dianping.dal.UserModelMapper;
import com.jungle.dianping.model.UserModel;
import com.jungle.dianping.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by hzllb on 2019/7/7.
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserModelMapper userModelMapper;


    @Override
    public UserModel getUser(Integer id) {
        return userModelMapper.selectByPrimaryKey(id);
    }

}
