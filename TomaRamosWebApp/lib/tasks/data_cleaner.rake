require "utils/logging_util"

@log = LoggingUtil.getStdoutLogger(__FILE__)

# Number of days in which a user is inactive to be marked for deletion with this task.
INACTIVE_DAYS_THRESHOLD = 7

namespace :data_cleaner do
  task guest_users: :environment do
    desc "
    Deletes old guest users that are no longer active, given a configurable threshold.
    "

    now = Time.now()
    usersToDelete = User.where(is_admin: false).filter { |user|
      (now.utc - user.last_activity.utc) / 1.hour() >= INACTIVE_DAYS_THRESHOLD * 24
    }.sort_by { |user|
      user.last_activity.utc
    }.reverse()

    userCount = usersToDelete.count()

    @log.debug(
      "Will delete %d users, starting with %s and ending with %s" % [
        userCount, usersToDelete.first().inspect(), usersToDelete.last().inspect()
      ]
    )

    usersToDelete.each do |user|
      user.destroy!()
    end

    @log.info("[OK] Cleaning complete: #{userCount} Users deleted")
  end
end
