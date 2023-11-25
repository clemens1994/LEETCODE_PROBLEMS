CLASS ltcl_207 DEFINITION DEFERRED.
CLASS zcl_207_course_schedule_solve DEFINITION LOCAL FRIENDS ltcl_207.
CLASS ltcl_207 DEFINITION
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  " ?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
  " ?<asx:values>
  " ?<TESTCLASS_OPTIONS>
  " ?<TEST_CLASS>ltcl_207
  " ?</TEST_CLASS>
  " ?<TEST_MEMBER>f_Cut
  " ?</TEST_MEMBER>
  " ?<OBJECT_UNDER_TEST>ZCL_207
  " ?</OBJECT_UNDER_TEST>
  " ?<OBJECT_IS_LOCAL/>
  " ?<GENERATE_FIXTURE/>
  " ?<GENERATE_CLASS_FIXTURE/>
  " ?<GENERATE_INVOCATION/>
  " ?<GENERATE_ASSERT_EQUAL/>
  " ?</TESTCLASS_OPTIONS>
  " ?</asx:values>
  " ?</asx:abap>

  PRIVATE SECTION.
    CLASS-DATA f_cut TYPE REF TO zcl_207_course_schedule_solve. " class under test

    CLASS-METHODS class_setup.

    METHODS test_minimal                  FOR TESTING.
    METHODS test_single_with_prerequisite FOR TESTING.
    METHODS test_cyclic_prerequisites     FOR TESTING.
    METHODS test_no_prerequisites         FOR TESTING.
    METHODS test_complex_prerequisites    FOR TESTING.
    METHODS test_impossible_cyclic        FOR TESTING.
    METHODS test_single_multiple_prereq   FOR TESTING.
    METHODS test_same_prerequisite        FOR TESTING.

ENDCLASS.


