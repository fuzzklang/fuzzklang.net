FROM python:3.9-alpine

WORKDIR /tmp

RUN pip install poetry==1.4.2
COPY ./pyproject.toml ./poetry.lock ./
RUN poetry export --without-hashes --format=requirements.txt > requirements.txt

COPY ./requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /tmp/requirements.txt

EXPOSE 80

COPY . .

# CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]

# If running behind a proxy like Nginx or Traefik add --proxy-headers
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80", "--proxy-headers"]
