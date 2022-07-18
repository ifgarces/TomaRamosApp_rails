require "logger"
require "utils/logging_util"

@log = LoggingUtil.getStdoutLogger(__FILE__)

# Number of days in which a user is inactive to be marked for deletion with this task.
INACTIVE_DAYS_THRESHOLD = 7

namespace :data_cleaner do
  task guest_users: :environment do
    desc "
    Deletes old guest users that are no longer active, given a configurable threshold.
    "

    today = Time.now().utc.to_date()
    usersToDelete = User.where(is_admin: false).order(last_activity: :desc).filter { |user|
      (today - user.last_activity.utc.to_date()) / 1.hour() >= INACTIVE_DAYS_THRESHOLD
    }
    @log.debug("Will delete #{usersToDelete.count()} users, starting with #{usersToDelete.first().inspect()}")

    raise NotImplementedError.new()
  end
end
