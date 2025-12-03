package kim.projectdockerdb.config;


import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Controller;

import javax.sql.DataSource;

@Configuration
@MapperScan(basePackages = "kim.projectdockerdb.mapper")
public class DatabaseConfig {
//2. mybartis 연결 공장 생성
    @Bean
    public SqlSessionFactory sqlSessionFactory(DataSource dataSource)throws  Exception{
        SqlSessionFactoryBean sessionFactory = new  SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);
//        카멜케이스 설정(user_id -> userID) 끄기로 했으므로 flase
        // 카멜케이스 설정 (user_id -> userId) - 끄기로 했으므로 false
        org.apache.ibatis.session.Configuration configuration = new org.apache.ibatis.session.Configuration();
        configuration.setMapUnderscoreToCamelCase(false);
        sessionFactory.setConfiguration(configuration);

        return sessionFactory.getObject();


    }
}
