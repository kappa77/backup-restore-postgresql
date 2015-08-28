#!/bin/bash
psql -c "select max(id), count(id) from test;"
