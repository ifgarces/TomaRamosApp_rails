#! ---
#! DEPRECATED
#! ---

require 'day_of_week'

module QueryUtil
public
    # @param event1 [RamoEvent]
    # @param event2 [RamoEvent]
    # @return [Boolean] whether the events collide with each other.
    # @raise Exception when the events are not of the same broad type (evaluation or non-evaluation). The way for
    # comparing conflicts between those two broat types is different, can't compare evaluation and non-evaluation.
    def self.are_events_conflicted(event1, event2)
        isEvalEvent1 = event1.is_evaluation()
        isEvalEvent2 = event2.is_evaluation()
        if (isEvalEvent1 && isEvalEvent2) # comparing evaluations: considering date and times
            if (event1.date != event2.date)
                return false
            end
        elsif (!isEvalEvent1) && (!isEvalEvent2) # comparing non-evluations: considering day_of_week and times
            if (event1.day_of_week != event2.day_of_week)
                return false
            end
        else
            raise "Inconsistent events: can't get conflict between evalation and non-evaluation events!"
        end

        # "does 1 starts before 2 finished and 1 finishes after 2 starts?"
        return (event1.start_time <= event2.end_time) && (event1.end_time >= event2.start_time)
    end

    # Iterates over a given collection of `Ramo`s and checks if a given event that **belongs to one of the `Ramo`s**
    # already, has conflicts.
    # @param ramos [Array<Ramo>]
    # @param event [RamoEvent]
    # @return [Array<RamoEvent>] the collection of conflictive `RamoEvent`s with `event`. If there is no conflict, this
    # array will be empty.
    def self.get_conflicts_for_new_event(ramos, event)
        conflicts = []
        ramos.each do |ramo|
            ramo.ramo_events.each do |ev|
                if (ev.id != event.id)
                    if (QueryUtil.are_events_conflicted(ev, event))
                        conflicts.append(ev)
                    end
                end
            end
        end

        # Adding `event` itself to the conflict array, in order to including it in the conflict report displayed to the
        # user
        #TODO: avoid that!
        if (conflicts.empty?())
            conflicts.insert(0, event)
        end
        return conflicts
    end

    # @param ramos [Array<Ramo>]
    # @return [Hash<DayOfWeek, Array<RamoEvent>>]
    def self.get_events_by_week_day(ramos)
        results = {
            DayOfWeek::MONDAY => [],
            DayOfWeek::TUESDAY => [],
            DayOfWeek::WEDNESDAY => [],
            DayOfWeek::THURSDAY => [],
            DayOfWeek::FRIDAY => []
        }
        ramos.each do |ramo|
            ramo.ramo_events.each do |event|
                if (! event.is_evaluation())
                    dayOfWeek = DayOfWeek.parseStringDay(event.day_of_week)
                    begin
                        results[dayOfWeek].append(event)
                    rescue
                        raise "Unknown day for event %s" % [event.as_json()]
                    end
                end
            end
        end
        return results
    end
end