CLASS ltcl_207 IMPLEMENTATION.
  METHOD class_setup.
    f_cut = NEW zcl_207_course_schedule_solve( ).
  ENDMETHOD.

  METHOD test_minimal.
    DATA numcourses    TYPE i VALUE 1.
    DATA prerequisites TYPE ztt_207_tuple.
    DATA result        TYPE abap_bool.
    DATA prerequisite  TYPE zst_207_tuple.

    prerequisite-course             = 0.
    prerequisite-requirement_course = 0.
    APPEND prerequisite TO prerequisites.

    result = f_cut->is_it_poss_to_take_all_courses( numcourses    = numcourses
                                                    prerequisites = prerequisites ).

    cl_aunit_assert=>assert_equals( act = result
                                    exp = abap_true ).
  ENDMETHOD.

  METHOD test_single_with_prerequisite.
    DATA numcourses    TYPE i VALUE 2.
    DATA prerequisites TYPE ztt_207_tuple.
    DATA result        TYPE abap_bool.
    DATA prerequisite  TYPE zst_207_tuple.

    prerequisite-course             = 1.
    prerequisite-requirement_course = 0.
    APPEND prerequisite TO prerequisites.

    result = f_cut->is_it_poss_to_take_all_courses( numcourses    = numcourses
                                                    prerequisites = prerequisites ).

    cl_aunit_assert=>assert_equals( act = result
                                    exp = abap_true ).
  ENDMETHOD.

  METHOD test_cyclic_prerequisites.
    DATA numcourses    TYPE i VALUE 2.
    DATA prerequisites TYPE ztt_207_tuple.
    DATA result        TYPE abap_bool.
    DATA prerequisite1 TYPE zst_207_tuple.
    DATA prerequisite2 TYPE zst_207_tuple.

    prerequisite1-course             = 1.
    prerequisite1-requirement_course = 0.
    prerequisite2-course             = 0.
    prerequisite2-requirement_course = 1.

    APPEND prerequisite1 TO prerequisites.
    APPEND prerequisite2 TO prerequisites.

    result = f_cut->is_it_poss_to_take_all_courses( numcourses    = numcourses
                                                    prerequisites = prerequisites ).

    cl_aunit_assert=>assert_equals( act = result
                                    exp = abap_false ).
  ENDMETHOD.

  METHOD test_no_prerequisites.
    DATA numcourses    TYPE i VALUE 3.
    DATA prerequisites TYPE ztt_207_tuple.
    DATA result        TYPE abap_bool.

    result = f_cut->is_it_poss_to_take_all_courses( numcourses    = numcourses
                                                    prerequisites = prerequisites ).

    cl_aunit_assert=>assert_equals( act = result
                                    exp = abap_true ).
  ENDMETHOD.

  METHOD test_complex_prerequisites.
    DATA numcourses    TYPE i VALUE 6.
    DATA prerequisites TYPE ztt_207_tuple.
    DATA result        TYPE abap_bool.
    DATA prerequisite  TYPE zst_207_tuple.

    prerequisite-course             = 1.
    prerequisite-requirement_course = 0.
    APPEND prerequisite TO prerequisites.

    prerequisite-course             = 2.
    prerequisite-requirement_course = 1.
    APPEND prerequisite TO prerequisites.

    prerequisite-course             = 3.
    prerequisite-requirement_course = 2.
    APPEND prerequisite TO prerequisites.

    prerequisite-course             = 4.
    prerequisite-requirement_course = 3.
    APPEND prerequisite TO prerequisites.

    prerequisite-course             = 5.
    prerequisite-requirement_course = 4.
    APPEND prerequisite TO prerequisites.

    result = f_cut->is_it_poss_to_take_all_courses( numcourses    = numcourses
                                                    prerequisites = prerequisites ).

    cl_aunit_assert=>assert_equals( act = result
                                    exp = abap_true ).
  ENDMETHOD.

  METHOD test_impossible_cyclic.
    DATA numcourses    TYPE i VALUE 4.
    DATA prerequisites TYPE ztt_207_tuple.
    DATA result        TYPE abap_bool.
    DATA prerequisite  TYPE zst_207_tuple.

    prerequisite-course             = 0.
    prerequisite-requirement_course = 1.
    APPEND prerequisite TO prerequisites.

    prerequisite-course             = 1.
    prerequisite-requirement_course = 2.
    APPEND prerequisite TO prerequisites.

    prerequisite-course             = 2.
    prerequisite-requirement_course = 3.
    APPEND prerequisite TO prerequisites.

    prerequisite-course             = 3.
    prerequisite-requirement_course = 0.
    APPEND prerequisite TO prerequisites.

    result = f_cut->is_it_poss_to_take_all_courses( numcourses    = numcourses
                                                    prerequisites = prerequisites ).

    cl_aunit_assert=>assert_equals( act = result
                                    exp = abap_false ).
  ENDMETHOD.

  METHOD test_single_multiple_prereq.
    DATA numcourses    TYPE i VALUE 1.
    DATA prerequisites TYPE ztt_207_tuple.
    DATA result        TYPE abap_bool.
    DATA prerequisite1 TYPE zst_207_tuple.
    DATA prerequisite2 TYPE zst_207_tuple.
    DATA prerequisite3 TYPE zst_207_tuple.

    "
    prerequisite1-course             = 0.
    prerequisite1-requirement_course = 1.
    APPEND prerequisite1 TO prerequisites.

    prerequisite2-course             = 0.
    prerequisite2-requirement_course = 2.
    APPEND prerequisite2 TO prerequisites.

    prerequisite3-course             = 0.
    prerequisite3-requirement_course = 3.
    APPEND prerequisite3 TO prerequisites.

    result = f_cut->is_it_poss_to_take_all_courses( numcourses    = numcourses
                                                    prerequisites = prerequisites ).

    cl_aunit_assert=>assert_equals( act = result
                                    exp = abap_true ).
  ENDMETHOD.

  METHOD test_same_prerequisite.
    DATA numcourses    TYPE i VALUE 4.
    DATA prerequisites TYPE ztt_207_tuple.
    DATA result        TYPE abap_bool.
    DATA prerequisite1 TYPE zst_207_tuple.
    DATA prerequisite2 TYPE zst_207_tuple.
    DATA prerequisite3 TYPE zst_207_tuple.

    prerequisite1-course             = 0.
    prerequisite1-requirement_course = 1.
    APPEND prerequisite1 TO prerequisites.

    prerequisite2-course             = 2.
    prerequisite2-requirement_course = 1.
    APPEND prerequisite2 TO prerequisites.

    prerequisite3-course             = 3.
    prerequisite3-requirement_course = 1.
    APPEND prerequisite3 TO prerequisites.

    result = f_cut->is_it_poss_to_take_all_courses( numcourses    = numcourses
                                                    prerequisites = prerequisites ).

    cl_aunit_assert=>assert_equals( act = result
                                    exp = abap_true ).
  ENDMETHOD.
ENDCLASS.
