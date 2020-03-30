FROM python:3

MAINTAINER ayhan aibuzhe@qq.com

RUN apt-get update && apt-get install -y && \
    pip3 install uwsgi  && \
    pip3 install supervisor

RUN mkdir /code && \
    mkdir -p /etc/supervisor/conf.d

COPY . /code/
# supervisor基础配置 及 应用配置
COPY ./deploy/supervisord/supervisor.conf /etc/supervisor.conf
COPY ./deploy/supervisord/app.conf /etc/supervisor/conf.d/

WORKDIR /code

RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8000

# uwsgi启动
#CMD ["uwsgi", "--ini", "/code/deploy/uwsgi/uwsgi.ini"]

# supervisor启动
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
