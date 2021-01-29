## libblastrampoline ##

ifneq ($(USE_BINARYBUILDER_LIBBLASTRAMPOLINE),1)

LIBBLASTRAMPOLINE_GIT_URL := git://github.com/staticfloat/libblastrampoline.git
LIBBLASTRAMPOLINE_TAR_URL = https://api.github.com/repos/staticfloat/libblastrampoline/tarball/$1
$(eval $(call git-external,libblastrampoline,LIBBLASTRAMPOLINE,,,$(BUILDDIR)))

$(BUILDDIR)/$(LIBBLASTRAMPOLINE_SRC_DIR)/build-configured: $(BUILDDIR)/$(LIBBLASTRAMPOLINE_SRC_DIR)/source-extracted
	mkdir -p $(dir $@)
	echo 1 > $@

$(BUILDDIR)/$(LIBBLASTRAMPOLINE_SRC_DIR)/build-compiled: $(BUILDDIR)/$(LIBBLASTRAMPOLINE_SRC_DIR)/build-configured
	cd $(dir $@)/src && $(MAKE) $(MAKE_COMMON)
	echo 1 > $@

define LIBBLASTRAMPOLINE_INSTALL
	mkdir -p $2/$$(build_shlibdir)
	cp $(BUILDDIR)/$(LIBBLASTRAMPOLINE_SRC_DIR)/src/libblastrampoline.$$(SHLIB_EXT) $2/$$(build_shlibdir)
endef
$(eval $(call staged-install, \
	libblastrampoline,$(LIBBLASTRAMPOLINE_SRC_DIR), \
	LIBBLASTRAMPOLINE_INSTALL,, \
	$$(LIBBLASTRAMPOLINE_OBJ_TARGET), \
	$$(INSTALL_NAME_CMD)libblastrampoline.$$(SHLIB_EXT) $$(build_shlibdir)/libblastrampoline.$$(SHLIB_EXT)))

clean-libblastrampoline:
	-rm $(BUILDDIR)/$(LIBBLASTRAMPOLINE_SRC_DIR)/build-compiled
	-rm $(BUILDDIR)/$(LIBBLASTRAMPOLINE_SRC_DIR)/libblastrampoline.$(SHLIB_EXT)

uninstall-libblastrampoline:
	-rm $(build_prefix)/manifest/libblastrampoline 
	-rm $(build_shlibdir)/libblastrampoline.$(SHLIB_EXT)

get-libblastrampoline: $(LIBBLASTRAMPOLINE_SRC_FILE)
extract-libblastrampoline: $(BUILDDIR)/$(LIBBLASTRAMPOLINE_SRC_DIR)/source-extracted
configure-libblastrampoline: extract-libblastrampoline
compile-libblastrampoline: $(BUILDDIR)/$(LIBBLASTRAMPOLINE_SRC_DIR)/build-compiled
fastcheck-libblastrampoline: check-libblastrampoline
check-libblastrampoline: compile-libblastrampoline

else

$(eval $(call bb-install,libblastrampoline,LIBBLASTRAMPOLINE,false))

endif # USE_BINARYBUILDER_LIBBLASTRAMPOLINE
