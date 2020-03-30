FROM python:3

MAINTAINER ayhan aibuzhe@qq.com

RUN apt-get update && apt-get install -y && \
    pip3 install uwsgi  && \
    pip3 install supervisor

RUN mkdir /code && \
    mkdir -p /etc/supervisor/conf.d

WORKDIR /code

COPY requirements.txt /code/

RUN pip3 install --no-cache-dir -r requirements.txt

# supervisor基础配置 及 应用配置
COPY ./deploy/supervisord/supervisor.conf /etc/supervisor.conf
COPY ./deploy/supervisord/app.conf /etc/supervisor/conf.d/

# docker渐进式构建，会充分利用缓存，它会从变动的那层及以下重新构建。因此将经常变动的部分往下放，可以加快构建速度。
# 代码部分经常变动，和requirements.txt分开，避免每次都需要重新安装依赖
COPY . /code/

EXPOSE 8000

# 直接启动
CMD ["python3", "/code/manage.py",  "runserver", "0.0.0.0:8000"]

# uwsgi启动
#CMD ["uwsgi", "--ini", "/code/deploy/uwsgi/uwsgi.ini"]

# supervisord启动
#CMD ["supervisord", "-c", "/etc/supervisor.conf"]

