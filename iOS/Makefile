SUBDIRS = hooks templates

.PHONY : subdirs $(SUBDIRS)

subdirs : $(SUBDIRS)

$(SUBDIRS) :
	$(MAKE) -C $@
