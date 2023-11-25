CLASS zcl_207_course_schedule_solve DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PRIVATE SECTION.
    METHODS is_it_poss_to_take_all_courses
      IMPORTING prerequisites                         TYPE ztt_207_tuple
                numcourses                            TYPE int4
      RETURNING VALUE(r_is_it_poss_to_take_all_crses) TYPE xfeld.
ENDCLASS.


CLASS zcl_207_course_schedule_solve IMPLEMENTATION.
  METHOD is_it_poss_to_take_all_courses.
    IF lines( prerequisites ) = 0.
      r_is_it_poss_to_take_all_crses = 'X'.
      RETURN.
    ENDIF.

    DATA(courses) = NEW cl_object_map( ).

    LOOP AT prerequisites INTO DATA(prerequisite).

      DATA(course) = NEW zcl_207_course_schedule_course( requirement_course = prerequisite-requirement_course
                                                         course             = prerequisite-course  ).

      courses->put( key   = course->get_obj_key( )
                    value = course ).

    ENDLOOP.

    LOOP AT prerequisites INTO prerequisite.

      DATA(my_req_c) = prerequisite-requirement_course.

      LOOP AT courses->get_values_table( ) INTO DATA(lobject).

        course ?= lobject.

        IF course->get_course( ) = my_req_c.
          DATA(next) = 'X'.
        ENDIF.

      ENDLOOP.

      IF next = 'X'.
        next = ' '.
        CONTINUE.
      ENDIF.

      course = NEW zcl_207_course_schedule_course( requirement_course = 222
                                                   course             = prerequisite-course  ).

      courses->put( key   = course->get_obj_key( )
*                    position =
                    value = course ).

    ENDLOOP.

    WHILE courses->get_values_iterator( )->has_next( ).

      DATA(another_course_has_been_taken) = ' '.

      LOOP AT courses->get_values_table( ) INTO DATA(object).

        course ?= object.

        IF course IS NOT BOUND.
          CONTINUE.
        ENDIF.

        IF course->check_is_course_done( ).
          CONTINUE.
        ENDIF.

        DATA(required_courses) = course->get_required_courses( courses ).

        IF    course->are_all_req_courses_done( required_courses )
           OR required_courses->if_object_map~is_empty( ).

          course->take_course( ).
          another_course_has_been_taken = 'X'.

        ENDIF.

      ENDLOOP.

      IF another_course_has_been_taken = abap_false.
        EXIT.
      ENDIF.

    ENDWHILE.

    DATA(number_of_taken_coureses) = 0.

    LOOP AT courses->get_values_table( ) INTO object.

      course ?= object.

      IF course->check_is_course_done( ).
        number_of_taken_coureses = number_of_taken_coureses + 1.
      ENDIF.

    ENDLOOP.

    IF number_of_taken_coureses >= numcourses.
      r_is_it_poss_to_take_all_crses = 'X'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
