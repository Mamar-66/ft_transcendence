FROM python:3.13

WORKDIR /app

COPY ./conf/requirements.txt /conf/

RUN pip install --no-cache-dir -r /conf/requirements.txt

EXPOSE 8000

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

