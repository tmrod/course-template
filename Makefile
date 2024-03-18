# if you have more lectures: LECS = 01 02 03 04 ...
LECS = 01 02
LECNAMES = $(addprefix lec,$(LECS))

# if you have more homeworks: HWS = 01 02 03 04 05 ...
HWS = 01 02
HWNAMES = $(addprefix hw,$(HWS))
HWSOLNAMES = $(addprefix sol,$(HWS))

# if you have more exams: EXAMS = 01 02 03
EXAMS = 01 02
EXAMNAMES = $(addprefix exam,$(EXAMS))
EXAMSOLNAMES = $(addprefix examsol,$(EXAMS))

# where to put final products
BUILD_DIR = 00_coursefiles

# config files for course
# we could technically be more granular, but I won't bother
CONFIGS := calendar_config.tex calendar_slide.tex course_config.tex

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

all: init calendar syllabus lectures homework exams

.PHONY: init
init:
	mkdir -pv $(BUILD_DIR)

# builds lectures
.PHONY: lectures
lectures: $(LECNAMES)

# builds both homeworks and solutions
.PHONY: homework
homework: $(HWNAMES) $(HWSOLNAMES)

# builds both exams and solutions
.PHONY: exams
exams: $(EXAMNAMES) $(EXAMSOLNAMES)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# "aliases"
# convenient way of defining targets in build dir
define NAME_alias =
 .PHONY: $(1)
 $(1): $$(BUILD_DIR)/$(1).pdf
endef

$(foreach f,$(LECNAMES),$(eval $(call NAME_alias,$(f)))) # lec01, lec02, ...
$(foreach f,$(HWNAMES),$(eval $(call NAME_alias,$(f)))) # hw01, hw02, ...
$(foreach f,$(HWSOLNAMES),$(eval $(call NAME_alias,$(f)))) # sol01, sol02, ...
$(foreach f,$(EXAMNAMES),$(eval $(call NAME_alias,$(f)))) # exam01, exam02, ...
$(foreach f,$(EXAMSOLNAMES),$(eval $(call NAME_alias,$(f)))) # examsol01, examsol02, ...
$(eval $(call NAME_alias,calendar)) # calendar
$(eval $(call NAME_alias,syllabus)) # syllabus

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# calendar
$(BUILD_DIR)/calendar.pdf: syllabus/calendar.tex $(CONFIGS)
	latexmk -cd -auxdir=. -outdir=../$(BUILD_DIR)/ -output-format=pdf syllabus/calendar.tex

# syllabus
$(BUILD_DIR)/syllabus.pdf: syllabus/syllabus.tex $(CONFIGS)
	latexmk -cd -auxdir=. -outdir=../$(BUILD_DIR)/ -output-format=pdf syllabus/syllabus.tex

# lecture templates
define LEC_template =
 $$(BUILD_DIR)/lec$(1).pdf: lectures/lec$(1)/lec$(1).tex $$(CONFIGS) lectures/slide_preamble.tex
	latexmk -cd -auxdir=. -outdir=../../$$(BUILD_DIR) -output-format=pdf lectures/lec$(1)/lec$(1).tex
endef

$(foreach f,$(LECS),$(eval $(call LEC_template,$(f))))

# homework templates
define HW_template =
 $$(BUILD_DIR)/hw$(1).pdf: homework/hw$(1)/statement/hw$(1).tex $$(COURSECONFIG) homework/homework_preamble.tex
	latexmk -cd -auxdir=. -outdir=../../../$$(BUILD_DIR) -output-format=pdf homework/hw$(1)/statement/hw$(1).tex

 $$(BUILD_DIR)/sol$(1).pdf: homework/hw$(1)/solution/sol$(1).tex $$(COURSECONFIG) homework/homework_preamble.tex
	latexmk -cd -auxdir=. -outdir=../../../$$(BUILD_DIR) -output-format=pdf homework/hw$(1)/solution/sol$(1).tex
endef

$(foreach f,$(HWS),$(eval $(call HW_template,$(f))))

# exam templates
define EXAM_template =
 $$(BUILD_DIR)/exam$(1).pdf: exams/exam$(1)/statement/exam$(1).tex $$(COURSECONFIG) exams/exam_preamble.tex
	latexmk -cd -auxdir=. -outdir=../../../$$(BUILD_DIR) -output-format=pdf exams/exam$(1)/statement/exam$(1).tex

 $$(BUILD_DIR)/examsol$(1).pdf: exams/exam$(1)/solution/examsol$(1).tex $$(COURSECONFIG) exams/exam_preamble.tex
	latexmk -cd -auxdir=. -outdir=../../../$$(BUILD_DIR) -output-format=pdf exams/exam$(1)/solution/examsol$(1).tex
endef

$(foreach f,$(EXAMS),$(eval $(call EXAM_template,$(f))))
