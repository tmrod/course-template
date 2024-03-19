# Course Template

## Overview

This repo serves as a template for "generic" courses.
The idea is to be able to fill in all of your homeworks, exams, lectures, etc. once, and then reuse them each semester.
To reuse them, you change the "metadata" for the semester by modifying a handful of shared config files.
These config files contain information about the course calendar, due dates, and so on.
Then, a Makefile handles building all of the course materials.

## Make commands

The beginning of the makefile defines lists that index the set of lectures, homeworks, exams, etc.
Lectures, homeworks, and exams should follow the format in the repo.
Once you've defined these lists of objects by modifying the Makefile, you can run `make -k all` to make all of the course files, which will be stored in a directory called `00_coursefiles`.

The makefile also allows to build things on a finer level.
For instance, `make exam02` will compile the second exam, found in `exams/exam02/`.
Or `make hw04` will compile the fourth homework, and `make lec11` will compile the eleventh lecture.

A lingering TODO entry is to implement all of the appropriate `make clean` commands.

## Configuration

To get the basic "metadata" for the course in place, modify the contents of `course_config.tex`.
The most interesting part of that file is a collection of lists, such as `\examdates`, which gives a list of dates that exams are meant to be taken on.
These are $0$-indexed lists, which can be accessed using `pgf` (notice the `\usepackage{pgfmath}` at the top of `course_config.tex`).
See `lectures/lec02/lec02.tex` for an example of how this works.

In addition to that, you need to modify `calendar_config.tex` and `calendar_slide.tex` to get the course calendar working nicely.

A lingering TODO entry is to make the calendar automatically pull the dates from `course_config.tex`.
I tried doing this with a for-loop, but LaTeX was not happy with me doing that.
