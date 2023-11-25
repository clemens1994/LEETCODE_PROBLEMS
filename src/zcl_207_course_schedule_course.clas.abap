CLASS zcl_207_course_schedule_course DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS are_all_req_courses_done
      IMPORTING required_courses      TYPE REF TO cl_object_map
      RETURNING VALUE(r_are_all_done) TYPE xfeld.

    METHODS get_course
      RETURNING VALUE(course) TYPE int1.

    METHODS get_required_courses
      IMPORTING courses                 TYPE REF TO cl_object_map
      RETURNING VALUE(required_courses) TYPE REF TO cl_object_map.

    METHODS get_requirement_course
      RETURNING VALUE(requirement_course) TYPE int1.

    METHODS take_course.

    METHODS check_is_course_done
      RETURNING VALUE(is_course_done) TYPE xfeld.

    METHODS constructor
      IMPORTING requirement_course TYPE int1
                course             TYPE int1.

    METHODS get_obj_key
      RETURNING VALUE(key) TYPE string.

  PRIVATE SECTION.
    DATA m_course             TYPE int1.
    DATA m_requirement_course TYPE int1.
    DATA m_is_course_done     TYPE xfeld.
ENDCLASS.


CLASS zcl_207_course_schedule_course IMPLEMENTATION.
  METHOD are_all_req_courses_done.
    LOOP AT required_courses->get_values_table( ) INTO DATA(object).

      DATA(course) = CAST zcl_207_course_schedule_course( object ).

      IF NOT course->check_is_course_done( ).
        r_are_all_done = abap_false.
        RETURN.
      ENDIF.

    ENDLOOP.

    r_are_all_done = 'X'.
  ENDMETHOD.

  METHOD check_is_course_done.
    is_course_done = m_is_course_done.
  ENDMETHOD.

  METHOD constructor.
    m_requirement_course = requirement_course.
    m_course             = course.
  ENDMETHOD.

  METHOD get_course.
    course = m_course.
  ENDMETHOD.

  METHOD get_obj_key.
    key = m_course && m_requirement_course.
  ENDMETHOD.

  METHOD get_required_courses.
    required_courses = NEW #( ).

    LOOP AT courses->get_values_table( ) INTO DATA(object).

      DATA(course) = CAST zcl_207_course_schedule_course( object ).

      IF course->get_obj_key( ) = get_obj_key( ).
        CONTINUE.
      ENDIF.

      IF m_requirement_course = course->get_course( ).

        required_courses->put( key   = course->get_obj_key( )
                               value = course ).

      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_requirement_course.
    requirement_course = m_requirement_course.
  ENDMETHOD.

  METHOD take_course.
    m_is_course_done = abap_true.
  ENDMETHOD.
ENDCLASS.
