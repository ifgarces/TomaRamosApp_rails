require "test_helper"
require "tempfile"
require "time"
require "date"
require "csv_parsing/csv_data_importer"
require "enums/event_type_enum"
require "enums/day_of_week_enum"

class CsvDataImporterTest < ActiveSupport::TestCase
  setup do
    @typeClass = EventType.new(name: EventTypeEnum::CLASS)
    @typeAssist = EventType.new(name: EventTypeEnum::ASSISTANTSHIP)
    @typeLab = EventType.new(name: EventTypeEnum::LABORATORY)
    @typeTest = EventType.new(name: EventTypeEnum::TEST)
    @typeExam = EventType.new(name: EventTypeEnum::EXAM)
    [
      @typeClass, @typeAssist, @typeLab, @typeTest, @typeExam
    ].each do |eventType|
      eventType.save!()
    end

    @CSV_HEADER = "PLAN DE ESTUDIOS,NRC,CONECTOR  LIGA,LISTA CRUZADA,MATERIA,CURSO,SECC.,TITULO,CREDITO,LUNES,MARTES,MIERCOLES,JUEVES,VIERNES,SABADO,INICIO,FIN,SALA,TIPO,PROFESOR"
  end


  # Note: this one references to the first test at `CsvRowTest`
  test "import success single line" do
    period = AcademicPeriod.new(name: "whatever-period")
    period.save!()

    csvTempFile = Tempfile.new("csv", encoding: "utf-8")
    csvTempFile.write("#{@CSV_HEADER}
PE2016,4444,,,ING,1100,1,ALGEBRA E INTR. AL CALCULO,10,,,,,14:30 -16:20,,20/3/2022,22/06/2022,,AYUD,tata Sánchez la leyenda")
    csvTempFile.rewind()

    begin
      gotCourses, gotEventsHash = CsvDataImporter.import(csvTempFile.path, period)
    ensure
      csvTempFile.close()
      csvTempFile.unlink()
    end

    expectedCourses = [
      CourseInstance.new(
        nrc: "4444",
        title: "ALGEBRA E INTR. AL CALCULO",
        teacher: "tata Sánchez la leyenda",
        credits: 10,
        career: "ING",
        course_number: 1100,
        section: "1",
        curriculum: "PE2016",
        academic_period: period
      )
    ]

    # :Hash<Integer, Array<CourseEvent>> This workaround is needed as we don't want to save the expected stuff in database
    expectedEventsHash = {
      4444 => [
        CourseEvent.new(
          event_type: @typeAssist,
          location: nil,
          day_of_week: DayOfWeekEnum::FRIDAY,
          start_time: Time.utc(2000, 1, 1, 14, 30),
          end_time: Time.utc(2000, 1, 1, 16, 20),
          date: Date.new(2022, 3, 20)
        )
      ]
    }

    puts("Comparing courses...")
    assertEqualCourseInstancesArray(expectedCourses, gotCourses)

    puts("Comparing events...")
    assert_equal(expectedEventsHash.keys().count(), gotEventsHash.keys().count())
    assert_equal(expectedEventsHash.keys(), gotEventsHash.keys())

    expectedEventsHash.each do |nrc, _|
      assertEqualCourseEventsArray(expectedEventsHash[nrc], gotEventsHash[nrc])
    end
  end


  test "import success small" do
    period = AcademicPeriod.new(name: "whatever-period")
    period.save!()

    csvTempFile = Tempfile.new("csv", encoding: "utf-8")
    csvTempFile.write("#{@CSV_HEADER}
PE2016,4444,,,ING,1100,1,ALGEBRA E INTR. AL CALCULO,10,08:30 -10:20,,,08:30 -10:20,,,2/3/2022,22/06/2022,R-14,CLAS,PETERS/RODRIGUEZ EDUARDO FABIAN
PE2016,4444,,,ING,1100,1,ALGEBRA E INTR. AL CALCULO,10,14:30 -16:20,,,,,,7/3/2022,22/06/2022,CEN-101,AYUD,PETERS/RODRIGUEZ EDUARDO FABIAN
PE2016,666,Foo,,ICC,4101,1,ALGORITHMS AND COMPETITIVE PRO,6,,,,15:30 -19:20,,,7/3/2022,22/06/2022,,CLAS,CORREA/VILLANUEVA JAVIER  ")
    csvTempFile.rewind()

    begin
      gotCourses, gotEventsHash = CsvDataImporter.import(csvTempFile.path, period)
    ensure
      csvTempFile.close()
      csvTempFile.unlink()
    end

    expectedCourses = [
      CourseInstance.new(
        nrc: "4444",
        title: "ALGEBRA E INTR. AL CALCULO",
        teacher: "PETERS/RODRIGUEZ EDUARDO FABIAN",
        credits: 10,
        career: "ING",
        course_number: 1100,
        section: "1",
        curriculum: "PE2016",
        academic_period: period
      ),
      CourseInstance.new(
        nrc: "666",
        title: "ALGORITHMS AND COMPETITIVE PRO",
        teacher: "CORREA/VILLANUEVA JAVIER",
        credits: 6,
        career: "ICC",
        course_number: 4101,
        section: "1",
        curriculum: "PE2016",
        liga: "Foo",
        academic_period: period
      )
    ]

    # :Hash<Integer, Array<CourseEvent>> This workaround is needed as we don't want to save the expected stuff in database
    expectedEventsHash = {
      4444 => [
        CourseEvent.new(
          event_type: @typeClass,
          location: "R-14",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: @typeClass,
          location: "CEN-101",
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: @typeAyud,
          location: nil,
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 14, 30),
          end_time: Time.utc(2000, 1, 1, 16, 20),
          date: Date.new(2022, 3, 2)
        )
      ],
      666 => [
        CourseEvent.new(
          event_type: @typeClass,
          location: nil,
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 19, 20),
          date: Date.new(2022, 3, 7)
        )
      ]
    }

    puts("Comparing courses...")
    assertEqualCourseInstancesArray(expectedCourses, gotCourses)

    puts("Comparing events...")
    assert_equal(expectedEventsHash.keys().count(), gotEventsHash.keys().count())
    assert_equal(expectedEventsHash.keys(), gotEventsHash.keys())

    expectedEventsHash.each do |nrc, _|
      puts("--- #{nrc} ---")
      puts(expectedEventsHash[nrc].map{ |it| it.inspect() }.join("\n"))
      puts()
      puts(gotEventsHash[nrc].map{ |it| it.inspect() }.join("\n"))
      puts("---")

      assertEqualCourseEventsArray(expectedEventsHash[nrc], gotEventsHash[nrc])
    end
    print("YES.")
  end


  test "import success large" do
    period = AcademicPeriod.new(name: "2022-10")
    period.save!()

    return #!!!!!!

    csvTempFile = Tempfile.new("csv", encoding: "utf-8")
    csvTempFile.write("#{@CSV_HEADER}
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
    csvTempFile.rewind()

    begin
      gotCourses, gotEventsHash = CsvDataImporter.import(csvTempFile.path, period)
      puts("gotCourses=%s, gotEventsHash=%s" % [gotCourses.inspect(), gotEventsHash.inspect()])
    ensure
      csvTempFile.close()
      csvTempFile.unlink()
    end

    expectedCourses = [
      CourseInstance.new(
        nrc: "3789",
        title: "ALGEBRA E INTR. AL CALCULO",
        teacher: "PETERS/RODRIGUEZ EDUARDO FABIAN",
        credits: 10,
        career: "ING",
        course_number: 1100,
        section: "1",
        curriculum: "PE2016",
        academic_period: period
      ),
      CourseInstance.new(
        nrc: "3790",
        title: "ALGEBRA E INTR. AL CALCULO",
        teacher: "SANCHEZ/CANCINO LEONARDO FRANCISCO",
        credits: 10,
        career: "ING",
        course_number: 1100,
        section: "2",
        curriculum: "PE2016",
        academic_period: period
      ),
      CourseInstance.new(
        nrc: "3794",
        title: "ALGEBRA LINEAL",
        teacher: "BASTARRICA/MELGAREJO JOSEFINA ESTEFANIA",
        credits: 6,
        career: "ING",
        course_number: 1201,
        section: "1",
        curriculum: "PE2016",
        academic_period: period
      ),
      CourseInstance.new(
        nrc: "3795",
        title: "ALGEBRA LINEAL",
        teacher: "CARRASCO/BRIONES MIGUEL ANGEL",
        credits: 6,
        career: "ING",
        course_number: 1201,
        section: "2",
        curriculum: "PE2016",
        academic_period: period
      ),
      CourseInstance.new(
        nrc: "3797",
        title: "ALGORITHMS AND COMPETITIVE PRO",
        teacher: "CORREA/VILLANUEVA JAVIER",
        credits: 6,
        career: "ICC",
        course_number: 4101,
        section: "1",
        curriculum: "PE2016",
        liga: "Foo",
        academic_period: period
      )
    ]

    # :Hash<Integer, Array<CourseEvent>> This workaround is needed as we don't want to save the expected stuff in database
    expectedEventsHash = {
      3789 => [
        CourseEvent.new(
          event_type: @typeClass,
          location: "R-14",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: @typeClass,
          location: "R-14",
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: @typeAssist,
          location: nil,
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 14, 30),
          end_time: Time.utc(2000, 1, 1, 16, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 3, 24)
        ),
        CourseEvent.new(
          event_type: @typeClass,
          location: nil,
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 12, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: @typeExam,
          location: nil,
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 9, 30),
          end_time: Time.utc(2000, 1, 1, 11, 20),
          date: Date.new(2022, 6, 28)
        ),
        CourseEvent.new(
          event_type: @typeAssist,
          location: nil,
          day_of_week: DayOfWeekEnum::WEDNESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 4, 11)
        )
      ],
      3790 => [
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 3, 24)
        ),
        CourseEvent.new(
          event_type: @typeClass,
          location: nil,
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: @typeAssist,
          location: nil,
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 14, 30),
          end_time: Time.utc(2000, 1, 1, 16, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 4, 11)
        ),
        CourseEvent.new(
          event_type: @typeClass,
          location: "R-11",
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 12, 20),
          date: Date.new(2022, 3, 2)
        ),
        CourseEvent.new(
          event_type: @typeExam,
          location: nil,
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 9, 30),
          end_time: Time.utc(2000, 1, 1, 11, 20),
          date: Date.new(2022, 6, 28)
        ),
        CourseEvent.new(
          event_type: @typeAssist,
          location: nil,
          day_of_week: DayOfWeekEnum::WEDNESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: @typeClass,
          location: "R-12",
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 2)
        )
      ],
      3794 => [
        CourseEvent.new(
          event_type: @typeClass,
          location: "B-32",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 4, 4)
        ),
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 5, 2)
        ),
        CourseEvent.new(
          event_type: @typeAssist,
          location: nil,
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 3, 14)
        ),
        CourseEvent.new(
          event_type: @typeExam,
          location: nil,
          day_of_week: DayOfWeekEnum::WEDNESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 6, 29)
        ),
        CourseEvent.new(
          event_type: @typeClass,
          location: "R-14",
          day_of_week: DayOfWeekEnum::FRIDAY,
          start_time: Time.utc(2000, 1, 1, 8, 30),
          end_time: Time.utc(2000, 1, 1, 10, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 5, 26)
        ),
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 6, 13)
        )
      ],
      3795 => [
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 4, 4)
        ),
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 5, 2)
        ),
        CourseEvent.new(
          event_type: @typeClass,
          location: "I201",
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 14, 30),
          end_time: Time.utc(2000, 1, 1, 16, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 5, 26)
        ),
        CourseEvent.new(
          event_type: @typeAssist,
          location: nil,
          day_of_week: DayOfWeekEnum::TUESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 3, 14)
        ),
        CourseEvent.new(
          event_type: @typeClass,
          location: "H-208",
          day_of_week: DayOfWeekEnum::WEDNESDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 17, 20),
          date: Date.new(2022, 3, 7)
        ),
        CourseEvent.new(
          event_type: @typeExam,
          location: nil,
          day_of_week: DayOfWeekEnum::WEDNESDAY,
          start_time: Time.utc(2000, 1, 1, 11, 30),
          end_time: Time.utc(2000, 1, 1, 13, 20),
          date: Date.new(2022, 6, 29)
        ),
        CourseEvent.new(
          event_type: @typeTest,
          location: nil,
          day_of_week: DayOfWeekEnum::MONDAY,
          start_time: Time.utc(2000, 1, 1, 19, 30),
          end_time: Time.utc(2000, 1, 1, 21, 20),
          date: Date.new(2022, 6, 13)
        )
      ],
      3797 => [
        CourseEvent.new(
          event_type: @typeClass,
          location: nil,
          day_of_week: DayOfWeekEnum::THURSDAY,
          start_time: Time.utc(2000, 1, 1, 15, 30),
          end_time: Time.utc(2000, 1, 1, 19, 20),
          date: Date.new(2022, 3, 7)
        )
      ]
    }

    assertEqualCourseInstancesArray(expectedCourses, gotCourses)

    assert_equal(expectedEventsHash.keys().count(), gotEventsHash.keys().count())
    assert_equal(expectedEventsHash.keys(), gotEventsHash.keys())

    return #!!!!!!

    expectedEventsHash.each do |nrc, _|
      puts("---")
      puts(expectedEventsHash[nrc].map{ |it| it.inspect() }.join("\n"))
      puts()
      puts(gotEventsHash[nrc].map{ |it| it.inspect() }.join("\n"))
      puts("---")
      assertEqualCourseEventsArray(expectedEventsHash[nrc], gotEventsHash[nrc])
    end
  end
end
