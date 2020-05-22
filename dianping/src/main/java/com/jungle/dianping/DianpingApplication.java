package com.jungle.dianping;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication(scanBasePackages = {"com.jungle.dianping"})
@MapperScan("com.jungle.dianping.dal")
// 可以解析一些aop的配置
@EnableAspectJAutoProxy(proxyTargetClass = true)
@EnableScheduling // 开启Scheduling
public class DianpingApplication {

    public static void main(String[] args) {
        SpringApplication.run(DianpingApplication.class, args);
    }

}
