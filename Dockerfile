### Build and install packages
FROM python:3.9 as build-python

RUN apt-get -y update \
  && apt-get install -y gettext \
  # Cleanup apt cache
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY ./photo_api/requirements.txt ./photo_api/
WORKDIR ./photo_api
RUN pip3 install -r requirements.txt

### Final image
FROM python:3.9-slim

RUN groupadd -r photo && useradd -r -g photo photo

RUN apt-get update \
  && apt-get install -y \
    libxml2 \
    libssl1.1 \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf2.0-0 \
    shared-mime-info \
    mime-support \
    git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY ./photo_api ./photo_api
COPY --from=build-python /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
COPY --from=build-python /usr/local/bin/ /usr/local/bin/
WORKDIR ./photo_api

ADD ./photo_api/config ./photo_api/config
ADD .git .git

RUN mkdir -p /photo_api/media /photo_api/static \
  && chown -R photo:photo /photo_api/

RUN python3 -m pip uninstall -y psycopg2-binary
RUN python3 -m pip install psycopg2-binary


EXPOSE 8020
ENV PORT 8020
ENV PYTHONUNBUFFERED 1
ENV PROCESSES 4
