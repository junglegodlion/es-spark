package com.jungle.dianping.service;

import com.jungle.dianping.common.BusinessException;
import com.jungle.dianping.model.SellerModel;

import java.util.List;

public interface SellerService {

    SellerModel create(SellerModel sellerModel);
    SellerModel get(Integer id);
    List<SellerModel> selectAll();
    SellerModel changeStatus(Integer id, Integer disabledFlag) throws BusinessException;

}
