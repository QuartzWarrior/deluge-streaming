#!/bin/bash
# Build script for Python 3.8+ (including 3.14)

python3 -m venv .env-egg3
.env-egg3/bin/pip install --upgrade pip setuptools wheel
.env-egg3/bin/pip install thomas rarfile rfc6266
ln -sf .env-egg3/lib/python*/site-packages/thomas .
ln -sf .env-egg3/lib/python*/site-packages/rarfile.py .
ln -sf .env-egg3/lib/python*/site-packages/rfc6266.py .
ln -sf .env-egg3/lib/python*/site-packages/lepl .
ln -sf .env-egg3/lib/python*/site-packages/pytz .
.env-egg3/bin/python setup.py bdist_egg


