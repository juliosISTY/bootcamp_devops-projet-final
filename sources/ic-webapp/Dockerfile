FROM python:3.6-alpine
LABEL maintainer="JULES LANDO"
WORKDIR /opt
RUN apk update && apk add python3-dev build-base openldap-dev python2-dev git
RUN rm -rf /tmp/* /var/tmp/*
RUN pip install flask==1.1.2 flask_httpauth==4.1.0 flask_simpleldap python-dotenv==0.14.0
EXPOSE 8080
RUN git clone https://github.com/sadofrazer/ic-webapp.git
ENV ODOO_URL="https://www.odoo.com/"
ENV PGADMIN_URL="https://www.pgadmin.org/"
ENTRYPOINT ["python"]
CMD [ "ic-webapp/app.py" ]