SRCDIR=src/
LIBDIR=lib/

.PHONY: compile
compile:
	coffee --watch --output $(LIBDIR) $(SRCDIR)
