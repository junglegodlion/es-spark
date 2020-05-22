package com.jungle.dianping.request;

public class PageQuery {

    // 查询第几页，默认从第一页开始
    private Integer page = 1;

    // 一页查询20条数据
    private Integer size = 10;

    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }
}
