#!/bin/bash
psql -c "select max(id), count(id) from test;"
psql -c "select nextval('test_id_seq');"
