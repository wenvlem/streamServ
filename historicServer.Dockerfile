FROM python:3.6.12-alpine3.12

WORKDIR /historic
COPY gallery.html gallery.html

CMD [ "python3", "-m", "http.server" ]
