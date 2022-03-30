#!/bin/sh
# --------------------------------------------------------------------------------------------------
# For generating models and controllers (again) when desired.
# --------------------------------------------------------------------------------------------------

set -exu

# Creating the models
rails generate model app_metadatum \
    latest_version_name:string{100} catalog_current_period:string catalog_last_updated:string --force
rails generate model ramo \
    nrc:string{40}:uniq nombre:string{100} profesor:string{100} creditos:integer materia:string{60} curso:integer \
    seccion:string{60} plan_estudios:string{60} conect_liga:string{60} lista_cruzada:string{60} --force
rails generate model ramo_event_type \
    name:string{60} --force
rails generate model ramo_event \
    location:string{60} day_of_week:string{60} \
    start_time:time end_time:time date:date --force
#TODO: one-to-many relations between ramo-ramo_event and ramo_event_type-ramo_event
rails generate model career_advice \
    title:string{60} description:text url:string{200} --force
    # image attached
rails generate model quick_hyperlink \
    name:string{60} url:string{200}
    # image attached
rails generate model user \
    tag:string{60}:uniq password:digest name:string{150} --force

# Creating controllers
rails generate scaffold_controller app_metadatum \
    latest_version_name:string{100} catalog_current_period:string catalog_last_updated:string --force #--api
rails generate scaffold_controller ramo \
    name:string{100} profesor:string{100} creditos:integer materia:string{60} curso:integer \
    seccion:string{60} plan_estudios:string{60} conect_liga:string{60} lista_cruzada:string{60} --force
rails generate scaffold_controller ramo_event \
    location:string{60} day_of_week:string{60} \
    start_time:time end_time:time date:date --force

# Executing migrations
make rails_tasks
