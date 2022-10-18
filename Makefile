CC        = gcc
CFLAGS    = -std=gnu99 -O0 -pthread -Wall -Werror
STRIP     = strip

TOP       = $(shell pwd)
SOURCEDIR = $(TOP)/code
OUTPUTDIR = $(TOP)/output
DIRS      = $(OUTPUTDIR)

SOURCE    = $(notdir $(wildcard $(SOURCEDIR)/*.c))
OBJECT    = $(SOURCE:.c=)
TARGET    = $(addprefix $(OUTPUTDIR)/,$(OBJECT))

.PHONY: all
all: $(OUTPUTDIR) $(TARGET)

.PHONY: clean
clean:
	rm -rfv $(OUTPUTDIR)

$(DIRS):
	mkdir -p $@

$(OUTPUTDIR)/%: $(SOURCEDIR)/%.c
	@echo "  CC $< -> $@"
	@$(CC) $(CFLAGS) -o $@ $<
	@$(STRIP) -s $@
	@echo "  CC [DEBUG] $< -> $@.debug"
	@$(CC) $(CFLAGS) -g -o $@.debug $<
