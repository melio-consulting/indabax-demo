FROM python:3.11.1

ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY poetry.lock pyproject.toml ./
RUN pip install --upgrade pip && \
    pip install poetry && \
    poetry config virtualenvs.create false 

ARG DEV=false
RUN if [ "$DEV" = "true" ] ; then poetry install --with dev ; else poetry install --only main ; fi

COPY ./app/ ./
COPY ./ml/model/ ./ml/model/

ENV PYTHONPATH "${PYTHONPATH}:/app"

EXPOSE 8080
CMD uvicorn app.main:app --reload --host 0.0.0.0 --port 8080