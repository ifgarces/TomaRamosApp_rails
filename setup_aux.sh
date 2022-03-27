# Creating the models
rails generate model app_metadatum \
    latest_version_name:string{100} catalog_current_period:string catalog_last_updated:string --force
rails generate model ramo \
    name:string{100} profesor:string{100} creditos:integer materia:string{30} curso:integer \
    seccion:string{30} plan_estudios:string{30} conect_liga:string{30} lista_cruzada:string{30} --force
rails generate model ramo_event_type \
    name:string{30} --force
rails generate model ramo_event \
    location:string{30} day_of_week:string{30} \
    start_time:time end_time:time date:date --force
#TODO: one-to-many relations between ramo-ramo_event and ramo_event_type-ramo_event
rails generate model user \
    tag:string{30}:uniq password:digest first_name:string{100} last_name:string{100} --force

# Creating controllers
rails generate scaffold_controller app_metadatum \
    latest_version_name:string{100} catalog_current_period:string catalog_last_updated:string --force
rails generate scaffold_controller ramo \
    name:string{100} profesor:string{100} creditos:integer materia:string{30} curso:integer \
    seccion:string{30} plan_estudios:string{30} conect_liga:string{30} lista_cruzada:string{30} --force
rails generate scaffold_controller ramo_event \
    location:string{30} day_of_week:string{30} \
    start_time:time end_time:time date:date --force

# Executing migrations
make rails_tasks
