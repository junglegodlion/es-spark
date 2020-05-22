索引建立：
PUT /movie
{
   "settings" : {
      "number_of_shards" : 1,
      "number_of_replicas" : 1
   },
   "mappings": {
     "properties": {
       "title":{"type":"text","analyzer": "english"},
       "tagline":{"type":"text","analyzer": "english"},
       "release_date":{"type":"date",        "format": "8yyyy/MM/dd||yyyy/M/dd||yyyy/MM/d||yyyy/M/d"},
       "popularity":{"type":"double"},
       "cast":{
         "type":"object",
         "properties":{
           "character":{"type":"text","analyzer":"standard"},
           "name":{"type":"text","analyzer":"standard"}
         }
       },
       "overview":{"type":"text","analyzer": "english"}
     }
   }
}

1. match查询，按照字段上定义的分词分析后去索引内查询
GET /movie/_search
{
  "query":{
    "match":{"title":"steve"}
  }
}

2. term查询，不进行词的分析，直接去索引查询，及搜索关键词和索引内词的精确匹配
GET /movie/_search
{
  "query":{
    "match":{"title":"steve zissou"}
  }
}

GET /movie/_search
{
  "query":{
    "term":{"title":"steve zissou"}
  }
}
的结果区别

3.match分词后的and和or
GET /movie/_search
{
  "query":{
    "match":{"title":"basketball with cartoom aliens"},
  }
}
使用的是or
GET /movie/_search
{
  "query":{
    "match": {
      "title": {
        "query": "basketball with cartoom aliens",
        "operator": "and" 
      }
    }
  } 
}
使用and

4.最小词项匹配
GET /movie/_search
{
  "query":{
    "match": {
      "title": {
        "query": "basketball with cartoom aliens",
        "operator": "or" ,
        "minimum_should_match": 2
      }
    }
  }
}

5.短语查询
GET /movie/_search
{
  "query":{
    "match_phrase":{"title":"steve zissou"}
  }
}
短语前缀查询
GET /movie/_search
{
  "query":{
    "match_phrase_prefix":{"title":"steve zis"}
  }
}

6.多字段查询
GET /movie/_search
{
  "query":{
    "multi_match":{
      "query":"basketball with cartoom aliens",
      "field":["title","overview"]
    }
  }
}


操作不管是字符与还是或，按照逻辑关系命中后相加得分

GET /movie/_search
{
  "explain": true, 
  "query":{
    "match":{"title":"steve"}
  }
}
查看数值，tfidf多少分，tfnorm归一化后多少分

多字段查询索引内有query分词后的结果，因为title比overview命中更重要，因此需要加权重
GET /movie/_search
{
  "query":{
    "multi_match":{
      "query":"basketball with cartoom aliens",
      "fields":["title^10","overview"],
      "tie_break":0.3
    }
  }
}


继续深入查询：
1.	Bool查询

must：必须都是true
must not： 必须都是false
should：其中有一个为true即可，但true的越多得分越高
GET /movie/_search
{
  "query":{
    "bool": { 
      "should": [
        { "match": { "title":"basketball with cartoom aliens"}}, 
        { "match": { "overview":"basketball with cartoom aliens"}}  
      ]
    }
  }
}


2.不同的multi_query的type
和multi_match得分不一样
因为multi_match有很多种type
best_fields:默认，取得分最高的作为对应的分数，最匹配模式,等同于dismax模式
GET /movie/_search
{
  "query":{
    "dis_max": { 
      "queries": [
        { "match": { "title":"basketball with cartoom aliens"}}, 
        { "match": { "overview":"basketball with cartoom aliens"}}  
      ]
    }
  }
}

然后使用explan看下 ((title:steve title:job) | (overview:steve overview:job))，打分规则
GET /movie/_validate/query?explain
{
  //"explain": true, 
  "query":{
    "multi_match":{
      "query":"steve job",
      "fields":["title","overview"],
      "operator": "or",
      "type":"best_fields"
    }
  }
}
以字段为单位分别计算分词的分数，然后取最好的一个,适用于最优字段匹配。


将其他因素以0.3的倍数考虑进去
GET /movie/_search
{
  "query":{
    "dis_max": { 
      "queries": [
        { "match": { "title":"basketball with cartoom aliens"}}, 
        { "match": { "overview":"basketball with cartoom aliens"}}  
      ],
      "tie_breaker": 0.3
    }
  }
}




most_fields:取命中的分值相加作为分数，同should match模式，加权共同影响模式

