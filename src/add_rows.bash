#!/bin/bash


psql -c "insert into test (value)select w.a from generate_series(1,100000,1) as w(a);"
