
# Figure out how to ask if gcc vs clang, gcc only right now
ifeq "0" "1"
CPPUTEST_WARNINGFLAGS += -Wno-unknown-warning-option
CPPUTEST_WARNINGFLAGS += -Wno-covered-switch-default
CPPUTEST_WARNINGFLAGS += -Wno-reserved-id-macro
CPPUTEST_WARNINGFLAGS += -Wno-keyword-macro
CPPUTEST_WARNINGFLAGS += -Wno-documentation
CPPUTEST_WARNINGFLAGS += -Wno-missing-noreturn
endif

CPPUTEST_WARNINGFLAGS += -Wall 
CPPUTEST_WARNINGFLAGS += -Werror
CPPUTEST_WARNINGFLAGS += -Wswitch-default
CPPUTEST_WARNINGFLAGS += -Wno-format-nonliteral
CPPUTEST_WARNINGFLAGS += -Wno-sign-conversion 
CPPUTEST_WARNINGFLAGS += -Wno-pedantic 
CPPUTEST_WARNINGFLAGS += -Wno-shadow
CPPUTEST_WARNINGFLAGS += -Wno-missing-field-initializers
CPPUTEST_WARNINGFLAGS += -Wno-unused-parameter
CPPUTEST_CFLAGS += -Wall
CPPUTEST_CFLAGS += -Wstrict-prototypes
CPPUTEST_CFLAGS += -pedantic
CPPUTEST_CFLAGS += -Wno-missing-prototypes

# Compatibility mode: compile with the language standards the book code was
# written for, so newer compilers don't change its meaning (e.g. C23's f() == f(void)).
CPPUTEST_CFLAGS += -std=gnu99
CPPUTEST_CXXFLAGS += -std=gnu++11

# Warnings added to newer gcc versions that the book code was never written for.
CPPUTEST_CFLAGS += -Wno-enum-int-mismatch
