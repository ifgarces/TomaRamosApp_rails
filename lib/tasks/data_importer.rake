namespace :data_importer do
  desc "
  Rake task(s) for importing data from sheet files (e.g. CSV) for when the faculty performs changes
  on the catalog.
  "

  # Retraives data from the CSV (standard engineering faculty format) and fills the database
  task csv_all: :environment do
    #TODO: clear `ramo` and `ramo_event` tables

    #TODO: parse CSV and insert data on those tables

    throw NotImplementedError
  end

end
