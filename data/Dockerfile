FROM public.ecr.aws/lambda/python:3.12

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY grid_data/ ./grid_data/
COPY tests/ ./tests/
COPY grid_data.py ./

CMD ["grid_data.run"]