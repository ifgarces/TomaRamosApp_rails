#!/bin/sh
# --------------------------------------------------------------------------------------------------
# For generating models and controllers (again) when desired.
# --------------------------------------------------------------------------------------------------

set -exu

# Creating controllers
rails generate scaffold_controller academic_period \
    name:string{20}
rails generate scaffold_controller ramo \
    nrc:string{40} name:string{100} profesor:string{100} creditos:integer materia:string{60} \
    curso:integer seccion:string{60} plan_estudios:string{60} conect_liga:string{60} \
    lista_cruzada:string{60}
rails generate scaffold_controller ramo_event \
    location:string{32} day_of_week:string{16} start_time:time end_time:time date:date

# Executing migrations
make rails_tasks
