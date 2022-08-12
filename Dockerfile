# Copyright (c) 2021-2022 Vincent A. Cicirello
# https://www.cicirello.org/
# Licensed under the MIT License
FROM ghcr.io/cicirello/pyaction:4.7.0

## Make entry point exectuable
RUN ["chmod", "+x", "/generatesitemap.py"]
COPY generatesitemap.py /generatesitemap.py
ENTRYPOINT ["/generatesitemap.py"]
