FROM alpine:latest

MAINTAINER xujpxm

# 安装基础环境(nginx, supervisor, gevent, gunicorn)，并更改中国时区
RUN apk update \
    && apk add --no-cache nginx py-pip tzdata py-gevent supervisor py-gunicorn \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone \ 
    && apk del tzdata \
    && mkdir /run/nginx/ \
    && mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak 

# 上传nginx+supervisor服务的配置文件
ADD conf/nginx_example.conf /etc/nginx/conf.d/
ADD conf/supervisor_example.ini /etc/supervisor.d/

# 对外开放80端口
EXPOSE 80

# 安装python的常用运行依赖包
RUN  pip install --no-cache-dir requests logbook

# 启动supervisor，配置文件里包含nginx和gunicorn,相当于同时启动两个服务
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
