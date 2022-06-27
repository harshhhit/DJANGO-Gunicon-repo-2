FROM python:3.8.3 

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ENV APP_ROOT /src
ENV CONFIG_ROOT /config


RUN mkdir ${CONFIG_ROOT}
COPY requirements.txt ${CONFIG_ROOT}/requirements.txt

RUN pip install -r ${CONFIG_ROOT}/requirements.txt

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}


ADD . ${APP_ROOT}

RUN pip install virtualenv
RUN cd /src/django12/ && virtualenv env 
RUN cd /src/django12/ && source env/bin/activate

RUN apt update && apt install nginx -y

COPY ./gunicorn.socket /etc/systemd/system/


COPY ./gunicorn.service /etc/systemd/system/

COPY ./nginx /etc/nginx/sites-available/
RUN cp /etc/nginx/sites-available/nginx /etc/nginx/sites-enabled/ 
RUN service nginx start

RUN pip install virtualenv


# ENTRYPOINT ["gunicorn.socket","enabled"]
# CMD ["gunicorn.socket","start"]





