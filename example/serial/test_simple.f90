! This file is part of Fortuno.
! Licensed under the BSD-2-Clause Plus Patent license.
! SPDX-License-Identifier: BSD-2-Clause-Patent

!> Demonstrates the simplest possible testing scenario
module test_simple
  use mylib, only : factorial
  use fortuno_serial, only : is_equal, test => serial_case_item, check => serial_check,&
      & suite => serial_suite_item, test_list
  implicit none

  private
  public :: tests

contains


  ! Returns the tests from this module.
  function tests()
    type(test_list) :: tests

    tests = test_list([&
        ! Add one test without enclosing test suite (just for demonstration)
        test("factorial_0", test_factorial_0),&
        ! Add a test suite with further tests
        suite("simple", test_list([&
            test("factorial_1", test_factorial_1),&
            test("factorial_2", test_factorial_2)&
        ]))&
    ])

  end function tests

  ! Test: 0! = 1
  subroutine test_factorial_0()
    call check(factorial(0) == 1)
  end subroutine test_factorial_0

  ! Test: 1! = 1
  subroutine test_factorial_1()
    call check(factorial(1) == 1)
  end subroutine test_factorial_1

  ! Test: 2! = 2 (will fail due to the bug in the factorial() function in mylib)
  subroutine test_factorial_2()
    ! Both check will fail, you should see info about both in the output
    call check(is_equal(factorial(2), 2),&
        & msg="Test failed for demonstration purposes",&
        & file="test_simple.f90",&
        & line=47)
    call check(factorial(2) == 2)
  end subroutine test_factorial_2

end module test_simple
