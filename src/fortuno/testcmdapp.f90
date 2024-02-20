! This file is part of Fortuno.
! Licensed under the BSD-2-Clause Plus Patent license.
! SPDX-License-Identifier: BSD-2-Clause-Patent

!> Contains common code used by the various command line apps.
module fortuno_testcmdapp
  use fortuno_argumentparser, only : argtypes, argument_def, argument_values, argument_parser,&
      & init_argument_parser
  use fortuno_basetypes, only : test_item
  use fortuno_utils, only : string
  use fortuno_testdriver, only : test_driver, test_selection
  use fortuno_testlogger, only : test_logger
  implicit none

  private
  public :: test_cmd_app
  public :: get_selections
  public :: default_argument_defs


  !> App for driving tests through command line app.
  type :: test_cmd_app
    class(test_logger), allocatable :: logger
    class(test_driver), allocatable :: driver
    type(argument_values) :: argvals
  contains
    procedure :: run => test_cmd_app_run
    procedure :: parse_args => test_cmd_app_parse_args
    procedure :: register_tests => test_cmd_app_register_tests
    procedure :: run_tests => test_cmd_app_run_tests
  end type test_cmd_app


contains

  !> Runs the command line app (calls parse_args(), register_tests() and run_tests()).
  subroutine test_cmd_app_run(this, testitems, exitcode)

    !> instance
    class(test_cmd_app), intent(inout) :: this

    !> test items to be considered by the app
    type(test_item), intent(in) :: testitems(:)

    !> exit code of the run
    integer, intent(out) :: exitcode

    call this%parse_args(exitcode)
    if (exitcode >= 0) return
    call this%register_tests(testitems, exitcode)
    if (exitcode >= 0) return
    call this%run_tests(exitcode)

  end subroutine test_cmd_app_run


  !> Parses the command line arguments.
  subroutine test_cmd_app_parse_args(this, exitcode)

    !> instance
    class(test_cmd_app), intent(inout) :: this

    !> exit code (-1 if processing can continue, >=0 if program should stop with that exit code)
    integer, intent(out) :: exitcode

    type(argument_parser) :: argparser

    call init_argument_parser(argparser,&
        & description="Command line app for driving Fortuno unit tests.",&
        & argdefs=default_argument_defs()&
        & )
    call argparser%parse_args(this%argvals, this%logger, exitcode)

  end subroutine test_cmd_app_parse_args


  !> Register all tests which should be considered.
  subroutine test_cmd_app_register_tests(this, testitems, exitcode)

    !> Initialized instance on exit.
    class(test_cmd_app), intent(inout) :: this

    !> items to be considered by the app
    type(test_item), intent(in) :: testitems(:)

    !> exit code (-1, if processing can continue, >= 0 otherwise)
    integer, intent(out) :: exitcode

    type(test_selection), allocatable :: selections(:)
    type(string), allocatable :: selectors(:), testnames(:)
    integer :: itest

    exitcode = -1
    if (this%argvals%has("tests")) then
      call this%argvals%get_value("tests", selectors)
      call get_selections(selectors, selections)
    end if
    call this%driver%register_tests(testitems, selections=selections)

    if (this%argvals%has("list")) then
      call this%driver%get_test_names(testnames)
      do itest = 1, size(testnames)
        call this%logger%log_message(testnames(itest)%content)
      end do
      exitcode = 0
      return
    end if

  end subroutine test_cmd_app_register_tests


  !> Runs the initialized app.
  subroutine test_cmd_app_run_tests(this, exitcode)

    !> instance
    class(test_cmd_app), intent(inout) :: this

    !> exit code of the test run (0 - success, 1 - failure)
    integer, intent(out) :: exitcode

    logical :: exitonfailure_

    call this%driver%run_tests(this%logger)
    if (this%driver%driveresult%successful) then
      exitcode = 0
    else
      exitcode = 1
    end if

  end subroutine test_cmd_app_run_tests


  !> Converts test selector expressions to test selections.
  subroutine get_selections(selectors, selections)

    !> selector expressions
    type(string), intent(in) :: selectors(:)

    !> array of selections on exit
    type(test_selection), allocatable, intent(out) :: selections(:)

    integer :: ii

    allocate(selections(size(selectors)))
    do ii = 1, size(selectors)
      associate(selector => selectors(ii)%content, selection => selections(ii))
        if (selector(1:1) == "~") then
          selection%name = selector(2:)
          selection%selectiontype = "-"
        else
          selection%name = selector
          selection%selectiontype = "+"
        end if
      end associate
    end do

  end subroutine get_selections


  !> Returns the default argument definitions for the command line apps.
  function default_argument_defs() result(argdefs)

    !> argument defintions
    type(argument_def), allocatable :: argdefs(:)

    argdefs = [&
        & &
        & argument_def("list", argtypes%bool, shortopt="l", longopt="list",&
        & helpmsg="show list of tests to run and exit"),&
        & &
        & argument_def("tests", argtypes%stringlist,&
        & helpmsg="list of tests and suites to include or to exclude when prefixed with '~' (e.g.&
        & 'somesuite ~somesuite/avoidedtest' would run all tests except 'avoidedtest' in the test&
        & suite 'somesuite')")&
        & &
        & ]

  end function default_argument_defs

end module fortuno_testcmdapp
