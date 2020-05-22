package com.jungle.dianping.service;

import com.jungle.dianping.common.BusinessException;
import com.jungle.dianping.model.ShopModel;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface ShopService {
    ShopModel create(ShopModel shopModel) throws BusinessException;
    ShopModel get(Integer id);
    List<ShopModel> selectAll();
    List<ShopModel> recommend(BigDecimal longitude,BigDecimal latitude);

    Integer countAllShop();

    // 标签过滤
    List<Map<String,Object>> searchGroupByTags(String keyword,Integer categoryId,String tags);

    // 搜索功能
    List<ShopModel> search(BigDecimal longitude,BigDecimal latitude,
                           String keyword,Integer orderby,Integer categoryId,String tags);

    Map<String,Object> searchES(BigDecimal longitude,BigDecimal latitude,
                              String keyword,Integer orderby,Integer categoryId,String tags) throws IOException;

}
