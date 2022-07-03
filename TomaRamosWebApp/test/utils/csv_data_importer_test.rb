require "test_helper"
require "tempfile"
require "time"
require "date"
require "utils/csv_data_importer"
require "enums/event_type_enum"
require "enums/day_of_week_enum"

class CsvDataImporterTest < ActiveSupport::TestCase
  setup do
    [
      EventTypeEnum::CLASS,
      EventTypeEnum::ASSISTANTSHIP,
      EventTypeEnum::LABORATORY,
      EventTypeEnum::TEST,
      EventTypeEnum::EXAM
    ].each do |eventTypeName|
      EventType.new(name: eventTypeName).save!()
    end
  end

  teardown do
    CourseEvent.delete_all()
    CourseInstance.delete_all()

    [
      EventTypeEnum::CLASS,
      EventTypeEnum::ASSISTANTSHIP,
      EventTypeEnum::LABORATORY,
      EventTypeEnum::TEST,
      EventTypeEnum::EXAM
    ].each do |eventTypeName|
      EventType.find_by(name: eventTypeName).destroy!()
    end
  end

  test "import success" do
    csvTempFile = Tempfile.new("csv")
    csvTempFile.write("PLAN DE ESTUDIOS,NRC,CONECTOR  LIGA,LISTA CRUZADA,MATERIA,CURSO,SECC.,TITULO,CREDITO,LUNES,MARTES,MIERCOLES,JUEVES,VIERNES,SABADO,INICIO,FIN,SALA,TIPO,PROFESOR
PE2016,3789,,,ING,1100,1,ALGEBRA E INTR. AL CALCULO,10,08:30 -10:20,,,08:30 -10:20,,,2/3/2022,22/06/2022,R-14,CLAS,PETERS/RODRIGUEZ EDUARDO FABIAN
PE2016,3789,,,ING,1100,1,ALGEBRA E INTR. AL CALCULO,10,14:30 -16:20,,,,,,7/3/2022,22/06/2022,,AYUD,PETERS/RODRIGUEZ EDUARDO FABIAN
PE2016,3789,,,ING,1100,1,ALGEBRA E INTR. AL CALCULO,10,,,,19:30 -21:20,,,24/03/2022,24/03/2022,,PRBA 1,PETERS/RODRIGUEZ EDUARDO FABIAN
PE2016,3790,,,ING,1100,2,ALGEBRA E INTR. AL CALCULO,10,,,,19:30 -21:20,,,24/03/2022,24/03/2022,,PRBA 1,SANCHEZ/CANCINO LEONARDO FRANCISCO
PE2016,3789,,,ING,1100,1,ALGEBRA E INTR. AL CALCULO,10,,08:30 -12:20,,,,,2/3/2022,22/06/2022,,CLAS,PETERS/RODRIGUEZ EDUARDO FABIAN
PE2016,3789,,,ING,1100,1,ALGEBRA E INTR. AL CALCULO,10,,09:30 -11:20,,,,,28/06/2022,28/06/2022,,EXAM,PETERS/RODRIGUEZ EDUARDO FABIAN
PE2016,3789,,,ING,1100,1,ALGEBRA E INTR. AL CALCULO,10,,,15:30 -17:20,,,,7/3/2022,22/06/2022,,AYUD,PETERS/RODRIGUEZ EDUARDO FABIAN
PE2016,3790,,,ING,1100,2,ALGEBRA E INTR. AL CALCULO,10,08:30 -10:20,,,,,,2/3/2022,22/06/2022,,CLAS,SANCHEZ/CANCINO LEONARDO FRANCISCO
PE2016,3790,,,ING,1100,2,ALGEBRA E INTR. AL CALCULO,10,14:30 -16:20,,,,,,7/3/2022,22/06/2022,,AYUD,SANCHEZ/CANCINO LEONARDO FRANCISCO
PE2016,3789,,,ING,1100,1,ALGEBRA E INTR. AL CALCULO,10,19:30 -21:20,,,,,,11/4/2022,11/4/2022,,PRBA 2,PETERS/RODRIGUEZ EDUARDO FABIAN
PE2016,3790,,,ING,1100,2,ALGEBRA E INTR. AL CALCULO,10,19:30 -21:20,,,,,,11/4/2022,11/4/2022,,PRBA 2,SANCHEZ/CANCINO LEONARDO FRANCISCO
PE2016,3790,,,ING,1100,2,ALGEBRA E INTR. AL CALCULO,10,,08:30 -12:20,,,,,2/3/2022,22/06/2022,R-11,CLAS,SANCHEZ/CANCINO LEONARDO FRANCISCO
PE2016,3790,,,ING,1100,2,ALGEBRA E INTR. AL CALCULO,10,,09:30 -11:20,,,,,28/06/2022,28/06/2022,,EXAM,SANCHEZ/CANCINO LEONARDO FRANCISCO
PE2016,3790,,,ING,1100,2,ALGEBRA E INTR. AL CALCULO,10,,,15:30 -17:20,,,,7/3/2022,22/06/2022,,AYUD,SANCHEZ/CANCINO LEONARDO FRANCISCO
PE2016,3790,,,ING,1100,2,ALGEBRA E INTR. AL CALCULO,10,,,,08:30 -10:20,,,2/3/2022,22/06/2022,R-12,CLAS,SANCHEZ/CANCINO LEONARDO FRANCISCO
PE2016,3794,,,ING,1201,1,ALGEBRA LINEAL,6,08:30 -10:20,,,,,,7/3/2022,22/06/2022,B-32,CLAS,BASTARRICA/MELGAREJO JOSEFINA ESTEFANIA
PE2016,3794,,,ING,1201,1,ALGEBRA LINEAL,6,19:30 -21:20,,,,,,4/4/2022,4/4/2022,,PRBA 1,BASTARRICA/MELGAREJO JOSEFINA ESTEFANIA
PE2016,3795,,,ING,1201,2,ALGEBRA LINEAL,6,19:30 -21:20,,,,,,4/4/2022,4/4/2022,,PRBA 1,CARRASCO/BRIONES MIGUEL ANGEL 
PE2016,3794,,,ING,1201,1,ALGEBRA LINEAL,6,19:30 -21:20,,,,,,2/5/2022,2/5/2022,,PRBA 2,BASTARRICA/MELGAREJO JOSEFINA ESTEFANIA
PE2016,3794,,,ING,1201,1,ALGEBRA LINEAL,6,,15:30 -17:20,,,,,14/03/2022,22/06/2022,,AYUD,BASTARRICA/MELGAREJO JOSEFINA ESTEFANIA
PE2016,3794,,,ING,1201,1,ALGEBRA LINEAL,6,,,15:30 -17:20,,,,29/06/2022,29/06/2022,,EXAM,BASTARRICA/MELGAREJO JOSEFINA ESTEFANIA
PE2016,3795,,,ING,1201,2,ALGEBRA LINEAL,6,19:30 -21:20,,,,,,2/5/2022,2/5/2022,,PRBA 2,CARRASCO/BRIONES MIGUEL ANGEL 
PE2016,3794,,,ING,1201,1,ALGEBRA LINEAL,6,,,,,08:30 -10:20,,7/3/2022,22/06/2022,R-14,CLAS,BASTARRICA/MELGAREJO JOSEFINA ESTEFANIA
PE2016,3795,,,ING,1201,2,ALGEBRA LINEAL,6,14:30 -16:20,,,,,,7/3/2022,22/06/2022,I201,CLAS,CARRASCO/BRIONES MIGUEL ANGEL 
PE2016,3794,,,ING,1201,1,ALGEBRA LINEAL,6,,,,19:30 -21:20,,,26/05/2022,26/05/2022,,PRBA 3,BASTARRICA/MELGAREJO JOSEFINA ESTEFANIA
PE2016,3795,,,ING,1201,2,ALGEBRA LINEAL,6,,,,19:30 -21:20,,,26/05/2022,26/05/2022,,PRBA 3,CARRASCO/BRIONES MIGUEL ANGEL 
PE2016,3794,,,ING,1201,1,ALGEBRA LINEAL,6,19:30 -21:20,,,,,,13/06/2022,13/06/2022,,PRBA 4,BASTARRICA/MELGAREJO JOSEFINA ESTEFANIA
PE2016,3795,,,ING,1201,2,ALGEBRA LINEAL,6,,15:30 -17:20,,,,,14/03/2022,22/06/2022,,AYUD,CARRASCO/BRIONES MIGUEL ANGEL 
PE2016,3795,,,ING,1201,2,ALGEBRA LINEAL,6,,,15:30 -17:20,,,,7/3/2022,22/06/2022,H-208,CLAS,CARRASCO/BRIONES MIGUEL ANGEL 
PE2016,3795,,,ING,1201,2,ALGEBRA LINEAL,6,,,11:30 -13:20,,,,29/06/2022,29/06/2022,,EXAM,CARRASCO/BRIONES MIGUEL ANGEL 
PE2016,3795,,,ING,1201,2,ALGEBRA LINEAL,6,19:30 -21:20,,,,,,13/06/2022,13/06/2022,,PRBA 4,CARRASCO/BRIONES MIGUEL ANGEL 
PE2016,3797,Foo,,ICC,4101,1,ALGORITHMS AND COMPETITIVE PRO,6,,,,15:30 -19:20,,,7/3/2022,22/06/2022,,CLAS,CORREA/VILLANUEVA JAVIER  ")
    csvTempFile.rewind() #? needed?

    period = AcademicPeriod.new(name: "2022-10")
    period.save!()

    begin
      CsvDataImporter.import(csvTempFile.path, period)
    ensure
      csvTempFile.close()
      csvTempFile.unlink()
    end

    gotCourses = period.getCourses()

    expectedCourses = [
      CourseInstance.new(
        nrc: 3789,
        title: "ALGEBRA E INTR. AL CALCULO",
        teacher: "PETERS/RODRIGUEZ EDUARDO FABIAN",
        credits: 10,
        career: "ING",
        course_number: 1100,
        section: "1",
        curriculum: "PE2016"
      ),
      CourseInstance.new(
        nrc: 3790,
        title: "ALGEBRA E INTR. AL CALCULO",
        teacher: "SANCHEZ/CANCINO LEONARDO FRANCISCO",
        credits: 10,
        career: "ING",
        course_number: 1100,
        section: "2",
        curriculum: "PE2016"
      ),
      CourseInstance.new(
        nrc: 3794,
        title: "ALGEBRA LINEAL",
        teacher: "BASTARRICA/MELGAREJO JOSEFINA ESTEFANIA",
        credits: 6,
        career: "ING",
        course_number: 1201,
        section: "1",
        curriculum: "PE2016"
      ),
      CourseInstance.new(
        nrc: 3795,
        title: "ALGEBRA LINEAL",
        teacher: "CARRASCO/BRIONES MIGUEL ANGEL",
        credits: 6,
        career: "ING",
        course_number: 1201,
        section: "2",
        curriculum: "PE2016"
      ),
      CourseInstance.new(
        nrc: 3797,
        title: "ALGORITHMS AND COMPETITIVE PRO",
        teacher: "CORREA/VILLANUEVA JAVIER",
        credits: 6,
        career: "ICC",
        course_number: 4101,
        section: "1",
        curriculum: "PE2016",
        liga: "Foo"
      )
    ]

    # This workaround is needed as we don't want to save the expected stuff in database
    eventsHash = {
      3789 => [
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::CLASS),
          location: "R-14",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::CLASS),
          location: "R-14",
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::ASSISTANTSHIP),
          location: "",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 14, 30),
          end_time: Time.utc(2000, 1, 1, 16, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 3, 24)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::CLASS),
          location: "",
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 12, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::EXAM),
          location: "",
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 9, 30),
          end_time: Time.utc(2000, 1, 1, 11, 20),
          date: Date.new(2022, 6, 28)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::ASSISTANTSHIP),
          location: "",
          day_of_week: DayOfWeekEnum::WEDNESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 4, 11)
        )
      ],
      3790 => [
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 3, 24)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::CLASS),
          location: "",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::ASSISTANTSHIP),
          location: "",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 14, 30),
          end_time: Time.utc(2000, 1, 1, 16, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 4, 11)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::CLASS),
          location: "R-11",
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 12, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::EXAM),
          location: "",
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 9, 30),
          end_time: Time.utc(2000, 1, 1, 11, 20),
          date: Date.new(2022, 6, 28)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::ASSISTANTSHIP),
          location: "",
          day_of_week: DayOfWeekEnum::WEDNESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::CLASS),
          location: "R-12",
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 2)
        )
      ],
      3794 => [
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::CLASS),
          location: "B-32",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 4, 4)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 5, 2)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::ASSISTANTSHIP),
          location: "",
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 3, 14)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::EXAM),
          location: "",
          day_of_week: DayOfWeekEnum::WEDNESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 6, 29)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::CLASS),
          location: "R-14",
          day_of_week: DayOfWeekEnum::FRIDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 5, 26)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 6, 13)
        )
      ],
      3795 => [
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 4, 4)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 5, 2)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::CLASS),
          location: "I201",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 14, 30),
          end_time: Time.utc(2000, 1, 1, 16, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 5, 26)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::ASSISTANTSHIP),
          location: "",
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 3, 14)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::CLASS),
          location: "H-208",
          day_of_week: DayOfWeekEnum::WEDNESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::EXAM),
          location: "",
          day_of_week: DayOfWeekEnum::WEDNESDAY,
          start_time: Time.utc(2000, 1, 1, 11, 30),
          end_time: Time.utc(2000, 1, 1, 13, 20),
          date: Date.new(2022, 6, 29)
        ),
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::TEST),
          location: "",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 6, 13)
        )
      ],
      3797 => [
        CourseEvent.new(
          event_type: EventType.new(name: EventTypeEnum::CLASS),
          location: "",
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 19, 20),
          date: Date.new(2022, 3, 7)
        )
      ]
    }

    assert_equal(expectedCourses.count(), gotCourses.count())

    expectedCourses.each_index do |courseIndex|
      assertEqualCourseInstances(expectedCourses[courseIndex], gotCourses[courseIndex])

      NRC = expectedCourses[courseIndex].nrc.to_i()

      expectedEvents = eventsHash[NRC]
      gotEvents = gotCourses[courseIndex].course_events

      assert_equal(expectedEvents.count(), gotEvents.count())

      # The comparison is not right, should sort both arrays first, by some very consistent criteria
      expectedEvents.each_index do |eventIndex|
        assertEqualCourseEvents(expectedEvents[eventIndex], gotEvents[eventIndex])
      end
    end
  end
end
