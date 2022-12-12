FROM public.ecr.aws/lambda/python:3.9

COPY poetry.lock pyproject.toml ./
RUN python3.9 -m pip install poetry && \
    poetry config virtualenvs.create false 

RUN poetry install --with main,aws

COPY ./app/ ./
COPY ./ml/model/ ./ml/model/
RUN chmod 755 ./ml/model/model.pkl

CMD ["main-aws-lambda.handler"]
