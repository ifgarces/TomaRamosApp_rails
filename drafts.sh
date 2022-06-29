#!/bin/sh
# --------------------------------------------------------------------------------------------------
# Temporal useful drafts for generating models, migrations, controllers, etc.
# --------------------------------------------------------------------------------------------------

set -exu

# --- Models --- #
# rails generate model academic_period \
#     name:string{16}

# rails generate model course_event \
    # location:string{32} \
    # day_of_week:string{16} \
    # start_time:time \
    # end_time:time \
    # date:date

# rails generate model event_type \
#     name:string{32}

# rails generate model course_instance \
    # nrc:string{16} \
    # title:string{128} \
    # teacher:string{128} \
    # credits:integer \
    # career:string{16} \
    # course_number:integer \
    # section:integer \
    # curriculum:string{16} \
    # liga:string{32} \
    # lcruz:string{32}

# rails generate model user_course_inscription

# rails generate model user \
#     email:string{128} \
#     username:string{64} \
#     password:digest

# --- Relations --- #
# rails generate migration 




# --- Creating controllers --- #
# rails generate scaffold_controller academic_period \
#     name:string{20}
# rails generate scaffold_controller ramo \
#     nrc:string{40} name:string{100} profesor:string{100} creditos:integer materia:string{60} \
#     curso:integer seccion:string{60} plan_estudios:string{60} conect_liga:string{60} \
#     lista_cruzada:string{60}
# rails generate scaffold_controller ramo_event \
#     location:string{32} day_of_week:string{16} start_time:time end_time:time date:date

#* Relations remainder
# When we get `MissingAttributeError` for setting association instance `B` into `A`, we shall run:
rails generate migration AddBForeignKeyToA b:references
# e.g. rails generate migration AddLodgingForeignKeyToGuestRating lodging:references