然后使用explain看下 ((title:steve title:job) | (overview:steve overview:job))~1.0，打分规则
GET /movie/_validate/query?explain
{
  //"explain": true, 
  "query":{
    "multi_match":{
      "query":"steve job",
      "fields":["title","overview"],
      "operator": "or",
      "type":"most_fields"
    }
  }
}
以字段为单位分别计算分词的分数，然后加在一起，适用于都有影响的匹配



cross_fields:以分词为单位计算栏位总分
然后使用explain看下 blended(terms:[title:steve, overview:steve]) blended(terms:[title:job, overview:job])，打分规则
GET /movie/_validate/query?explain
{
  //"explain": true, 
  "query":{
    "multi_match":{
      "query":"steve job",
      "fields":["title","overview"],
      "operator": "or",
      "type":"most_fields"
    }
  }
}
以词为单位，分别用词去不同的字段内取内容，拿高的分数后与其他词的分数相加，适用于词导向的匹配



GET /forum/article/_search
{
  "query": {
    "multi_match": {
      "query": "Peter Smith",
      "type": "cross_fields", 
      "operator": "or",
      "fields": ["author_first_name", "author_last_name"]
    }
  }
}
//要求Peter必须在author_first_name或author_last_name中出现
//要求Smith必须在author_first_name或author_last_name中出现

//原来most_fiels，可能像Smith //Williams也可能会出现，因为most_fields要求只是任何一个field匹配了就可以，匹配的field越多，分数越高

GET /movie/_search
{
  "explain": true, 
  "query":{
    "multi_match":{
      "query":"steve job",
      "fields":["title","overview"],
      "operator": "or",
      "type":"cross_fields"
    }
  }
}
看一下不同的评分规则



3.query string
方便的利用AND(+) OR(|) NOT(-)
GET /movie/_search
{
  "query":{
    "query_string":{
      "fields":["title"],
      "query":"steve AND jobs"
      
    }
  }
}



过滤查询

filter过滤查询

单条件过滤
GET /movie/_search
{
  "query":{
    "bool":{
      "filter":{
          "term":{"title":"steve"}
      }
    }
  }
}
多条件过滤
GET /movie/_search
{
  "query":{
    "bool":{
      "filter":[
        {"term":{"title":"steve"}},
        {"term":{"cast.name":"gaspard"}},
        {"range": { "release_date": { "lte": "2015/01/01" }}},
        {"range": { "popularity": { "gte": "25" }}}
        ]
    }
  },
  "sort":[
    {"popularity":{"order":"desc"}}
  ]
}

带match打分的的filter
GET /movie/_search
{
  "query":{
    "bool":{
      "must": [
        { "match": { "title":   "Search"        }}, 
        { "match": { "tagline": "Elasticsearch" }}  
      ],
      "filter":[
        {"term":{"title":"steve"}},
        {"term":{"cast.name":"gaspard"}},
        {"range": { "release_date": { "lte": "2015/01/01" }}},
        {"range": { "popularity": { "gte": "25" }}}
        ]
    }
  }
}

返回0结果

GET /movie/_search
{
  "query":{
    "bool":{
      "should": [
        { "match": { "title":   "Search"        }}, 
        { "match": { "tagline": "Elasticsearch" }}  
      ],
      "filter":[
        {"term":{"title":"steve"}},
        {"term":{"cast.name":"gaspard"}},
        {"range": { "release_date": { "lte": "2015/01/01" }}},
        {"range": { "popularity": { "gte": "25" }}}
        ]
    }
  }
}

有结果，但是返回score为0，因为bool中若有filter的话，即便should都不满足，只是返回为0分而已
修改为
GET /movie/_search
{
  "query":{
    "bool":{
      "should": [
        { "match": { "title":   "life"        }}, 
        { "match": { "tagline": "Elasticsearch" }}  
      ],
      "filter":[
        {"term":{"title":"steve"}},
        {"term":{"cast.name":"gaspard"}},
        {"range": { "release_date": { "lte": "2015/01/01" }}},
        {"range": { "popularity": { "gte": "25" }}}
        ]
    }
  }
}
可以看到分数



function score自定义打分

GET /movie/_search
{
  "query":{
    "function_score": {
      //原始查询得到oldscore
      "query": {      
        "multi_match":{
        "query":"steve job",
        "fields":["title","overview"],
        "operator": "or",
        "type":"most_fields"
      }
    },
    "functions": [
      {"field_value_factor": {
          "field": "popularity",   //对应要处理的字段
          "modifier": "log2p",    //将字段值+2后，计算对数
          "factor": 10    //字段预处理*10
        }
      }
    ], 

    "score_mode": "sum",   //不同的field value之间的得分相加
    "boost_mode": "sum"    //最后在与old value相加
  }
}
}

