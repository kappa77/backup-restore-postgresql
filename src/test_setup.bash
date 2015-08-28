#!/bin/bash

psql -c "create table test(id serial primary key, value integer, created_at timestamp with time zone default now() );"

bash add_rows.bash
